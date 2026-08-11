// Write a testbench: model the clock and drive reset/enable for the provided DUT.
// The DUT (counter_dut, defined in tb.sv) is already instantiated as `dut`.
module tb_top;
    logic       clk;
    logic       rst_n;
    logic       en;
    logic [7:0] count;

    // TODO: model a clock on clk

    // TODO: initial block -> hold reset, release it, then assert en

    // DUT instance (provided - do not rename)
    counter_dut dut (.clk(clk), .rst_n(rst_n), .en(en), .count(count));
endmodule
