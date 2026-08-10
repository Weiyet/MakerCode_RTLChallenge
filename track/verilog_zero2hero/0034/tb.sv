//=============================================================
// Provided sub-module (in tb.sv) - you MUST instantiate it TWICE
// with different parameter overrides.
//   module wide_reg #(parameter int WIDTH = 8)
//       (input clk, input [WIDTH-1:0] d, output [WIDTH-1:0] q);
//=============================================================
module wide_reg #(parameter int WIDTH = 8) (
    input  logic             clk,
    input  logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);
    always_ff @(posedge clk) q <= d;
endmodule

`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic clk = 0;
    logic [3:0]  d4, e4;
    logic [11:0] d12, e12;
    logic [3:0]  q4;
    logic [11:0] q12;
    int ERR_COUNT = 0;
    param_inst DUT (.clk(clk), .d4(d4), .q4(q4), .d12(d12), .q12(q12));
    always #5 clk = ~clk;
    always_ff @(posedge clk) begin e4 <= d4; e12 <= d12; end
    always @(posedge clk) begin
        #1;
        if (q4  !== e4)  begin ERR_COUNT++; $error("q4=%h exp=%h",  q4,  e4);  end
        if (q12 !== e12) begin ERR_COUNT++; $error("q12=%h exp=%h", q12, e12); end
    end
    initial begin
        d4 = 0; d12 = 0; @(negedge clk);
        for (int i = 0; i < 40; i++) begin d4 = $random; d12 = $random; @(negedge clk); end
        repeat (2) @(posedge clk);
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
