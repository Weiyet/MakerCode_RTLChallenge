`timescale 1ns/1ps

module tb;

    reg         clk;
    reg         rst_n;
    reg         start;
    reg         in_valid;
    reg [15:0]  in_data;
    reg         in_last;
    reg         out_ready;
    wire        in_ready;
    wire        out_valid;
    wire [15:0] out_checksum;
    wire        out_valid_hdr;

    // Instantiate DUT
    ipv4_checksum dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .in_valid(in_valid),
        .in_data(in_data),
        .in_last(in_last),
        .out_ready(out_ready),
        .in_ready(in_ready),
        .out_valid(out_valid),
        .out_checksum(out_checksum),
        .out_valid_hdr(out_valid_hdr)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Test variables
    integer test_num;
    integer errors;
    integer fd;
    reg [63:0] dq [$];
    integer status;
    integer num_tests;
    integer i;

    // Test case storage
    reg [15:0] header_words [0:19];
    integer num_words;
    reg [15:0] expected_checksum;

    // Reference model
    function [15:0] calc_checksum;
        input integer n;
        reg [31:0] sum;
        integer k;
    begin
        sum = 0;
        for (k = 0; k < n; k = k + 1)
            sum = sum + header_words[k];
        // Fold
        while (sum[31:16] != 0)
            sum = sum[15:0] + sum[31:16];
        calc_checksum = ~sum[15:0];
    end
    endfunction

    // Read test vector file
    initial begin
        errors = 0;

        // Embedded test vectors (was input_vector.txt)
        dq.push_back(4); dq.push_back(10); dq.push_back('h4500); dq.push_back('h0034); dq.push_back('h1234); dq.push_back('h4000); dq.push_back('h4006); dq.push_back('h0000);
        dq.push_back('hC0A8); dq.push_back('h0001); dq.push_back('hC0A8); dq.push_back('h0002); dq.push_back(10); dq.push_back('h4500); dq.push_back('h003C); dq.push_back('hABCD);
        dq.push_back('h0000); dq.push_back('h4001); dq.push_back('h0000); dq.push_back('h0A00); dq.push_back('h0001); dq.push_back('h0A00); dq.push_back('h0002); dq.push_back(5);
        dq.push_back('h4500); dq.push_back('h0028); dq.push_back('h0001); dq.push_back('h0000); dq.push_back('h4006); dq.push_back(10); dq.push_back('h4510); dq.push_back('h0040);
        dq.push_back('h1234); dq.push_back('h4000); dq.push_back('h4011); dq.push_back('h0000); dq.push_back('hAC10); dq.push_back('h0001); dq.push_back('hAC10); dq.push_back('h0002);

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
            // Read header words
            num_words = dq.pop_front();
            for (i = 0; i < num_words; i = i + 1) begin
                header_words[i] = dq.pop_front();
            end

            expected_checksum = calc_checksum(num_words);

            // Start
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            // Send header words (advance only on accepted handshake)
            i = 0;
            in_valid <= 1'b1;
            while (i < num_words) begin
                in_data <= header_words[i];
                in_last <= (i == num_words - 1);
                @(posedge clk);
                if (in_ready) i = i + 1;
            end
            in_valid <= 1'b0;
            in_last  <= 1'b0;

            // Wait for output
            out_ready = 1;
            while (!out_valid) @(posedge clk);

            if (out_checksum !== expected_checksum) begin
                $display("Test %0d FAILED: Expected checksum=%h, Got %h",
                         test_num, expected_checksum, out_checksum);
                errors = errors + 1;
            end else begin
                $display("Test %0d PASSED: checksum=%h", test_num, out_checksum);
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
