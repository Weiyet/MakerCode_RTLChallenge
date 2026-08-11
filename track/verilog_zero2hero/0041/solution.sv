module tb_top;
    logic        clk;
    logic        rst_n;
    logic        valid;
    logic [7:0]  din;
    logic [15:0] sum;

    initial clk = 1'b0;
    always #5 clk = ~clk;

    task automatic send(input logic [7:0] b);
        begin
            @(negedge clk);
            din = b; valid = 1'b1;
            @(negedge clk);
            valid = 1'b0;
        end
    endtask

    initial begin
        rst_n = 1'b0; valid = 1'b0; din = 8'd0;
        #12 rst_n = 1'b1;
        send(8'd10);
        send(8'd20);
        send(8'd30);
        send(8'd40);
    end

    acc_dut dut (.clk(clk), .rst_n(rst_n), .valid(valid), .din(din), .sum(sum));
endmodule
