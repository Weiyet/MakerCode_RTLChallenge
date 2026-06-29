`timescale 1ns/1ps

module tb;

    reg         clk;
    reg         rst_n;
    reg [47:0]  cfg_mac;
    reg         cfg_promisc;
    reg         in_valid;
    reg [47:0]  in_dst_mac;
    reg         out_ready;
    wire        in_ready;
    wire        out_valid;
    wire        out_accept;
    wire [2:0]  out_reason;

    // Instantiate DUT
    mac_filter dut (
        .clk(clk),
        .rst_n(rst_n),
        .cfg_mac(cfg_mac),
        .cfg_promisc(cfg_promisc),
        .in_valid(in_valid),
        .in_dst_mac(in_dst_mac),
        .out_ready(out_ready),
        .in_ready(in_ready),
        .out_valid(out_valid),
        .out_accept(out_accept),
        .out_reason(out_reason)
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
    reg [47:0] test_dst_mac;
    reg test_promisc;
    reg expected_accept;
    reg [2:0] expected_reason;

    // Read test vector file
    initial begin
        errors = 0;
        cfg_mac = 48'h001A2B3C4D5E;  // Fixed local MAC

        // Embedded test vectors (was input_vector.txt)
        dq.push_back(8); dq.push_back('h001A2B3C4D5E); dq.push_back(0); dq.push_back(1); dq.push_back(1); dq.push_back('hFFFFFFFFFFFF); dq.push_back(0); dq.push_back(1);
        dq.push_back(2); dq.push_back('h01005E000001); dq.push_back(0); dq.push_back(1); dq.push_back(3); dq.push_back('h001122334455); dq.push_back(0); dq.push_back(0);
        dq.push_back(0); dq.push_back('hAABBCCDDEEFF); dq.push_back(1); dq.push_back(1); dq.push_back(4); dq.push_back('h001A2B3C4D5E); dq.push_back(1); dq.push_back(1);
        dq.push_back(4); dq.push_back('h03000000000A); dq.push_back(0); dq.push_back(1); dq.push_back(3); dq.push_back('h000000000001); dq.push_back(0); dq.push_back(0);
        dq.push_back(0);

        num_tests = dq.pop_front();

        // Reset
        rst_n = 0;
        cfg_promisc = 0;
        in_valid = 0;
        in_dst_mac = 0;
        out_ready = 0;

        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(2) @(posedge clk);

        for (test_num = 0; test_num < num_tests; test_num = test_num + 1) begin
            // Read test case: dst_mac, promisc, expected_accept, expected_reason
            test_dst_mac = dq.pop_front();
            test_promisc = dq.pop_front();
            expected_accept = dq.pop_front();
            expected_reason = dq.pop_front();

            cfg_promisc = test_promisc;

            // Send input and capture result with a concurrent handshake
            in_valid   <= 1'b1;
            in_dst_mac <= test_dst_mac;
            out_ready  <= 1'b1;
            i = 0;
            while (!i) begin
                @(posedge clk);
                if (in_ready) in_valid <= 1'b0;
                if (out_valid) begin
                    if (out_accept !== expected_accept || out_reason !== expected_reason) begin
                        $display("Test %0d FAILED: dst=%h, promisc=%d", test_num, test_dst_mac, test_promisc);
                        $display("  Expected: accept=%d, reason=%d", expected_accept, expected_reason);
                        $display("  Got:      accept=%d, reason=%d", out_accept, out_reason);
                        errors = errors + 1;
                    end else begin
                        $display("Test %0d PASSED: dst=%h, accept=%d, reason=%d",
                                 test_num, test_dst_mac, out_accept, out_reason);
                    end
                    i = 1;
                end
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
