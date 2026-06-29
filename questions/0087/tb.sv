`timescale 1ns/1ps

module tb;

    parameter DATA_WIDTH = 8;
    localparam COUNT_WIDTH = $clog2(DATA_WIDTH + 1);

    reg                      clk;
    reg                      rst_n;
    reg                      in_valid;
    reg [DATA_WIDTH-1:0]     in_data;
    reg                      out_ready;
    wire                     in_ready;
    wire                     out_valid;
    wire [COUNT_WIDTH-1:0]   out_count;

    // Instantiate DUT
    trailing_zero #(
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .in_valid(in_valid),
        .in_data(in_data),
        .out_ready(out_ready),
        .in_ready(in_ready),
        .out_valid(out_valid),
        .out_count(out_count)
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
    reg [DATA_WIDTH-1:0] test_val;
    reg [COUNT_WIDTH-1:0] expected_count;

    // Reference model - count trailing zeros
    function [COUNT_WIDTH-1:0] calc_trailing;
        input [DATA_WIDTH-1:0] val;
        integer k, cnt;
    begin
        cnt = 0;
        for (k = 0; k < DATA_WIDTH; k = k + 1) begin
            if (val[k] == 1'b0)
                cnt = cnt + 1;
            else
                k = DATA_WIDTH; // Break
        end
        calc_trailing = cnt;
    end
    endfunction

    // Read test vector file
    initial begin
        errors = 0;

        // Embedded test vectors (was input_vector.txt)
        dq.push_back(12); dq.push_back(88); dq.push_back(1); dq.push_back(2); dq.push_back(4); dq.push_back(8); dq.push_back(16); dq.push_back(32);
        dq.push_back(64); dq.push_back(128); dq.push_back(0); dq.push_back(255); dq.push_back(170);

        num_tests = dq.pop_front();

        // Reset
        rst_n = 0;
        in_valid = 0;
        in_data = 0;
        out_ready = 0;

        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(2) @(posedge clk);

        for (test_num = 0; test_num < num_tests; test_num = test_num + 1) begin
            // Read test case
            test_val = dq.pop_front();

            expected_count = calc_trailing(test_val);

            // Send input and capture result with a concurrent handshake
            in_valid  <= 1'b1;
            in_data   <= test_val;
            out_ready <= 1'b1;
            i = 0;
            while (!i) begin
                @(posedge clk);
                if (in_ready) in_valid <= 1'b0;
                if (out_valid) begin
                    if (out_count !== expected_count) begin
                        $display("Test %0d FAILED: trailing_zeros(%0d) Expected %0d, Got %0d",
                                 test_num, test_val, expected_count, out_count);
                        errors = errors + 1;
                    end else begin
                        $display("Test %0d PASSED: trailing_zeros(%0d) = %0d",
                                 test_num, test_val, out_count);
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
