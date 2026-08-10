`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic [3:0]  opcode;
    logic [2:0]  src, dst;
    logic [5:0]  imm;
    logic [15:0] word, exp;
    int ERR_COUNT = 0;

    ctrl_pack DUT (.opcode(opcode), .src(src), .dst(dst), .imm(imm), .word(word));

    initial begin
        for (int t = 0; t < 40; t++) begin
            opcode = $random; src = $random; dst = $random; imm = $random;
            #5;
            exp = {opcode, src, dst, imm};
            if (word !== exp) begin ERR_COUNT++; $error("%0tns word=%h exp=%h", $time, word, exp); end
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
