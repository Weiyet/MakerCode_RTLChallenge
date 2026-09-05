`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic a, y, one, zero;
    int ERR_COUNT = 0;
    wires_const DUT (.a(a), .y(y), .one(one), .zero(zero));
    initial begin
        for (int i = 0; i < 2; i++) begin
            a = i[0]; #5;
            if (y    !== a)    begin ERR_COUNT++; $error("y=%b exp %b", y, a); end
            if (one  !== 1'b1) begin ERR_COUNT++; $error("one=%b exp 1", one); end
            if (zero !== 1'b0) begin ERR_COUNT++; $error("zero=%b exp 0", zero); end
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
