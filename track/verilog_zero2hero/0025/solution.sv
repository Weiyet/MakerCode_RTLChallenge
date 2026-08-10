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
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n)    count <= '0;
        else if (load) count <= load_val;
        else if (en)   count <= up_down ? count + 1'b1 : count - 1'b1;
endmodule
