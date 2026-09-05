`timescale 1ns/1ps
module tb #(parameter int W = 8);
    localparam TB_SIM_TIMEOUT = 100000;
    logic clk, rst_n, en;
    logic [W-1:0] d, q, exp;
    int ERR_COUNT = 0;

    enable_register #(.W(W)) DUT (.clk(clk), .rst_n(rst_n), .en(en), .d(d), .q(q));

    initial begin clk = 0; forever #5 clk = ~clk; end

    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) exp <= '0; else if (en) exp <= d;

    always @(posedge clk) begin
        #1;
        if (q !== exp) begin ERR_COUNT++; $error("%0tns q=%h exp=%h", $time, q, exp); end
    end

    initial begin
        rst_n = 0; en = 0; d = 0;
        repeat(3) @(negedge clk);
        rst_n = 1;
        for (int i = 0; i < 50; i++) begin d = $random; en = $random; @(negedge clk); end
        repeat(2) @(posedge clk);
        check_result;
    end

    task check_result;
    begin
        if (ERR_COUNT > 0) $display("Test failed with %0d errors.", ERR_COUNT);
        else               $display("Test PASS");
        $finish;
    end
    endtask

    string filename;
    initial begin
        if ($value$plusargs("VCDFILE=%s", filename)) begin
            $dumpfile(filename); $dumpvars(0, DUT);
        end
    end
    initial begin #(TB_SIM_TIMEOUT) $error("Simulation TIMEOUT"); $finish; end
endmodule
