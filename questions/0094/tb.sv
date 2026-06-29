`timescale 1ns/1ps

module tb;

    reg         clk;
    reg         rst_n;
    reg         in_valid;
    reg [7:0]   in_data;
    reg         in_sof;
    reg         out_ready;
    wire        in_ready;
    wire        out_valid;
    wire        out_is_request;
    wire [31:0] out_sender_ip;
    wire [31:0] out_target_ip;

    // Instantiate DUT
    arp_detector dut (
        .clk(clk),
        .rst_n(rst_n),
        .in_valid(in_valid),
        .in_data(in_data),
        .in_sof(in_sof),
        .out_ready(out_ready),
        .in_ready(in_ready),
        .out_valid(out_valid),
        .out_is_request(out_is_request),
        .out_sender_ip(out_sender_ip),
        .out_target_ip(out_target_ip)
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
    reg [7:0] arp_bytes [0:27];
    reg expected_is_request;
    reg [31:0] expected_sender_ip;
    reg [31:0] expected_target_ip;

    // Read test vector file
    initial begin
        errors = 0;

        // Embedded test vectors (was input_vector.txt)
        dq.push_back(3); dq.push_back('h00); dq.push_back('h01); dq.push_back('h08); dq.push_back('h00); dq.push_back('h06); dq.push_back('h04); dq.push_back('h00);
        dq.push_back('h01); dq.push_back('hAA); dq.push_back('hBB); dq.push_back('hCC); dq.push_back('hDD); dq.push_back('hEE); dq.push_back('hFF); dq.push_back('hC0);
        dq.push_back('hA8); dq.push_back('h01); dq.push_back('h64); dq.push_back('h00); dq.push_back('h00); dq.push_back('h00); dq.push_back('h00); dq.push_back('h00);
        dq.push_back('h00); dq.push_back('hC0); dq.push_back('hA8); dq.push_back('h01); dq.push_back('h01); dq.push_back(1); dq.push_back('hC0A80164); dq.push_back('hC0A80101);
        dq.push_back('h00); dq.push_back('h01); dq.push_back('h08); dq.push_back('h00); dq.push_back('h06); dq.push_back('h04); dq.push_back('h00); dq.push_back('h02);
        dq.push_back('h11); dq.push_back('h22); dq.push_back('h33); dq.push_back('h44); dq.push_back('h55); dq.push_back('h66); dq.push_back('h0A); dq.push_back('h00);
        dq.push_back('h00); dq.push_back('h01); dq.push_back('hAA); dq.push_back('hBB); dq.push_back('hCC); dq.push_back('hDD); dq.push_back('hEE); dq.push_back('hFF);
        dq.push_back('h0A); dq.push_back('h00); dq.push_back('h00); dq.push_back('h02); dq.push_back(0); dq.push_back('h0A000001); dq.push_back('h0A000002); dq.push_back('h00);
        dq.push_back('h01); dq.push_back('h08); dq.push_back('h00); dq.push_back('h06); dq.push_back('h04); dq.push_back('h00); dq.push_back('h01); dq.push_back('hDE);
        dq.push_back('hAD); dq.push_back('hBE); dq.push_back('hEF); dq.push_back('h12); dq.push_back('h34); dq.push_back('hAC); dq.push_back('h10); dq.push_back('h01);
        dq.push_back('h0A); dq.push_back('h00); dq.push_back('h00); dq.push_back('h00); dq.push_back('h00); dq.push_back('h00); dq.push_back('h00); dq.push_back('hAC);
        dq.push_back('h10); dq.push_back('h01); dq.push_back('h14); dq.push_back(1); dq.push_back('hAC10010A); dq.push_back('hAC100114);

        num_tests = dq.pop_front();

        // Reset
        rst_n = 0;
        in_valid = 0;
        in_data = 0;
        in_sof = 0;
        out_ready = 0;

        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(2) @(posedge clk);

        for (test_num = 0; test_num < num_tests; test_num = test_num + 1) begin
            // Read 28 ARP bytes
            for (i = 0; i < 28; i = i + 1) begin
                arp_bytes[i] = dq.pop_front();
            end
            expected_is_request = dq.pop_front();
            expected_sender_ip = dq.pop_front();
            expected_target_ip = dq.pop_front();

            // Send ARP bytes (advance only on accepted handshake)
            i = 0;
            in_valid <= 1'b1;
            while (i < 28) begin
                in_data <= arp_bytes[i];
                in_sof  <= (i == 0);
                @(posedge clk);
                if (in_ready) i = i + 1;
            end
            in_valid <= 1'b0;
            in_sof   <= 1'b0;

            // Wait for output
            out_ready = 1;
            @(posedge clk);
            while (!out_valid) @(posedge clk);

            // Verify
            if (out_is_request !== expected_is_request ||
                out_sender_ip !== expected_sender_ip ||
                out_target_ip !== expected_target_ip) begin
                $display("Test %0d FAILED", test_num);
                errors = errors + 1;
            end else begin
                $display("Test %0d PASSED: is_req=%d, sender=%h, target=%h",
                         test_num, out_is_request, out_sender_ip, out_target_ip);
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
