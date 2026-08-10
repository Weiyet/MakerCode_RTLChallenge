module byte_reverse (
    input  logic [31:0] in,
    output logic [31:0] out
);
    logic [7:0] b [4];   // unpacked array (scratch)
    always_comb begin
        for (int i = 0; i < 4; i++) b[i]            = in[i*8 +: 8];
        for (int i = 0; i < 4; i++) out[i*8 +: 8]   = b[3-i];
    end
endmodule
