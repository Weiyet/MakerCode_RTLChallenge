//=============================================================
// Provided sub-module — you MUST instantiate this in your block.
//   module add16 (input [15:0] a, input [15:0] b, input cin,
//                 output [15:0] sum, output cout);
//=============================================================
module add16 (
    input  logic [15:0] a,
    input  logic [15:0] b,
    input  logic        cin,
    output logic [15:0] sum,
    output logic        cout
);
    assign {cout, sum} = a + b + cin;
endmodule

`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic [31:0] a, b, sum, exp;
    int ERR_COUNT = 0;

    adder32 DUT (.a(a), .b(b), .sum(sum));

    initial begin
        for (int t = 0; t < 200; t++) begin
            a = {$random}; b = {$random};
            #5;
            exp = a + b;
            if (sum !== exp) begin ERR_COUNT++; $error("%0tns a=%h b=%h sum=%h exp=%h", $time, a, b, sum, exp); end
            #5;
        end
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
