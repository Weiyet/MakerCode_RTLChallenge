module sel_mux (
    input  logic [1:0] sel,
    input  logic [7:0] a,
    input  logic [7:0] b,
    input  logic [7:0] c,
    output logic [7:0] y
);
    always_comb begin
        y = '0;
        case (sel)
            2'd0: y = a;
            2'd1: y = b;
            2'd2: y = c;
        endcase
    end
endmodule
