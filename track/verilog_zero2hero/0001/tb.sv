`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic zero;
    logic one;
    int ERR_COUNT = 0;

    constants DUT (.zero(zero), .one(one));

    initial begin
        #5;
        if (zero !== 1'b0) begin ERR_COUNT++; $error("%0tns zero=%b expected 0", $time, zero); end
        if (one  !== 1'b1) begin ERR_COUNT++; $error("%0tns one=%b expected 1",  $time, one);  end
        if (ERR_COUNT == 0) $display("%0tns zero=%b one=%b", $time, zero, one);
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
