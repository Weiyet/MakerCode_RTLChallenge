module wires_const (
    input  logic a,
    output logic y,
    output logic one,
    output logic zero
);
    assign y    = a;
    assign one  = 1'b1;
    assign zero = 1'b0;
endmodule
