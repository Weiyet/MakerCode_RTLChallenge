module alu #(
    parameter int W = 8
) (
    input  logic [W-1:0] a,
    input  logic [W-1:0] b,
    input  logic [2:0]   op,
    output logic [W-1:0] y,
    output logic         zero
);
    typedef enum logic [2:0] {
        OP_ADD, OP_SUB, OP_AND, OP_OR, OP_XOR, OP_SLL, OP_SRL, OP_SLT
    } op_e;

    always_comb begin
        case (op)
            OP_ADD: y = a + b;
            OP_SUB: y = a - b;
            OP_AND: y = a & b;
            OP_OR:  y = a | b;
            OP_XOR: y = a ^ b;
            OP_SLL: y = a << b[2:0];
            OP_SRL: y = a >> b[2:0];
            OP_SLT: y = (a < b) ? {{(W-1){1'b0}}, 1'b1} : '0;
            default: y = '0;
        endcase
        zero = (y == '0);
    end
endmodule
