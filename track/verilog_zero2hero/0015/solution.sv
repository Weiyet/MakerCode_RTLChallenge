module ctrl_pack (
    input  logic [3:0]  opcode,
    input  logic [2:0]  src,
    input  logic [2:0]  dst,
    input  logic [5:0]  imm,
    output logic [15:0] word
);
    typedef struct packed {
        logic [3:0] opcode;
        logic [2:0] src;
        logic [2:0] dst;
        logic [5:0] imm;
    } ctrl_t;

    ctrl_t c;
    always_comb begin
        c.opcode = opcode;
        c.src    = src;
        c.dst    = dst;
        c.imm    = imm;
        word     = c;
    end
endmodule
