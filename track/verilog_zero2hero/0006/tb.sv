`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic [31:0] d, bitrev, byterev, eb, ey;
    int ERR_COUNT = 0;
    reverser DUT (.d(d), .bitrev(bitrev), .byterev(byterev));
    initial begin
        for (int t = 0; t < 100; t++) begin
            d = {$random}; #5;
            for (int i = 0; i < 32; i++) eb[i] = d[31 - i];
            ey = {d[7:0], d[15:8], d[23:16], d[31:24]};
            if (bitrev  !== eb) begin ERR_COUNT++; $error("bitrev d=%h got=%h exp=%h", d, bitrev, eb); end
            if (byterev !== ey) begin ERR_COUNT++; $error("byterev d=%h got=%h exp=%h", d, byterev, ey); end
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
