module reverser (
    input  logic [31:0] d,
    output logic [31:0] bitrev,
    output logic [31:0] byterev
);
    always_comb
        for (int i = 0; i < 32; i++)
            bitrev[i] = d[31 - i];

    assign byterev = {d[7:0], d[15:8], d[23:16], d[31:24]};
endmodule
