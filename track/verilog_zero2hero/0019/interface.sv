module popcount #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH-1:0]            in,
    output logic [$clog2(WIDTH+1)-1:0]  count
);
    // your implementation here

endmodule
