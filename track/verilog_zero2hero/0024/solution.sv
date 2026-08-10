module shift_register #(
    parameter int W = 8
) (
    input  logic         clk,
    input  logic         rst_n,
    input  logic         sin,
    output logic [W-1:0] q
);
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) q <= '0;
        else        q <= {q[W-2:0], sin};
endmodule
