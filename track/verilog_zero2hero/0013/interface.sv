module mux4to1 #(
    parameter int W = 8
) (
    input  logic [W-1:0] d0,
    input  logic [W-1:0] d1,
    input  logic [W-1:0] d2,
    input  logic [W-1:0] d3,
    input  logic [1:0]   sel,
    output logic [W-1:0] y
);
    // your implementation here

endmodule
