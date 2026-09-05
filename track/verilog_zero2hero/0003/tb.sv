`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic [15:0] in;
    logic [7:0]  hi, lo;
    int ERR_COUNT = 0;

    vector_split DUT (.in(in), .hi(hi), .lo(lo));

    initial begin
        for (int i = 0; i < 20; i++) begin
            in = $random;
            #5;
            if (hi !== in[15:8]) begin ERR_COUNT++; $error("%0tns hi=%h expected=%h", $time, hi, in[15:8]); end
            if (lo !== in[7:0])  begin ERR_COUNT++; $error("%0tns lo=%h expected=%h", $time, lo, in[7:0]);  end
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
