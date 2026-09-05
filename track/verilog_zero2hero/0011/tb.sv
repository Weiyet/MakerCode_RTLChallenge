`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic [3:0] in;
    logic [1:0] pos, exp_pos;
    logic valid, exp_valid;
    int ERR_COUNT = 0;

    priority_encoder DUT (.in(in), .pos(pos), .valid(valid));

    initial begin
        for (int i = 0; i < 16; i++) begin
            in = i[3:0];
            #5;
            exp_valid = |in;
            exp_pos = 2'd0;
            for (int k = 0; k < 4; k++) if (in[k]) exp_pos = k[1:0];
            if (valid !== exp_valid) begin ERR_COUNT++; $error("%0tns in=%b valid=%b exp=%b", $time, in, valid, exp_valid); end
            if (exp_valid && pos !== exp_pos) begin ERR_COUNT++; $error("%0tns in=%b pos=%0d exp=%0d", $time, in, pos, exp_pos); end
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
