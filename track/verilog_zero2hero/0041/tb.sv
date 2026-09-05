`timescale 1ns/1ps
// ---- DUT the student must drive (do not edit) ----
module acc_dut (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        valid,
    input  logic [7:0]  din,
    output logic [15:0] sum
);
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n)     sum <= 16'd0;
        else if (valid) sum <= sum + din;
endmodule

// ---- Outer checker: probe the student's dut for correct accumulation ----
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    int   ERR_COUNT = 0;
    int   redges = 0;
    int   valid_beats = 0;
    logic saw_rst = 0;

    tb_top DUT ();

    always @(posedge DUT.dut.clk) begin
        redges++;
        if (DUT.dut.rst_n === 1'b1 && DUT.dut.valid === 1'b1) valid_beats++;
    end
    always @(*) if (DUT.dut.rst_n === 1'b0) saw_rst = 1'b1;

    initial begin
        #400;
        if (redges < 10)            begin ERR_COUNT++; $error("clock not toggling - model a clock"); end
        if (!saw_rst)               begin ERR_COUNT++; $error("reset never applied"); end
        if (valid_beats != 4)       begin ERR_COUNT++; $error("expected 4 valid transactions, saw %0d (hold valid one clock each)", valid_beats); end
        if (DUT.dut.sum !== 16'd100)  begin ERR_COUNT++; $error("accumulator=%0d expected 100 (send 10,20,30,40)", DUT.dut.sum); end
        if (ERR_COUNT > 0) $display("Test failed with %0d errors.", ERR_COUNT);
        else               $display("Test PASS");
        $finish;
    end
    // waveform dump for `make wave` (whole hierarchy, including DUT.dut)
    string vcdfile;
    initial if ($value$plusargs("VCDFILE=%s", vcdfile)) begin
        $dumpfile(vcdfile); $dumpvars(0, tb);
    end
    initial begin #(TB_SIM_TIMEOUT) $error("Simulation TIMEOUT"); $finish; end
endmodule
