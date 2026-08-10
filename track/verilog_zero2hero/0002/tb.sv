`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic in;
    logic out;
    int ERR_COUNT = 0;

    not_gate DUT (.in(in), .out(out));

    initial begin
        for (int i = 0; i < 4; i++) begin
            in = i[0];
            #5;
            if (out !== ~in) begin
                ERR_COUNT++;
                $error("%0tns in=%b out=%b expected=%b", $time, in, out, ~in);
            end else $display("%0tns in=%b out=%b", $time, in, out);
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
