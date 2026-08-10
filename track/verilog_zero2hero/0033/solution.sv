module inst_by_name (
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic out1,
    output logic out2
);
    mod_a u_a (.a(a), .b(b), .c(c), .d(d), .out1(out1), .out2(out2));
endmodule
