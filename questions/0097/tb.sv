`timescale 1ns/1ps

module tb;

    parameter DATA_WIDTH = 16;

    reg                       clk;
    reg                       rst_n;
    reg                       in_valid;
    reg signed [DATA_WIDTH-1:0] in_data;
    reg                       out_ready;
    wire                      in_ready;
    wire                      out_valid;
    wire signed [DATA_WIDTH-1:0] out_data;

    relu_unit #(.DATA_WIDTH(DATA_WIDTH)) dut (
        .clk(clk), .rst_n(rst_n),
        .in_valid(in_valid), .in_data(in_data),
        .out_ready(out_ready), .in_ready(in_ready),
        .out_valid(out_valid), .out_data(out_data)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    integer test_num, errors, fd, status, num_tests;
    integer dq [$];
    integer i;
    reg signed [DATA_WIDTH-1:0] test_input;
    reg signed [DATA_WIDTH-1:0] expected_output;

    function signed [DATA_WIDTH-1:0] relu;
        input signed [DATA_WIDTH-1:0] x;
    begin
        relu = (x < 0) ? 0 : x;
    end
    endfunction

    initial begin
        errors = 0;
        // Embedded test vectors (was input_vector.txt)
        dq.push_back(10);
        dq.push_back(0); dq.push_back(10); dq.push_back(-5); dq.push_back(100); dq.push_back(-100);
        dq.push_back(32767); dq.push_back(-32768); dq.push_back(1); dq.push_back(-1); dq.push_back(255);

        num_tests = dq.pop_front();
        rst_n = 0; in_valid = 0; in_data = 0; out_ready = 0;

        repeat(5) @(posedge clk); rst_n = 1; repeat(2) @(posedge clk);

        for (test_num = 0; test_num < num_tests; test_num = test_num + 1) begin
            test_input = dq.pop_front();
            expected_output = relu(test_input);

            // Send input and capture result with a concurrent handshake
            in_valid  <= 1'b1;
            in_data   <= test_input;
            out_ready <= 1'b1;
            i = 0;
            while (!i) begin
                @(posedge clk);
                if (in_ready) in_valid <= 1'b0;
                if (out_valid) begin
                    if (out_data !== expected_output) begin
                        $display("Test %0d FAILED: relu(%0d) expected %0d, got %0d",
                                 test_num, test_input, expected_output, out_data);
                        errors = errors + 1;
                    end else begin
                        $display("Test %0d PASSED: relu(%0d) = %0d", test_num, test_input, out_data);
                    end
                    i = 1;
                end
            end
            out_ready <= 1'b0;
            repeat(2) @(posedge clk);
        end

        $display("\n====================");
        if (errors == 0) $display("ALL TESTS PASSED!");
        else $error("FAILED: %0d errors", errors);
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
