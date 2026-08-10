module popcount #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH-1:0]            in,
    output logic [$clog2(WIDTH+1)-1:0]  count
);
    always_comb begin
        count = '0;
        for (int i = 0; i < WIDTH; i++)
            count += in[i];
    end
endmodule
