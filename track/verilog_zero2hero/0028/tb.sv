`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic clk, rst_n, din, y;
    logic prev_e, y_e;
    int ERR_COUNT = 0;

    mealy_11 DUT (.clk(clk), .rst_n(rst_n), .din(din), .y(y));

    initial begin clk = 0; forever #5 clk = ~clk; end

    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) prev_e <= 1'b0; else prev_e <= din;
    assign y_e = prev_e & din;

    always @(posedge clk) begin
        #1;
        if (y !== y_e) begin ERR_COUNT++; $error("%0tns din=%b y=%b exp=%b", $time, din, y, y_e); end
    end

    initial begin
        rst_n = 0; din = 0;
        repeat(3) @(negedge clk);
        rst_n = 1;
        for (int i = 0; i < 80; i++) begin din = $random; @(negedge clk); end
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
