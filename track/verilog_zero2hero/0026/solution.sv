module edge_detector (
    input  logic clk,
    input  logic rst_n,
    input  logic sig,
    output logic rise,
    output logic fall
);
    logic prev;
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) begin
            prev <= 1'b0; rise <= 1'b0; fall <= 1'b0;
        end else begin
            prev <= sig;
            rise <=  sig & ~prev;
            fall <= ~sig &  prev;
        end
endmodule
