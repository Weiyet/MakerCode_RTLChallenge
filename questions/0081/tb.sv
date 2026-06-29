`timescale 1ns/1ps

module tb;

    parameter DATA_WIDTH = 8;
    parameter SUM_WIDTH = DATA_WIDTH + 8;

    reg                      clk;
    reg                      rst_n;
    reg                      start;
    reg                      in_valid;
    reg [DATA_WIDTH-1:0]     in_data;
    reg                      in_last;
    reg                      out_ready;
    wire                     in_ready;
    wire                     out_valid;
    wire [SUM_WIDTH-1:0]     out_sum;

    // Instantiate DUT
    stream_accum #(
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .in_valid(in_valid),
        .in_data(in_data),
        .in_last(in_last),
        .out_ready(out_ready),
        .in_ready(in_ready),
        .out_valid(out_valid),
        .out_sum(out_sum)
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
    integer i, j;

    // Test case storage
    reg [DATA_WIDTH-1:0] test_values [0:15];
    integer test_length;
    reg [SUM_WIDTH-1:0] expected_sum;
    reg [SUM_WIDTH-1:0] actual_sum;

    // Reference model
    function [SUM_WIDTH-1:0] calc_sum;
        input integer len;
        integer k;
        reg [SUM_WIDTH-1:0] sum;
    begin
        sum = 0;
        for (k = 0; k < len; k = k + 1) begin
            sum = sum + test_values[k];
        end
        calc_sum = sum;
    end
    endfunction

    // Read test vector file
    initial begin
        errors = 0;

        // Embedded test vectors (was input_vector.txt)
        dq.push_back(10); dq.push_back(5); dq.push_back(5); dq.push_back(10); dq.push_back(3); dq.push_back(7); dq.push_back(15); dq.push_back(3);
        dq.push_back(1); dq.push_back(2); dq.push_back(3); dq.push_back(1); dq.push_back(100); dq.push_back(4); dq.push_back(25); dq.push_back(25);
        dq.push_back(25); dq.push_back(25); dq.push_back(6); dq.push_back(1); dq.push_back(2); dq.push_back(3); dq.push_back(4); dq.push_back(5);
        dq.push_back(6); dq.push_back(2); dq.push_back(128); dq.push_back(127); dq.push_back(8); dq.push_back(10); dq.push_back(20); dq.push_back(30);
        dq.push_back(40); dq.push_back(50); dq.push_back(60); dq.push_back(70); dq.push_back(80); dq.push_back(4); dq.push_back(0); dq.push_back(0);
        dq.push_back(0); dq.push_back(0); dq.push_back(5); dq.push_back(255); dq.push_back(255); dq.push_back(255); dq.push_back(255); dq.push_back(255);
        dq.push_back(7); dq.push_back(1); dq.push_back(1); dq.push_back(1); dq.push_back(1); dq.push_back(1); dq.push_back(1); dq.push_back(1);

        num_tests = dq.pop_front();

        // Reset
        rst_n = 0;
        start = 0;
        in_valid = 0;
        in_data = 0;
        in_last = 0;
        out_ready = 0;

        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(2) @(posedge clk);

        for (test_num = 0; test_num < num_tests; test_num = test_num + 1) begin
            // Read test case
            test_length = dq.pop_front();
            for (i = 0; i < test_length; i = i + 1) begin
                test_values[i] = dq.pop_front();
            end

            expected_sum = calc_sum(test_length);

            // Start accumulation
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            // Send inputs and capture the result concurrently (advance only
            // on an accepted handshake to stay robust to ready deassertion).
            out_ready = 1;
            fork
                begin : sender
                    i = 0;
                    in_valid <= 1'b1;
                    while (i < test_length) begin
                        in_data <= test_values[i];
                        in_last <= (i == test_length - 1);
                        @(posedge clk);
                        if (in_ready) i = i + 1;
                    end
                    in_valid <= 1'b0;
                    in_last  <= 1'b0;
                end
                begin : receiver
                    @(posedge clk);
                    while (!out_valid) @(posedge clk);
                    actual_sum = out_sum;
                end
            join

            if (actual_sum !== expected_sum) begin
                $display("Test %0d FAILED: Expected sum=%0d, Got sum=%0d",
                         test_num, expected_sum, actual_sum);
                errors = errors + 1;
            end else begin
                $display("Test %0d PASSED: sum=%0d", test_num, actual_sum);
            end

            out_ready = 0;
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
