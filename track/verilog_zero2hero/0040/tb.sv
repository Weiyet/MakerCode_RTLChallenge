`timescale 1ns/1ps
// ---- DUT the student must drive (do not edit) ----
module counter_dut (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       en,
    output logic [7:0] count
);
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n)   count <= 8'd0;
        else if (en)  count <= count + 8'd1;
endmodule

// ---- Outer checker: instantiate the student's tb_top and probe dut.* ----
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    int  ERR_COUNT = 0;
    int  redges = 0;
    logic saw_rst_low = 0, saw_rst_high = 0, saw_en = 0;

    tb_top u ();

    always @(posedge u.dut.clk) redges++;
    always @(*) begin
        if (u.dut.rst_n === 1'b0) saw_rst_low  = 1'b1;
        if (u.dut.rst_n === 1'b1) saw_rst_high = 1'b1;
        if (u.dut.en    === 1'b1) saw_en       = 1'b1;
    end

    initial begin
        #400;
        if (redges < 10)            begin ERR_COUNT++; $error("clock not toggling (redges=%0d) - model a clock", redges); end
        if (!saw_rst_low)           begin ERR_COUNT++; $error("reset never asserted low"); end
        if (!saw_rst_high)          begin ERR_COUNT++; $error("reset never released high"); end
        if (!saw_en)                begin ERR_COUNT++; $error("enable never driven high"); end
        if (u.dut.count === 8'd0)   begin ERR_COUNT++; $error("DUT never counted - your stimulus did not exercise it"); end
        if (ERR_COUNT > 0) $display("Test failed with %0d errors.", ERR_COUNT);
        else               $display("Test PASS");
        $finish;
    end
    // waveform dump for `make wave` (whole hierarchy, including u.dut)
    string vcdfile;
    initial if ($value$plusargs("VCDFILE=%s", vcdfile)) begin
        $dumpfile(vcdfile); $dumpvars(0, tb);
    end
    initial begin #(TB_SIM_TIMEOUT) $display("Simulation TIMEOUT"); $finish; end
endmodule
