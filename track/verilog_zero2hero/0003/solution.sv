module vector_split (
    input  logic [15:0] in,
    output logic [7:0]  hi,
    output logic [7:0]  lo
);
    assign hi = in[15:8];
    assign lo = in[7:0];
endmodule
