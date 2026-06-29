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
    wire [DATA_WIDTH-1:0]    out_elem;
    wire                     out_found;

    // Instantiate DUT
    majority_elem #(
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
        .out_elem(out_elem),
        .out_found(out_found)
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
    reg [DATA_WIDTH-1:0] expected_elem;
    reg expected_found;

    // Reference model - find majority element
    task find_majority;
        output [DATA_WIDTH-1:0] elem;
        output found;
        integer counts [0:255];
        integer k, max_count, max_val;
    begin
        // Initialize counts
        for (k = 0; k < 256; k = k + 1)
            counts[k] = 0;

        // Count occurrences
        for (k = 0; k < test_length; k = k + 1)
            counts[test_values[k]] = counts[test_values[k]] + 1;

        // Find max count
        max_count = 0;
        max_val = 0;
        for (k = 0; k < 256; k = k + 1) begin
            if (counts[k] > max_count) begin
                max_count = counts[k];
                max_val = k;
            end
        end

        // Check if majority (> n/2)
        if (max_count > test_length / 2) begin
            elem = max_val;
            found = 1;
        end else begin
            elem = 0;
            found = 0;
        end
    end
    endtask

    // Read test vector file
    initial begin
        errors = 0;

        // Embedded test vectors (was input_vector.txt)
        dq.push_back(8); dq.push_back(7); dq.push_back(2); dq.push_back(2); dq.push_back(1); dq.push_back(1); dq.push_back(2); dq.push_back(2);
        dq.push_back(2); dq.push_back(5); dq.push_back(1); dq.push_back(2); dq.push_back(3); dq.push_back(4); dq.push_back(5); dq.push_back(3);
        dq.push_back(7); dq.push_back(7); dq.push_back(7); dq.push_back(6); dq.push_back(1); dq.push_back(1); dq.push_back(2); dq.push_back(2);
        dq.push_back(3); dq.push_back(3); dq.push_back(9); dq.push_back(3); dq.push_back(3); dq.push_back(3); dq.push_back(3); dq.push_back(3);
        dq.push_back(1); dq.push_back(2); dq.push_back(4); dq.push_back(5); dq.push_back(4); dq.push_back(5); dq.push_back(5); dq.push_back(5);
        dq.push_back(1); dq.push_back(5); dq.push_back(1); dq.push_back(1); dq.push_back(1); dq.push_back(2); dq.push_back(2); dq.push_back(8);
        dq.push_back(4); dq.push_back(4); dq.push_back(4); dq.push_back(4); dq.push_back(4); dq.push_back(1); dq.push_back(2); dq.push_back(3);

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

            find_majority(expected_elem, expected_found);

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

            if (out_found !== expected_found) begin
                $display("Test %0d FAILED: Expected found=%0d, Got found=%0d",
                         test_num, expected_found, out_found);
                errors = errors + 1;
            end else if (expected_found && out_elem !== expected_elem) begin
                $display("Test %0d FAILED: Expected elem=%0d, Got elem=%0d",
                         test_num, expected_elem, out_elem);
                errors = errors + 1;
            end else begin
                $display("Test %0d PASSED: elem=%0d, found=%0d",
                         test_num, out_elem, out_found);
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
