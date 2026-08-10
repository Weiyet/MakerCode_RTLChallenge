module debouncer #(
    parameter int STABLE = 4
) (
    input  logic clk,
    input  logic rst_n,
    input  logic noisy,
    output logic clean
);
    localparam int CW = (STABLE <= 1) ? 1 : $clog2(STABLE);
    logic [CW-1:0] cnt;

    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) begin
            clean <= 1'b0;
            cnt   <= '0;
        end else if (noisy != clean) begin
            if (cnt == STABLE-1) begin
                clean <= noisy;
                cnt   <= '0;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end else begin
            cnt <= '0;
        end
endmodule
