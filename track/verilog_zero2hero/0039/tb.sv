`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic start = 0;
    logic [2:0] flag;
    logic done;
    int ERR_COUNT = 0;

    parallel_join DUT (.start(start), .flag(flag), .done(done));

    initial begin
        #5 start = 1;
        #15;  // t + 15
        if (flag !== 3'b001) begin ERR_COUNT++; $error("t+15 flag=%b exp 001 (parallel?)", flag); end
        #10;  // t + 25
        if (flag !== 3'b011) begin ERR_COUNT++; $error("t+25 flag=%b exp 011 (parallel?)", flag); end
        #4;   // t + 29
        if (done !== 1'b0)   begin ERR_COUNT++; $error("t+29 done=%b asserted before all branches finished", done); end
        #2;   // t + 31
        if (done !== 1'b1)   begin ERR_COUNT++; $error("t+31 done=%b not set by +30 (ran sequentially?)", done); end
        if (flag !== 3'b111) begin ERR_COUNT++; $error("done flag=%b exp 111", flag); end
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
