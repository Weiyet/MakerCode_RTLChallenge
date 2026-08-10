//=============================================================
// Provided sub-module — you MUST instantiate this in your block.
//   module my_dff8 (input clk, input [7:0] d, output [7:0] q);
//=============================================================
module my_dff8 (
    input  logic       clk,
    input  logic [7:0] d,
    output logic [7:0] q
);
    always_ff @(posedge clk) q <= d;
endmodule

`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic clk;
    logic [7:0] d, q;
    logic [1:0] sel;
    logic [7:0] s1, s2, s3, exp;
    int ERR_COUNT = 0;

    shift8_mux DUT (.clk(clk), .d(d), .sel(sel), .q(q));

    initial begin clk = 0; forever #5 clk = ~clk; end

    // golden delay line
    always_ff @(posedge clk) begin s1 <= d; s2 <= s1; s3 <= s2; end

    always @(posedge clk) begin
        #1;
        case (sel) 2'd0: exp = d; 2'd1: exp = s1; 2'd2: exp = s2; default: exp = s3; endcase
        if (q !== exp) begin ERR_COUNT++; $error("%0tns sel=%0d q=%h exp=%h", $time, sel, q, exp); end
    end

    initial begin
        d = 0; sel = 0;
        @(negedge clk);
        for (int i = 0; i < 60; i++) begin d = $random; sel = $random; @(negedge clk); end
        repeat(3) @(posedge clk);
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
    initial begin #(TB_SIM_TIMEOUT) $display("Simulation TIMEOUT"); $finish; end
endmodule
