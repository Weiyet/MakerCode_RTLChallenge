`timescale 1ns/1ps

module tb;

    parameter DATA_WIDTH = 8;
    parameter ACC_WIDTH = DATA_WIDTH * 2 + 8;

    reg                         clk;
    reg                         rst_n;
    reg                         clear;
    reg                         in_valid;
    reg signed [DATA_WIDTH-1:0] in_a;
    reg signed [DATA_WIDTH-1:0] in_b;
    reg                         in_last;
    reg                         out_ready;
    wire                        in_ready;
    wire                        out_valid;
    wire signed [ACC_WIDTH-1:0] out_acc;

    mac_unit #(.DATA_WIDTH(DATA_WIDTH)) dut (
        .clk(clk), .rst_n(rst_n), .clear(clear),
        .in_valid(in_valid), .in_a(in_a), .in_b(in_b), .in_last(in_last),
        .out_ready(out_ready), .in_ready(in_ready),
        .out_valid(out_valid), .out_acc(out_acc)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    integer test_num, errors, fd, status, num_tests, i, num_pairs;
    integer dq [$];
    reg signed [DATA_WIDTH-1:0] vec_a [0:15];
    reg signed [DATA_WIDTH-1:0] vec_b [0:15];
    reg signed [ACC_WIDTH-1:0] expected_acc;

    initial begin
        errors = 0;
        // Embedded test vectors (was input_vector.txt)
        dq.push_back(5); dq.push_back(3); dq.push_back(1); dq.push_back(4); dq.push_back(2); dq.push_back(5); dq.push_back(3); dq.push_back(6);
        dq.push_back(4); dq.push_back(2); dq.push_back(2); dq.push_back(3); dq.push_back(3); dq.push_back(4); dq.push_back(4); dq.push_back(5);
        dq.push_back(5); dq.push_back(2); dq.push_back(10); dq.push_back(10); dq.push_back(-5); dq.push_back(5); dq.push_back(5); dq.push_back(1);
        dq.push_back(1); dq.push_back(1); dq.push_back(1); dq.push_back(1); dq.push_back(1); dq.push_back(1); dq.push_back(1); dq.push_back(1);
        dq.push_back(1); dq.push_back(3); dq.push_back(-2); dq.push_back(3); dq.push_back(4); dq.push_back(-5); dq.push_back(6); dq.push_back(7);

        num_tests = dq.pop_front();
        rst_n = 0; clear = 0; in_valid = 0; in_a = 0; in_b = 0; in_last = 0; out_ready = 0;

        repeat(5) @(posedge clk); rst_n = 1; repeat(2) @(posedge clk);

        for (test_num = 0; test_num < num_tests; test_num = test_num + 1) begin
            num_pairs = dq.pop_front();
            expected_acc = 0;
            for (i = 0; i < num_pairs; i = i + 1) begin
                vec_a[i] = dq.pop_front();
                vec_b[i] = dq.pop_front();
                expected_acc = expected_acc + (vec_a[i] * vec_b[i]);
            end

            // Clear and start MAC
            @(posedge clk); clear = 1;
            @(posedge clk); clear = 0;

            i = 0;
            in_valid <= 1'b1;
            while (i < num_pairs) begin
                in_a <= vec_a[i];
                in_b <= vec_b[i];
                in_last <= (i == num_pairs - 1);
                @(posedge clk);
                if (in_ready) i = i + 1;
            end
            in_valid <= 1'b0; in_last <= 1'b0;

            out_ready = 1;
            @(posedge clk);
            while (!out_valid) @(posedge clk);

            if (out_acc !== expected_acc) begin
                $display("Test %0d FAILED: expected %0d, got %0d", test_num, expected_acc, out_acc);
                errors = errors + 1;
            end else begin
                $display("Test %0d PASSED: acc = %0d", test_num, out_acc);
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
