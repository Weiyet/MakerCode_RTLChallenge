`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic [31:0] in, out, exp;
    int ERR_COUNT = 0;

    byte_reverse DUT (.in(in), .out(out));

    initial begin
        for (int t = 0; t < 20; t++) begin
            in = {$random};
            #5;
            exp = {in[7:0], in[15:8], in[23:16], in[31:24]};
            if (out !== exp) begin ERR_COUNT++; $error("%0tns in=%h out=%h expected=%h", $time, in, out, exp); end
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
