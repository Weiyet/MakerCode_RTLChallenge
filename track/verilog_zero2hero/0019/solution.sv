module dff_reset (
    input  logic clk,
    input  logic rst_n,
    input  logic d,
    output logic q_sync,
    output logic q_async
);
    always_ff @(posedge clk)
        if (!rst_n) q_sync <= 1'b0;
        else        q_sync <= d;

    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) q_async <= 1'b0;
        else        q_async <= d;
endmodule
