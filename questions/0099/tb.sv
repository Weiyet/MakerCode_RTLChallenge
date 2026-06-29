`timescale 1ns/1ps

module tb;

    parameter DATA_WIDTH = 8;
    parameter POOL_SIZE = 4;

    reg                  clk;
    reg                  rst_n;
    reg                  start;
    reg                  in_valid;
    reg [DATA_WIDTH-1:0] in_data;
    reg                  in_last;
    reg                  out_ready;
    wire                 in_ready;
    wire                 out_valid;
    wire [DATA_WIDTH-1:0] out_max;

    max_pool #(.DATA_WIDTH(DATA_WIDTH), .POOL_SIZE(POOL_SIZE)) dut (
        .clk(clk), .rst_n(rst_n), .start(start),
        .in_valid(in_valid), .in_data(in_data), .in_last(in_last),
        .out_ready(out_ready), .in_ready(in_ready),
        .out_valid(out_valid), .out_max(out_max)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    integer test_num, errors, fd, status, num_tests, i, pool_size;
    integer dq [$];
    reg [DATA_WIDTH-1:0] pool_vals [0:15];
    reg [DATA_WIDTH-1:0] expected_max;

    initial begin
        errors = 0;
        // Embedded test vectors (was input_vector.txt)
        dq.push_back(6); dq.push_back(4); dq.push_back(5); dq.push_back(9); dq.push_back(2); dq.push_back(7); dq.push_back(4); dq.push_back(1);
        dq.push_back(2); dq.push_back(3); dq.push_back(4); dq.push_back(4); dq.push_back(100); dq.push_back(50); dq.push_back(75); dq.push_back(25);
        dq.push_back(3); dq.push_back(10); dq.push_back(10); dq.push_back(10); dq.push_back(2); dq.push_back(255); dq.push_back(0); dq.push_back(6);
        dq.push_back(1); dq.push_back(5); dq.push_back(3); dq.push_back(8); dq.push_back(2); dq.push_back(6);

        num_tests = dq.pop_front();
        rst_n = 0; start = 0; in_valid = 0; in_data = 0; in_last = 0; out_ready = 0;

        repeat(5) @(posedge clk); rst_n = 1; repeat(2) @(posedge clk);

        for (test_num = 0; test_num < num_tests; test_num = test_num + 1) begin
            pool_size = dq.pop_front();
            expected_max = 0;
            for (i = 0; i < pool_size; i = i + 1) begin
                pool_vals[i] = dq.pop_front();
                if (pool_vals[i] > expected_max) expected_max = pool_vals[i];
            end

            @(posedge clk); start = 1;
            @(posedge clk); start = 0;

            i = 0;
            in_valid <= 1'b1;
            while (i < pool_size) begin
                in_data <= pool_vals[i];
                in_last <= (i == pool_size - 1);
                @(posedge clk);
                if (in_ready) i = i + 1;
            end
            in_valid <= 1'b0; in_last <= 1'b0;

            out_ready = 1;
            while (!out_valid) @(posedge clk);

            if (out_max !== expected_max) begin
                $display("Test %0d FAILED: expected %0d, got %0d", test_num, expected_max, out_max);
                errors = errors + 1;
            end else begin
                $display("Test %0d PASSED: max = %0d", test_num, out_max);
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
