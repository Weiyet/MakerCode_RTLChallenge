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
    wire [47:0] out_dst_mac;
    wire [47:0] out_src_mac;
    wire [15:0] out_ethertype;

    // Instantiate DUT
    eth_header_parser dut (
        .clk(clk),
        .rst_n(rst_n),
        .in_valid(in_valid),
        .in_data(in_data),
        .in_sof(in_sof),
        .out_ready(out_ready),
        .in_ready(in_ready),
        .out_valid(out_valid),
        .out_dst_mac(out_dst_mac),
        .out_src_mac(out_src_mac),
        .out_ethertype(out_ethertype)
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
    reg [7:0] header_bytes [0:13];
    reg [47:0] expected_dst;
    reg [47:0] expected_src;
    reg [15:0] expected_type;

    // Read test vector file
    initial begin
        errors = 0;

        // Embedded test vectors (was input_vector.txt)
        dq.push_back(5); dq.push_back('hFF); dq.push_back('hFF); dq.push_back('hFF); dq.push_back('hFF); dq.push_back('hFF); dq.push_back('hFF); dq.push_back('h00);
        dq.push_back('h1A); dq.push_back('h2B); dq.push_back('h3C); dq.push_back('h4D); dq.push_back('h5E); dq.push_back('h08); dq.push_back('h00); dq.push_back('h00);
        dq.push_back('h11); dq.push_back('h22); dq.push_back('h33); dq.push_back('h44); dq.push_back('h55); dq.push_back('h66); dq.push_back('h77); dq.push_back('h88);
        dq.push_back('h99); dq.push_back('hAA); dq.push_back('hBB); dq.push_back('h08); dq.push_back('h06); dq.push_back('h01); dq.push_back('h02); dq.push_back('h03);
        dq.push_back('h04); dq.push_back('h05); dq.push_back('h06); dq.push_back('h0A); dq.push_back('h0B); dq.push_back('h0C); dq.push_back('h0D); dq.push_back('h0E);
        dq.push_back('h0F); dq.push_back('h86); dq.push_back('hDD); dq.push_back('hAA); dq.push_back('hBB); dq.push_back('hCC); dq.push_back('hDD); dq.push_back('hEE);
        dq.push_back('hFF); dq.push_back('h11); dq.push_back('h22); dq.push_back('h33); dq.push_back('h44); dq.push_back('h55); dq.push_back('h66); dq.push_back('h81);
        dq.push_back('h00); dq.push_back('h00); dq.push_back('h00); dq.push_back('h00); dq.push_back('h00); dq.push_back('h00); dq.push_back('h01); dq.push_back('h00);
        dq.push_back('h00); dq.push_back('h00); dq.push_back('h00); dq.push_back('h00); dq.push_back('h02); dq.push_back('h08); dq.push_back('h00);

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
            // Read 14 header bytes
            for (i = 0; i < 14; i = i + 1) begin
                header_bytes[i] = dq.pop_front();
            end

            // Calculate expected values
            expected_dst = {header_bytes[0], header_bytes[1], header_bytes[2],
                           header_bytes[3], header_bytes[4], header_bytes[5]};
            expected_src = {header_bytes[6], header_bytes[7], header_bytes[8],
                           header_bytes[9], header_bytes[10], header_bytes[11]};
            expected_type = {header_bytes[12], header_bytes[13]};

            // Send header bytes (advance only on accepted handshake)
            i = 0;
            in_valid <= 1'b1;
            while (i < 14) begin
                in_data <= header_bytes[i];
                in_sof  <= (i == 0);
                @(posedge clk);
                if (in_ready) i = i + 1;
            end
            in_valid <= 1'b0;
            in_sof   <= 1'b0;

            // Wait for output
            out_ready <= 1'b1;
            @(posedge clk);
            while (!out_valid) @(posedge clk);

            // Verify
            if (out_dst_mac !== expected_dst ||
                out_src_mac !== expected_src ||
                out_ethertype !== expected_type) begin
                $display("Test %0d FAILED:", test_num);
                $display("  dst_mac: expected %h, got %h", expected_dst, out_dst_mac);
                $display("  src_mac: expected %h, got %h", expected_src, out_src_mac);
                $display("  ethertype: expected %h, got %h", expected_type, out_ethertype);
                errors = errors + 1;
            end else begin
                $display("Test %0d PASSED: dst=%h, src=%h, type=%h",
                         test_num, out_dst_mac, out_src_mac, out_ethertype);
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
