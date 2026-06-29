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
    wire [7:0]               out_length;

    // Instantiate DUT
    longest_consec #(
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
        .out_length(out_length)
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
    integer i, j, k;

    // Test case storage
    reg [DATA_WIDTH-1:0] test_values [0:MAX_SIZE-1];
    reg [DATA_WIDTH-1:0] sorted_values [0:MAX_SIZE-1];
    integer test_length;
    integer expected_length;

    // Reference model
    task calc_longest_consec;
        output integer len;
        integer curr, maxl, idx;
        reg [DATA_WIDTH-1:0] temp;
    begin
        // Copy and sort
        for (idx = 0; idx < test_length; idx = idx + 1)
            sorted_values[idx] = test_values[idx];

        // Bubble sort
        for (i = 0; i < test_length - 1; i = i + 1) begin
            for (j = 0; j < test_length - 1 - i; j = j + 1) begin
                if (sorted_values[j] > sorted_values[j + 1]) begin
                    temp = sorted_values[j];
                    sorted_values[j] = sorted_values[j + 1];
                    sorted_values[j + 1] = temp;
                end
            end
        end

        // Find longest consecutive
        if (test_length == 0) begin
            len = 0;
        end else begin
            curr = 1;
            maxl = 1;
            for (idx = 1; idx < test_length; idx = idx + 1) begin
                if (sorted_values[idx] == sorted_values[idx - 1]) begin
                    // Duplicate, skip
                end else if (sorted_values[idx] == sorted_values[idx - 1] + 1) begin
                    curr = curr + 1;
                    if (curr > maxl) maxl = curr;
                end else begin
                    curr = 1;
                end
            end
            len = maxl;
        end
    end
    endtask

    // Read test vector file
    initial begin
        errors = 0;

        // Embedded test vectors (was input_vector.txt)
        dq.push_back(8); dq.push_back(6); dq.push_back(100); dq.push_back(4); dq.push_back(200); dq.push_back(1); dq.push_back(3); dq.push_back(2);
        dq.push_back(5); dq.push_back(1); dq.push_back(2); dq.push_back(3); dq.push_back(4); dq.push_back(5); dq.push_back(4); dq.push_back(10);
        dq.push_back(20); dq.push_back(30); dq.push_back(40); dq.push_back(3); dq.push_back(5); dq.push_back(5); dq.push_back(5); dq.push_back(7);
        dq.push_back(9); dq.push_back(1); dq.push_back(4); dq.push_back(7); dq.push_back(3); dq.push_back(2); dq.push_back(6); dq.push_back(8);
        dq.push_back(1); dq.push_back(2); dq.push_back(2); dq.push_back(3); dq.push_back(3); dq.push_back(4); dq.push_back(5); dq.push_back(6);
        dq.push_back(5); dq.push_back(50); dq.push_back(51); dq.push_back(53); dq.push_back(54); dq.push_back(55); dq.push_back(6); dq.push_back(1);
        dq.push_back(3); dq.push_back(5); dq.push_back(7); dq.push_back(9); dq.push_back(11);

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

            calc_longest_consec(expected_length);

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

            if (out_length !== expected_length) begin
                $display("Test %0d FAILED: Expected length=%0d, Got length=%0d",
                         test_num, expected_length, out_length);
                errors = errors + 1;
            end else begin
                $display("Test %0d PASSED: length=%0d", test_num, out_length);
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
