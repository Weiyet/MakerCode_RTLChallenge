module param_inst (
    input  logic        clk,
    input  logic [3:0]  d4,
    output logic [3:0]  q4,
    input  logic [11:0] d12,
    output logic [11:0] q12
);
    wide_reg #(.WIDTH(4))  u4  (.clk(clk), .d(d4),  .q(q4));
    wide_reg #(.WIDTH(12)) u12 (.clk(clk), .d(d12), .q(q12));
endmodule
