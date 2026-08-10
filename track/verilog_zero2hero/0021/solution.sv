module shift3 (
    input  logic       clk,
    input  logic       din,
    output logic [2:0] q
);
    always_ff @(posedge clk) begin
        q[0] <= din;
        q[1] <= q[0];
        q[2] <= q[1];
    end
endmodule
