`timescale 1ns/1ps

module tb;

    reg         clk;
    reg         rst_n;
    reg         start;
    reg         in_valid;
    reg [7:0]   in_data;
    reg         in_last;
    reg [15:0]  hdr_total_len;
    reg         out_ready;
    wire        in_ready;
    wire        out_valid;
    wire        out_len_ok;
    wire [15:0] out_actual_len;

    // Instantiate DUT
    pkt_len_validator dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .in_valid(in_valid),
        .in_data(in_data),
        .in_last(in_last),
        .hdr_total_len(hdr_total_len),
        .out_ready(out_ready),
        .in_ready(in_ready),
        .out_valid(out_valid),
        .out_len_ok(out_len_ok),
        .out_actual_len(out_actual_len)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Test variables
    integer test_num, errors, fd, status, num_tests, i;
    integer expected_len, actual_len;
    integer dq [$];
    reg expected_ok;

    initial begin
        errors = 0;

        // Embedded test vectors (was input_vector.txt)
        dq.push_back(6); dq.push_back(20); dq.push_back(20); dq.push_back(64); dq.push_back(64); dq.push_back(100); dq.push_back(100); dq.push_back(20);
        dq.push_back(18); dq.push_back(64); dq.push_back(70); dq.push_back(50); dq.push_back(50);

        num_tests = dq.pop_front();

        rst_n = 0; start = 0; in_valid = 0; in_data = 0; in_last = 0;
        hdr_total_len = 0; out_ready = 0;

        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(2) @(posedge clk);

        for (test_num = 0; test_num < num_tests; test_num = test_num + 1) begin
            expected_len = dq.pop_front();
            actual_len = dq.pop_front();
            expected_ok = (expected_len == actual_len);

            hdr_total_len = expected_len;

            @(posedge clk); start = 1;
            @(posedge clk); start = 0;

            i = 0;
            in_valid <= 1'b1;
            while (i < actual_len) begin
                in_data <= i[7:0];
                in_last <= (i == actual_len - 1);
                @(posedge clk);
                if (in_ready) i = i + 1;
            end
            in_valid <= 1'b0; in_last <= 1'b0;

            out_ready = 1;
            while (!out_valid) @(posedge clk);

            if (out_len_ok !== expected_ok || out_actual_len !== actual_len) begin
                $display("Test %0d FAILED", test_num);
                errors = errors + 1;
            end else begin
                $display("Test %0d PASSED: len_ok=%d, actual=%d", test_num, out_len_ok, out_actual_len);
            end

            out_ready = 0;
            repeat(2) @(posedge clk);
        end

        $display("\n====================");
        if (errors == 0) $display("ALL TESTS PASSED!");
        else $error("FAILED: %0d errors", errors);
        $display("====================\n");
        $finish;
    end

    // Waveform dump (enabled via +VCDFILE=<file>)
    string filename;
    initial begin
        if ($value$plusargs("VCDFILE=%s", filename)) begin
            $dumpfile(filename);
            $dumpvars(0, dut);
        end
    end

endmodule
