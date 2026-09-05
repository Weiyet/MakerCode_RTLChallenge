`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    localparam AW = 4, DW = 8;
    logic clk = 0, we;
    logic [AW-1:0] addr;
    logic [DW-1:0] wdata, rdata;
    logic [DW-1:0] model [0:(1<<AW)-1];
    logic [DW-1:0] exp;
    int ERR_COUNT = 0;
    ram #(.AW(AW), .DW(DW)) DUT (.clk(clk), .we(we), .addr(addr), .wdata(wdata), .rdata(rdata));
    always #5 clk = ~clk;
    initial begin
        we = 0; addr = 0; wdata = 0;
        // Phase 1: write every location = addr*3+1
        @(negedge clk);
        for (int i = 0; i < (1<<AW); i++) begin
            we = 1; addr = i[AW-1:0]; wdata = (i*3 + 1); model[i] = wdata;
            @(negedge clk);
        end
        we = 0;
        // Phase 2: read back; rdata is registered => compare to address driven ONE cycle earlier
        for (int i = 0; i < (1<<AW); i++) begin
            addr = i[AW-1:0];
            @(posedge clk); #1;                 // rdata now reflects THIS addr
            exp = model[i];
            if (rdata !== exp) begin ERR_COUNT++; $error("read addr=%0d rdata=%h exp=%h", i, rdata, exp); end
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
