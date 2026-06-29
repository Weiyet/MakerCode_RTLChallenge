`timescale 1ns/1ps

module tb;

    parameter DATA_WIDTH = 8;
    parameter MAX_SIZE = 8;

    reg                      clk;
    reg                      rst_n;
    reg                      start;
    reg                      in_valid;
    reg [DATA_WIDTH-1:0]     in_data;
    reg                      in_last;
    reg                      out_ready;
    wire                     in_ready;
    wire                     out_valid;
    wire [DATA_WIDTH-1:0]    out_data;
    wire                     out_last;

    // Instantiate DUT
    insertion_sort #(
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
        .out_data(out_data),
        .out_last(out_last)
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
    reg [DATA_WIDTH-1:0] sorted_values [0:MAX_SIZE-1];
    reg [DATA_WIDTH-1:0] output_values [0:MAX_SIZE-1];
    integer test_length;
    integer out_count;

    // Reference model - insertion sort
    task sort_reference;
        integer ii, jj;
        reg [DATA_WIDTH-1:0] temp, key;
    begin
        // Copy values
        for (ii = 0; ii < test_length; ii = ii + 1)
            sorted_values[ii] = test_values[ii];

        // Insertion sort
        for (ii = 1; ii < test_length; ii = ii + 1) begin
            key = sorted_values[ii];
            jj = ii - 1;
            while (jj >= 0 && sorted_values[jj] > key) begin
                sorted_values[jj + 1] = sorted_values[jj];
                jj = jj - 1;
            end
            sorted_values[jj + 1] = key;
        end
    end
    endtask

    // Read test vector file
    initial begin
        errors = 0;

        // Embedded test vectors (was input_vector.txt)
        dq.push_back(8); dq.push_back(5); dq.push_back(5); dq.push_back(2); dq.push_back(8); dq.push_back(1); dq.push_back(9); dq.push_back(3);
        dq.push_back(3); dq.push_back(1); dq.push_back(2); dq.push_back(4); dq.push_back(4); dq.push_back(3); dq.push_back(2); dq.push_back(1);
        dq.push_back(6); dq.push_back(1); dq.push_back(2); dq.push_back(3); dq.push_back(4); dq.push_back(5); dq.push_back(6); dq.push_back(5);
        dq.push_back(9); dq.push_back(7); dq.push_back(5); dq.push_back(3); dq.push_back(1); dq.push_back(4); dq.push_back(10); dq.push_back(10);
        dq.push_back(10); dq.push_back(10); dq.push_back(7); dq.push_back(64); dq.push_back(32); dq.push_back(16); dq.push_back(8); dq.push_back(4);
        dq.push_back(2); dq.push_back(1); dq.push_back(5); dq.push_back(50); dq.push_back(40); dq.push_back(30); dq.push_back(20); dq.push_back(10);

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

            sort_reference();

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

            // Receive output
            out_ready = 1;
            out_count = 0;
            while (out_count < test_length) begin
                @(posedge clk);
                if (out_valid && out_ready) begin
                    output_values[out_count] = out_data;
                    out_count = out_count + 1;
                end
            end
            out_ready = 0;

            // Verify
            for (i = 0; i < test_length; i = i + 1) begin
                if (output_values[i] !== sorted_values[i]) begin
                    $display("Test %0d FAILED at index %0d: Expected %0d, Got %0d",
                             test_num, i, sorted_values[i], output_values[i]);
                    errors = errors + 1;
                end
            end

            if (errors == 0 || test_num == num_tests - 1)
                $display("Test %0d completed", test_num);

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
