module vector_reverse (
    input  logic [7:0] in,
    output logic [7:0] out
);
    always_comb begin
        for (int i = 0; i < 8; i++)
            out[i] = in[7-i];
    end
endmodule
