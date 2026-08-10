module uart_tx #(
    parameter int CLKS_PER_BIT = 8
) (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       start,
    input  logic [7:0] data,
    output logic       tx,
    output logic       busy
);
    // your implementation here

endmodule
