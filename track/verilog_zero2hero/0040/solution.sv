module tb_top;
    logic       clk;
    logic       rst_n;
    logic       en;
    logic [7:0] count;

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        rst_n = 1'b0; en = 1'b0;
        #12 rst_n = 1'b1;
        #10 en    = 1'b1;
    end

    counter_dut dut (.clk(clk), .rst_n(rst_n), .en(en), .count(count));
endmodule
