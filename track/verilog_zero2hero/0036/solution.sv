module adder32 (
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] sum
);
    logic carry;
    add16 u_lo (.a(a[15:0]),  .b(b[15:0]),  .cin(1'b0),  .sum(sum[15:0]),  .cout(carry));
    add16 u_hi (.a(a[31:16]), .b(b[31:16]), .cin(carry), .sum(sum[31:16]), .cout());
endmodule
