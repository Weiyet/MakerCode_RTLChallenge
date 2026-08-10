module sel_mux (
    input  logic [1:0] sel,
    input  logic [7:0] a,
    input  logic [7:0] b,
    input  logic [7:0] c,
    output logic [7:0] y
);
    // use always_comb with a default assignment (no inferred latch)

endmodule
