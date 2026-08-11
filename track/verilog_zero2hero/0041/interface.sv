// Write a testbench: clock + reset, then a task that sends accumulate transactions.
// The DUT (acc_dut, defined in tb.sv) is already instantiated as `dut`.
module tb_top;
    logic        clk;
    logic        rst_n;
    logic        valid;
    logic [7:0]  din;
    logic [15:0] sum;

    // TODO: model a clock on clk

    // TODO: a task send(byte) that pulses valid with din for one clock

    // TODO: initial block -> reset, then send 10, 20, 30, 40

    // DUT instance (provided - do not rename)
    acc_dut dut (.clk(clk), .rst_n(rst_n), .valid(valid), .din(din), .sum(sum));
endmodule
