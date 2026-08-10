// Instantiate wide_reg (in tb.sv) twice, overriding WIDTH to 4 and 12.
module param_inst (
    input  logic        clk,
    input  logic [3:0]  d4,
    output logic [3:0]  q4,
    input  logic [11:0] d12,
    output logic [11:0] q12
);
    // your implementation here

endmodule
