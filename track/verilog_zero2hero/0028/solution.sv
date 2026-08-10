module mealy_11 (
    input  logic clk,
    input  logic rst_n,
    input  logic din,
    output logic y
);
    typedef enum logic {S0, S1} state_e;
    state_e state;

    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) state <= S0;
        else        state <= din ? S1 : S0;

    assign y = (state == S1) & din;
endmodule
