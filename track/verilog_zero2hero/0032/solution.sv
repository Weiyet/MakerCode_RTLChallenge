module inst_by_position (
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic out1,
    output logic out2
);
    mod_a u_a (out1, out2, a, b, c, d);
endmodule
