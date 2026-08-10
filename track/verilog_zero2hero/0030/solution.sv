module seq_src (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       ready,
    output logic       valid,
    output logic [7:0] data
);
    assign valid = 1'b1;
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n)              data <= 8'd0;
        else if (valid && ready) data <= data + 8'd1;
endmodule
