`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic [7:0] in, out;
    logic [7:0] exp;
    int ERR_COUNT = 0;

    vector_reverse DUT (.in(in), .out(out));

    initial begin
        for (int t = 0; t < 30; t++) begin
            in = $random;
            #5;
            for (int i = 0; i < 8; i++) exp[i] = in[7-i];
            if (out !== exp) begin ERR_COUNT++; $error("%0tns in=%b out=%b expected=%b", $time, in, out, exp); end
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
