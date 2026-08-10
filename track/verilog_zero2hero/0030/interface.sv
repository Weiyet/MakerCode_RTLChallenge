module seq_src (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       ready,
    output logic       valid,
    output logic [7:0] data
);
    // hold valid high; advance data only when valid && ready

endmodule
