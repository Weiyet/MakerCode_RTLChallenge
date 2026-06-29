`timescale 1ns/1ps

module tb;

    parameter DATA_WIDTH = 8;
    localparam DIST_WIDTH = $clog2(DATA_WIDTH + 1);

    reg                      clk;
    reg                      rst_n;
    reg                      in_valid;
    reg [DATA_WIDTH-1:0]     in_a;
    reg [DATA_WIDTH-1:0]     in_b;
    reg                      out_ready;
    wire                     in_ready;
    wire                     out_valid;
    wire [DIST_WIDTH-1:0]    out_dist;

    // Instantiate DUT
    hamming_dist #(
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .in_valid(in_valid),
        .in_a(in_a),
        .in_b(in_b),
        .out_ready(out_ready),
        .in_ready(in_ready),
        .out_valid(out_valid),
        .out_dist(out_dist)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Test variables
    integer test_num;
    integer errors;
    integer fd;
    integer dq [$];
    integer status;
    integer num_tests;
    integer i;

    // Test case storage
    reg [DATA_WIDTH-1:0] test_a, test_b;
    reg [DIST_WIDTH-1:0] expected_dist;

    // Reference model - popcount of XOR
    function [DIST_WIDTH-1:0] calc_hamming;
        input [DATA_WIDTH-1:0] a, b;
        reg [DATA_WIDTH-1:0] x;
        integer k, cnt;
    begin
        x = a ^ b;
        cnt = 0;
        for (k = 0; k < DATA_WIDTH; k = k + 1)
            if (x[k]) cnt = cnt + 1;
        calc_hamming = cnt;
    end
    endfunction

    // Read test vector file
    initial begin
        errors = 0;

        // Embedded test vectors (was input_vector.txt)
        dq.push_back(10); dq.push_back(170); dq.push_back(85); dq.push_back(204); dq.push_back(195); dq.push_back(255); dq.push_back(0); dq.push_back(0);
        dq.push_back(0); dq.push_back(128); dq.push_back(64); dq.push_back(15); dq.push_back(240); dq.push_back(1); dq.push_back(2); dq.push_back(7);
        dq.push_back(7); dq.push_back(100); dq.push_back(100); dq.push_back(123); dq.push_back(231);

        num_tests = dq.pop_front();

        // Reset
        rst_n = 0;
        in_valid = 0;
        in_a = 0;
        in_b = 0;
        out_ready = 0;

        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(2) @(posedge clk);

        for (test_num = 0; test_num < num_tests; test_num = test_num + 1) begin
            // Read test case
            test_a = dq.pop_front();
            test_b = dq.pop_front();

            expected_dist = calc_hamming(test_a, test_b);

            // Send input and capture result with a concurrent handshake
            // (deassert in_valid once accepted, capture on out_valid).
            in_valid  <= 1'b1;
            in_a      <= test_a;
            in_b      <= test_b;
            out_ready <= 1'b1;
            i = 0;
            while (!i) begin
                @(posedge clk);
                if (in_ready) in_valid <= 1'b0;
                if (out_valid) begin
                    if (out_dist !== expected_dist) begin
                        $display("Test %0d FAILED: hamming(%0d, %0d) Expected %0d, Got %0d",
                                 test_num, test_a, test_b, expected_dist, out_dist);
                        errors = errors + 1;
                    end else begin
                        $display("Test %0d PASSED: hamming(%0d, %0d) = %0d",
                                 test_num, test_a, test_b, out_dist);
                    end
                    i = 1;
                end
            end

            out_ready <= 1'b0;
            repeat(2) @(posedge clk);
        end

        $display("\n====================");
        if (errors == 0)
            $display("ALL TESTS PASSED!");
        else
            $error("FAILED: %0d errors", errors);
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
