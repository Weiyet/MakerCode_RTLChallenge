module shift8_mux (
    input  logic       clk,
    input  logic [7:0] d,
    input  logic [1:0] sel,
    output logic [7:0] q
);
    logic [7:0] o1, o2, o3;
    my_dff8 a (.clk(clk), .d(d),  .q(o1));
    my_dff8 b (.clk(clk), .d(o1), .q(o2));
    my_dff8 c (.clk(clk), .d(o2), .q(o3));

    always_comb
        case (sel)
            2'd0:    q = d;
            2'd1:    q = o1;
            2'd2:    q = o2;
            default: q = o3;
        endcase
endmodule
