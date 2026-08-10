module decoder2to4 (
    input  logic [1:0] in,
    input  logic       en,
    output logic [3:0] out
);
    always_comb begin
        out = 4'b0000;
        if (en) out[in] = 1'b1;
    end
endmodule
