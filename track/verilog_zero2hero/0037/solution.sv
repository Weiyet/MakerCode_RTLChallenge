module addsub32 (
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic        sub,
    output logic [31:0] sum
);
    logic [31:0] b_x;
    logic        carry;
    assign b_x = b ^ {32{sub}};
    add16 u_lo (.a(a[15:0]),  .b(b_x[15:0]),  .cin(sub),   .sum(sum[15:0]),  .cout(carry));
    add16 u_hi (.a(a[31:16]), .b(b_x[31:16]), .cin(carry), .sum(sum[31:16]), .cout());
endmodule
