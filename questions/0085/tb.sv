`timescale 1ns/1ps

module tb;

    parameter DATA_WIDTH = 8;
    parameter MAX_SIZE = 8;
    parameter RESULT_WIDTH = DATA_WIDTH * 2 + 8;

    reg                      clk;
    reg                      rst_n;
    reg                      start;
    reg                      vec_a_valid;
    reg [DATA_WIDTH-1:0]     vec_a_data;
    reg                      vec_a_last;
    reg                      vec_b_valid;
    reg [DATA_WIDTH-1:0]     vec_b_data;
    reg                      vec_b_last;
    reg                      out_ready;
    wire                     vec_a_ready;
    wire                     vec_b_ready;
    wire                     out_valid;
    wire [RESULT_WIDTH-1:0]  out_result;

    // Instantiate DUT
    dot_product #(
        .DATA_WIDTH(DATA_WIDTH),
        .MAX_SIZE(MAX_SIZE)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .vec_a_valid(vec_a_valid),
        .vec_a_data(vec_a_data),
        .vec_a_last(vec_a_last),
        .vec_b_valid(vec_b_valid),
        .vec_b_data(vec_b_data),
        .vec_b_last(vec_b_last),
        .out_ready(out_ready),
        .vec_a_ready(vec_a_ready),
        .vec_b_ready(vec_b_ready),
        .out_valid(out_valid),
        .out_result(out_result)
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
    reg [DATA_WIDTH-1:0] vec_a_vals [0:MAX_SIZE-1];
    reg [DATA_WIDTH-1:0] vec_b_vals [0:MAX_SIZE-1];
    integer vec_len;
    reg [RESULT_WIDTH-1:0] expected_result;

    // Reference model
    function [RESULT_WIDTH-1:0] calc_dot_product;
        input integer len;
        integer k;
        reg [RESULT_WIDTH-1:0] sum;
    begin
        sum = 0;
        for (k = 0; k < len; k = k + 1) begin
            sum = sum + (vec_a_vals[k] * vec_b_vals[k]);
        end
        calc_dot_product = sum;
    end
    endfunction

    // Read test vector file
    initial begin
        errors = 0;

        // Embedded test vectors (was input_vector.txt)
        dq.push_back(8); dq.push_back(4); dq.push_back(1); dq.push_back(2); dq.push_back(3); dq.push_back(4); dq.push_back(5); dq.push_back(6);
        dq.push_back(7); dq.push_back(8); dq.push_back(3); dq.push_back(1); dq.push_back(1); dq.push_back(1); dq.push_back(2); dq.push_back(2);
        dq.push_back(2); dq.push_back(2); dq.push_back(10); dq.push_back(20); dq.push_back(3); dq.push_back(4); dq.push_back(5); dq.push_back(1);
        dq.push_back(2); dq.push_back(3); dq.push_back(4); dq.push_back(5); dq.push_back(5); dq.push_back(4); dq.push_back(3); dq.push_back(2);
        dq.push_back(1); dq.push_back(1); dq.push_back(7); dq.push_back(8); dq.push_back(6); dq.push_back(1); dq.push_back(0); dq.push_back(1);
        dq.push_back(0); dq.push_back(1); dq.push_back(0); dq.push_back(1); dq.push_back(1); dq.push_back(1); dq.push_back(1); dq.push_back(1);
        dq.push_back(1); dq.push_back(4); dq.push_back(2); dq.push_back(2); dq.push_back(2); dq.push_back(2); dq.push_back(3); dq.push_back(3);
        dq.push_back(3); dq.push_back(3); dq.push_back(3); dq.push_back(10); dq.push_back(10); dq.push_back(10); dq.push_back(10); dq.push_back(10);
        dq.push_back(10);

        num_tests = dq.pop_front();

        // Reset
        rst_n = 0;
        start = 0;
        vec_a_valid = 0;
        vec_a_data = 0;
        vec_a_last = 0;
        vec_b_valid = 0;
        vec_b_data = 0;
        vec_b_last = 0;
        out_ready = 0;

        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(2) @(posedge clk);

        for (test_num = 0; test_num < num_tests; test_num = test_num + 1) begin
            // Read test case
            vec_len = dq.pop_front();
            for (i = 0; i < vec_len; i = i + 1)
                vec_a_vals[i] = dq.pop_front();
            for (i = 0; i < vec_len; i = i + 1)
                vec_b_vals[i] = dq.pop_front();

            expected_result = calc_dot_product(vec_len);

            // Start
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            // Send vector A (advance only on accepted handshake)
            i = 0;
            vec_a_valid <= 1'b1;
            while (i < vec_len) begin
                vec_a_data <= vec_a_vals[i];
                vec_a_last <= (i == vec_len - 1);
                @(posedge clk);
                if (vec_a_ready) i = i + 1;
            end
            vec_a_valid <= 1'b0;
            vec_a_last  <= 1'b0;

            // Send vector B
            i = 0;
            vec_b_valid <= 1'b1;
            while (i < vec_len) begin
                vec_b_data <= vec_b_vals[i];
                vec_b_last <= (i == vec_len - 1);
                @(posedge clk);
                if (vec_b_ready) i = i + 1;
            end
            vec_b_valid <= 1'b0;
            vec_b_last  <= 1'b0;

            // Wait for output
            out_ready <= 1'b1;
            while (!out_valid) @(posedge clk);

            if (out_result !== expected_result) begin
                $display("Test %0d FAILED: Expected %0d, Got %0d",
                         test_num, expected_result, out_result);
                errors = errors + 1;
            end else begin
                $display("Test %0d PASSED: dot_product = %0d", test_num, out_result);
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
