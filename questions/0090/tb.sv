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
    wire                     out_is_bitonic;
    wire [7:0]               out_peak_idx;

    // Instantiate DUT
    bitonic_detect #(
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
        .out_is_bitonic(out_is_bitonic),
        .out_peak_idx(out_peak_idx)
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
    reg [DATA_WIDTH-1:0] test_values [0:MAX_SIZE-1];
    integer test_length;
    reg expected_bitonic;

    // Reference model
    task check_bitonic;
        output is_bitonic;
        integer k;
        integer phase;  // 0=init, 1=inc, 2=dec
        reg bitonic;
    begin
        bitonic = 1;
        phase = 0;

        for (k = 1; k < test_length && bitonic; k = k + 1) begin
            if (test_values[k] > test_values[k-1]) begin
                // Increasing
                if (phase == 2) begin
                    // Was decreasing, now increasing - not bitonic
                    bitonic = 0;
                end else begin
                    phase = 1;
                end
            end else if (test_values[k] < test_values[k-1]) begin
                // Decreasing
                if (phase == 0 || phase == 1) begin
                    phase = 2;
                end
            end
            // Equal: stay in current phase
        end

        is_bitonic = bitonic;
    end
    endtask

    // Read test vector file
    initial begin
        errors = 0;

        // Embedded test vectors (was input_vector.txt)
        dq.push_back(10); dq.push_back(7); dq.push_back(1); dq.push_back(3); dq.push_back(5); dq.push_back(7); dq.push_back(6); dq.push_back(4);
        dq.push_back(2); dq.push_back(5); dq.push_back(1); dq.push_back(2); dq.push_back(3); dq.push_back(4); dq.push_back(5); dq.push_back(5);
        dq.push_back(5); dq.push_back(4); dq.push_back(3); dq.push_back(2); dq.push_back(1); dq.push_back(5); dq.push_back(1); dq.push_back(3);
        dq.push_back(2); dq.push_back(4); dq.push_back(1); dq.push_back(4); dq.push_back(5); dq.push_back(5); dq.push_back(5); dq.push_back(5);
        dq.push_back(1); dq.push_back(42); dq.push_back(6); dq.push_back(1); dq.push_back(2); dq.push_back(3); dq.push_back(3); dq.push_back(2);
        dq.push_back(1); dq.push_back(8); dq.push_back(1); dq.push_back(2); dq.push_back(3); dq.push_back(4); dq.push_back(3); dq.push_back(2);
        dq.push_back(3); dq.push_back(4); dq.push_back(3); dq.push_back(1); dq.push_back(2); dq.push_back(1); dq.push_back(6); dq.push_back(10);
        dq.push_back(20); dq.push_back(30); dq.push_back(20); dq.push_back(10); dq.push_back(5);

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

            check_bitonic(expected_bitonic);

            // Start
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            // Send input values
            for (i = 0; i < test_length; i = i + 1) begin
                in_valid = 1;
                in_data = test_values[i];
                in_last = (i == test_length - 1);

                @(posedge clk);
                while (!in_ready) @(posedge clk);
            end
            in_valid = 0;
            in_last = 0;

            // Wait for output
            out_ready = 1;
            @(posedge clk);
            while (!out_valid) @(posedge clk);

            if (out_is_bitonic !== expected_bitonic) begin
                $display("Test %0d FAILED: Expected bitonic=%0d, Got bitonic=%0d",
                         test_num, expected_bitonic, out_is_bitonic);
                errors = errors + 1;
            end else begin
                $display("Test %0d PASSED: is_bitonic=%0d, peak_idx=%0d",
                         test_num, out_is_bitonic, out_peak_idx);
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
