`timescale 1ns/1ps

module tb;

    reg         clk;
    reg         rst_n;
    reg         in_valid;
    reg [15:0]  in_ethertype;
    reg [15:0]  in_tci;
    reg         out_ready;
    wire        in_ready;
    wire        out_valid;
    wire        out_is_tagged;
    wire [2:0]  out_pcp;
    wire        out_dei;
    wire [11:0] out_vid;

    vlan_detector dut (
        .clk(clk), .rst_n(rst_n),
        .in_valid(in_valid), .in_ethertype(in_ethertype), .in_tci(in_tci),
        .out_ready(out_ready), .in_ready(in_ready), .out_valid(out_valid),
        .out_is_tagged(out_is_tagged), .out_pcp(out_pcp), .out_dei(out_dei), .out_vid(out_vid)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    integer test_num, errors, fd, status, num_tests;
    reg [63:0] dq [$];
    reg [15:0] test_ethertype, test_tci;
    reg expected_tagged;
    reg [2:0] expected_pcp;
    reg expected_dei;
    reg [11:0] expected_vid;

    initial begin
        errors = 0;
        // Embedded test vectors (was input_vector.txt)
        dq.push_back(6); dq.push_back('h8100); dq.push_back('hA064); dq.push_back(1); dq.push_back(5); dq.push_back(0); dq.push_back(100); dq.push_back('h8100);
        dq.push_back('h2001); dq.push_back(1); dq.push_back(1); dq.push_back(0); dq.push_back(1); dq.push_back('h8100); dq.push_back('hF0C8); dq.push_back(1);
        dq.push_back(7); dq.push_back(1); dq.push_back(200); dq.push_back('h0800); dq.push_back('h0000); dq.push_back(0); dq.push_back(0); dq.push_back(0);
        dq.push_back(0); dq.push_back('h0806); dq.push_back('h1234); dq.push_back(0); dq.push_back(0); dq.push_back(0); dq.push_back(0); dq.push_back('h8100);
        dq.push_back('h0064); dq.push_back(1); dq.push_back(0); dq.push_back(0); dq.push_back(100);

        num_tests = dq.pop_front();
        rst_n = 0; in_valid = 0; in_ethertype = 0; in_tci = 0; out_ready = 0;

        repeat(5) @(posedge clk); rst_n = 1; repeat(2) @(posedge clk);

        for (test_num = 0; test_num < num_tests; test_num = test_num + 1) begin
            test_ethertype = dq.pop_front();
            test_tci = dq.pop_front();
            expected_tagged = dq.pop_front();
            expected_pcp = dq.pop_front();
            expected_dei = dq.pop_front();
            expected_vid = dq.pop_front();

            @(posedge clk);
            in_valid = 1; in_ethertype = test_ethertype; in_tci = test_tci;
            @(posedge clk);
            while (!in_ready) @(posedge clk);
            in_valid = 0;

            out_ready = 1;
            @(posedge clk);
            while (!out_valid) @(posedge clk);

            if (out_is_tagged !== expected_tagged || out_pcp !== expected_pcp ||
                out_dei !== expected_dei || out_vid !== expected_vid) begin
                $display("Test %0d FAILED", test_num);
                errors = errors + 1;
            end else begin
                $display("Test %0d PASSED: tagged=%d pcp=%d dei=%d vid=%d",
                         test_num, out_is_tagged, out_pcp, out_dei, out_vid);
            end
            out_ready = 0;
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
