`timescale 1ns/1ps

module tb;

    parameter DATA_WIDTH = 8;
    parameter MAX_SIZE = 16;

    reg                      clk;
    reg                      rst_n;
    reg                      start;
    reg                      in_valid;
    reg [DATA_WIDTH-1:0]     in_data;
    reg                      in_last;
    reg                      out_ready;
    wire                     in_ready;
    wire                     out_valid;
    wire [DATA_WIDTH-1:0]    out_mode;
    wire [7:0]               out_count;

    // Instantiate DUT
    mode_finder #(
        .DATA_WIDTH(DATA_WIDTH),
        .MAX_SIZE(MAX_SIZE)
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
        .out_mode(out_mode),
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
    integer i, j;

    // Test case storage
    reg [DATA_WIDTH-1:0] test_values [0:MAX_SIZE-1];
    integer test_length;
    reg [DATA_WIDTH-1:0] expected_mode;
    reg [7:0] expected_count;

    // Reference model - find mode
    task find_mode_ref;
        output [DATA_WIDTH-1:0] mode;
        output [7:0] count;
        integer counts [0:255];
        integer k, max_cnt, max_val;
    begin
        // Initialize counts
        for (k = 0; k < 256; k = k + 1)
            counts[k] = 0;

        // Count occurrences
        for (k = 0; k < test_length; k = k + 1)
            counts[test_values[k]] = counts[test_values[k]] + 1;

        // Find max count
        max_cnt = 0;
        max_val = 0;
        for (k = 0; k < 256; k = k + 1) begin
            if (counts[k] > max_cnt) begin
                max_cnt = counts[k];
                max_val = k;
            end
        end

        mode = max_val;
        count = max_cnt;
    end
    endtask

    // Read test vector file
    initial begin
        errors = 0;

        // Embedded test vectors (was input_vector.txt)
        dq.push_back(8); dq.push_back(8); dq.push_back(1); dq.push_back(3); dq.push_back(2); dq.push_back(3); dq.push_back(4); dq.push_back(3);
        dq.push_back(2); dq.push_back(3); dq.push_back(5); dq.push_back(1); dq.push_back(2); dq.push_back(3); dq.push_back(4); dq.push_back(5);
        dq.push_back(3); dq.push_back(7); dq.push_back(7); dq.push_back(7); dq.push_back(6); dq.push_back(1); dq.push_back(1); dq.push_back(2);
        dq.push_back(2); dq.push_back(3); dq.push_back(3); dq.push_back(1); dq.push_back(42); dq.push_back(4); dq.push_back(10); dq.push_back(20);
        dq.push_back(10); dq.push_back(20); dq.push_back(7); dq.push_back(5); dq.push_back(5); dq.push_back(5); dq.push_back(3); dq.push_back(3);
        dq.push_back(3); dq.push_back(5); dq.push_back(10); dq.push_back(1); dq.push_back(2); dq.push_back(2); dq.push_back(3); dq.push_back(3);
        dq.push_back(3); dq.push_back(4); dq.push_back(4); dq.push_back(4); dq.push_back(4);

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

            find_mode_ref(expected_mode, expected_count);

            // Start
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            // Send input values (advance only on accepted handshake)
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

            // Wait for output
            out_ready = 1;
            while (!out_valid) @(posedge clk);

            // Verify count matches (mode value may differ if tie)
            if (out_count !== expected_count) begin
                $display("Test %0d FAILED: Expected count=%0d, Got count=%0d",
                         test_num, expected_count, out_count);
                errors = errors + 1;
            end else begin
                $display("Test %0d PASSED: mode=%0d, count=%0d",
                         test_num, out_mode, out_count);
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
