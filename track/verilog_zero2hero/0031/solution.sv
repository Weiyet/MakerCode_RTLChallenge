module uart_tx #(
    parameter int CLKS_PER_BIT = 8
) (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       start,
    input  logic [7:0] data,
    output logic       tx,
    output logic       busy
);
    typedef enum logic [1:0] {IDLE, START, DATA, STOP} state_e;
    state_e state;

    localparam int CW = (CLKS_PER_BIT <= 1) ? 1 : $clog2(CLKS_PER_BIT);
    logic [CW-1:0] clk_cnt;
    logic [2:0]    bit_idx;
    logic [7:0]    shreg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state   <= IDLE;
            clk_cnt <= '0;
            bit_idx <= '0;
            shreg   <= '0;
        end else begin
            case (state)
                IDLE: begin
                    clk_cnt <= '0;
                    bit_idx <= '0;
                    if (start) begin
                        shreg <= data;
                        state <= START;
                    end
                end
                START:
                    if (clk_cnt == CLKS_PER_BIT-1) begin clk_cnt <= '0; state <= DATA; end
                    else clk_cnt <= clk_cnt + 1'b1;
                DATA:
                    if (clk_cnt == CLKS_PER_BIT-1) begin
                        clk_cnt <= '0;
                        if (bit_idx == 3'd7) state <= STOP;
                        else bit_idx <= bit_idx + 1'b1;
                    end else clk_cnt <= clk_cnt + 1'b1;
                STOP:
                    if (clk_cnt == CLKS_PER_BIT-1) begin clk_cnt <= '0; state <= IDLE; end
                    else clk_cnt <= clk_cnt + 1'b1;
                default: state <= IDLE;
            endcase
        end
    end

    always_comb begin
        case (state)
            START:   tx = 1'b0;
            DATA:    tx = shreg[bit_idx];
            default: tx = 1'b1;   // IDLE and STOP hold the line high
        endcase
    end

    assign busy = (state != IDLE);
endmodule
