module reduction_ops (
    input  logic [7:0] in,
    output logic       all_ones,
    output logic       any_one,
    output logic       parity
);
    assign all_ones = &in;
    assign any_one  = |in;
    assign parity   = ^in;
endmodule
