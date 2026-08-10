`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic oe;
    logic [7:0] din, dout;
    int ERR_COUNT = 0;
    tristate_buf DUT (.oe(oe), .din(din), .dout(dout));
    initial begin
        for (int t = 0; t < 20; t++) begin
            din = $random; oe = 1; #5;
            if (dout !== din)   begin ERR_COUNT++; $error("oe=1 dout=%h exp=%h", dout, din); end
            oe = 0; #5;
            if (dout !== 8'bz)  begin ERR_COUNT++; $error("oe=0 dout=%h exp=zz", dout); end
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
