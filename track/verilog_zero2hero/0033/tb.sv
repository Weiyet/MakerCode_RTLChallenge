//=============================================================
// Provided sub-module — you MUST instantiate this in your block.
//   module mod_a (output out1, output out2,
//                 input a, input b, input c, input d);
//=============================================================
module mod_a (
    output out1,
    output out2,
    input  a,
    input  b,
    input  c,
    input  d
);
    assign out1 = (a & b) | (c & d);
    assign out2 = (a | b) & (c | d);
endmodule

`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic a, b, c, d, out1, out2, e1, e2;
    int ERR_COUNT = 0;

    inst_by_name DUT (.a(a), .b(b), .c(c), .d(d), .out1(out1), .out2(out2));

    initial begin
        for (int i = 0; i < 16; i++) begin
            {a, b, c, d} = i[3:0];
            #5;
            e1 = (a & b) | (c & d);
            e2 = (a | b) & (c | d);
            if (out1 !== e1) begin ERR_COUNT++; $error("%0tns out1=%b exp=%b", $time, out1, e1); end
            if (out2 !== e2) begin ERR_COUNT++; $error("%0tns out2=%b exp=%b", $time, out2, e2); end
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
    initial begin #(TB_SIM_TIMEOUT) $error("Simulation TIMEOUT"); $finish; end
endmodule
