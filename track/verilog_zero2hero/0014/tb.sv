`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic [1:0] in;
    logic en;
    logic [3:0] out, exp;
    int ERR_COUNT = 0;

    decoder2to4 DUT (.in(in), .en(en), .out(out));

    initial begin
        for (int i = 0; i < 8; i++) begin
            {en, in} = i[2:0];
            #5;
            exp = en ? (4'b1 << in) : 4'b0;
            if (out !== exp) begin ERR_COUNT++; $error("%0tns en=%b in=%b out=%b exp=%b", $time, en, in, out, exp); end
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
