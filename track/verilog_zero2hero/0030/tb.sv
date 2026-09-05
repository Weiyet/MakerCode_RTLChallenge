`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic clk = 0, rst_n, ready;
    logic valid;
    logic [7:0] data;
    logic [7:0] expect_next = 0;
    int ERR_COUNT = 0;
    int got = 0;
    seq_src DUT (.clk(clk), .rst_n(rst_n), .ready(ready), .valid(valid), .data(data));
    always #5 clk = ~clk;
    // consumer: on every accepted beat, the value must be the next in sequence
    always @(posedge clk) begin
        if (rst_n && valid && ready) begin
            if (data !== expect_next) begin ERR_COUNT++; $error("beat data=%0d exp=%0d", data, expect_next); end
            expect_next <= expect_next + 8'd1;
            got <= got + 1;
        end
    end
    initial begin
        rst_n = 0; ready = 0;
        repeat (2) @(negedge clk);
        rst_n = 1;
        // apply bursty backpressure via random ready
        for (int i = 0; i < 300; i++) begin ready = $random; @(negedge clk); end
        if (got < 20) begin ERR_COUNT++; $error("too few beats accepted: %0d", got); end
        check_result;
    end
    task check_result;
    begin
        if (ERR_COUNT > 0) $display("Test failed with %0d errors.", ERR_COUNT);
        else               $display("Test PASS");
        $finish;
    end
    endtask
    string filename;
    initial begin
        if ($value$plusargs("VCDFILE=%s", filename)) begin
            $dumpfile(filename); $dumpvars(0, DUT);
        end
    end
    initial begin #(TB_SIM_TIMEOUT) $error("Simulation TIMEOUT"); $finish; end
endmodule
