module gray_codec #(
    parameter int W = 4
) (
    input  logic [W-1:0] bin,
    input  logic [W-1:0] gray_in,
    output logic [W-1:0] gray,
    output logic [W-1:0] bin_out
);
    function automatic logic [W-1:0] bin2gray(input logic [W-1:0] b);
        return b ^ (b >> 1);
    endfunction

    function automatic logic [W-1:0] gray2bin(input logic [W-1:0] g);
        logic [W-1:0] b;
        b[W-1] = g[W-1];
        for (int i = W-2; i >= 0; i--)
            b[i] = b[i+1] ^ g[i];
        return b;
    endfunction

    assign gray    = bin2gray(bin);
    assign bin_out = gray2bin(gray_in);
endmodule
