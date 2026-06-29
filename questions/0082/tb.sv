`timescale 1ns/1ps

module tb;

    parameter DATA_WIDTH = 8;
    parameter SUM_WIDTH = DATA_WIDTH + 8;

    reg                      clk;
    reg                      rst_n;
    reg                      start;
    reg                      in_valid;
    reg [DATA_WIDTH-1:0]     in_data;
    reg                      out_ready;
    wire                     in_ready;
    wire                     out_valid;
    wire [SUM_WIDTH-1:0]     out_data;

    // Instantiate DUT
    prefix_sum #(
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .in_valid(in_valid),
        .in_data(in_data),
        .out_ready(out_ready),
        .in_ready(in_ready),
        .out_valid(out_valid),
        .out_data(out_data)
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
    integer j;

    // Test case storage
    reg [DATA_WIDTH-1:0] test_values [0:15];
    reg [SUM_WIDTH-1:0] expected_prefix [0:15];
    integer test_length;
    reg [SUM_WIDTH-1:0] running_sum;

    // Read test vector file
    initial begin
        errors = 0;

        // Embedded test vectors (was input_vector.txt)
        dq.push_back(8); dq.push_back(5); dq.push_back(5); dq.push_back(3); dq.push_back(7); dq.push_back(2); dq.push_back(8); dq.push_back(3);
        dq.push_back(10); dq.push_back(20); dq.push_back(30); dq.push_back(1); dq.push_back(42); dq.push_back(4); dq.push_back(1); dq.push_back(1);
        dq.push_back(1); dq.push_back(1); dq.push_back(6); dq.push_back(1); dq.push_back(2); dq.push_back(3); dq.push_back(4); dq.push_back(5);
        dq.push_back(6); dq.push_back(2); dq.push_back(100); dq.push_back(155); dq.push_back(5); dq.push_back(0); dq.push_back(0); dq.push_back(0);
        dq.push_back(0); dq.push_back(0); dq.push_back(4); dq.push_back(64); dq.push_back(32); dq.push_back(16); dq.push_back(8);

        num_tests = dq.pop_front();

        // Reset
        rst_n = 0;
        start = 0;
        in_valid = 0;
        in_data = 0;
        out_ready = 0;

        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(2) @(posedge clk);

        for (test_num = 0; test_num < num_tests; test_num = test_num + 1) begin
            // Read test case
            test_length = dq.pop_front();
            running_sum = 0;
            for (i = 0; i < test_length; i = i + 1) begin
                test_values[i] = dq.pop_front();
                running_sum = running_sum + test_values[i];
                expected_prefix[i] = running_sum;
            end

            $display("Test %0d: length=%0d", test_num, test_length);

            // Start sequence
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            // Send inputs and check outputs concurrently (the DUT is
            // one-in-one-out, so sender and receiver must run in parallel).
            out_ready = 1;
            fork
                begin : sender
                    for (i = 0; i < test_length; i = i + 1) begin
                        in_valid <= 1'b1;
                        in_data  <= test_values[i];
                        @(posedge clk);
                        while (!in_ready) @(posedge clk);
                        in_valid <= 1'b0;
                    end
                end
                begin : receiver
                    for (j = 0; j < test_length; j = j + 1) begin
                        @(posedge clk);
                        while (!out_valid) @(posedge clk);
                        if (out_data !== expected_prefix[j]) begin
                            $display("  Element %0d FAILED: Expected %0d, Got %0d",
                                     j, expected_prefix[j], out_data);
                            errors = errors + 1;
                        end
                    end
                end
            join
            out_ready = 0;

            $display("  Test %0d completed", test_num);
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
