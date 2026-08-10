module updown_counter #(
    parameter int W = 8
) (
    input  logic         clk,
    input  logic         rst_n,
    input  logic         load,
    input  logic [W-1:0] load_val,
    input  logic         en,
    input  logic         up_down,
    output logic [W-1:0] count
);
    // your implementation here

endmodule
