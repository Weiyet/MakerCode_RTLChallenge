module seq_detector_1011 (
    input  logic clk,
    input  logic rst_n,
    input  logic din,
    output logic detected
);
    typedef enum logic [2:0] {S0, S1, S2, S3, S4} state_e;
    state_e state;

    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) state <= S0;
        else case (state)
            S0: state <= din ? S1 : S0;
            S1: state <= din ? S1 : S2;
            S2: state <= din ? S3 : S0;
            S3: state <= din ? S4 : S2;
            S4: state <= din ? S1 : S2;   // overlap: last bit was 1
            default: state <= S0;
        endcase

    assign detected = (state == S4);
endmodule
