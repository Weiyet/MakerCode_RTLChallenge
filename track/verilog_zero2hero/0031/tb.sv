`timescale 1ns/1ps
module tb #(parameter int CLKS_PER_BIT = 8);
    localparam TB_SIM_TIMEOUT = 2000000;
    logic clk, rst_n, start, tx, busy;
    logic [7:0] data;
    int ERR_COUNT = 0;

    uart_tx #(.CLKS_PER_BIT(CLKS_PER_BIT)) DUT (
        .clk(clk), .rst_n(rst_n), .start(start), .data(data), .tx(tx), .busy(busy));

    initial begin clk = 0; forever #5 clk = ~clk; end

    // UART receiver: sample tx mid-bit and reconstruct the byte
    task automatic send_and_check(input logic [7:0] b);
        logic [7:0] rx;
        begin
            @(negedge clk);
            data = b; start = 1'b1;
            @(negedge clk); start = 1'b0;

            // wait for the start bit (line goes low)
            wait (tx == 1'b0);
            // move to the middle of the start bit
            repeat (CLKS_PER_BIT/2) @(posedge clk);
            if (tx !== 1'b0) begin ERR_COUNT++; $error("%0tns bad start bit for %h", $time, b); end
            // sample 8 data bits, LSB first
            for (int i = 0; i < 8; i++) begin
                repeat (CLKS_PER_BIT) @(posedge clk);
                rx[i] = tx;
            end
            // stop bit
            repeat (CLKS_PER_BIT) @(posedge clk);
            if (tx !== 1'b1) begin ERR_COUNT++; $error("%0tns bad stop bit for %h", $time, b); end
            if (rx !== b)     begin ERR_COUNT++; $error("%0tns rx=%h expected=%h", $time, rx, b); end
            else              $display("%0tns sent %h received %h OK", $time, b, rx);
            // let the frame finish
            wait (busy == 1'b0);
            @(negedge clk);
        end
    endtask

    initial begin
        rst_n = 0; start = 0; data = 0;
        repeat(3) @(negedge clk);
        rst_n = 1;
        repeat(2) @(negedge clk);
        send_and_check(8'hA5);
        send_and_check(8'h00);
        send_and_check(8'hFF);
        send_and_check(8'h3C);
        send_and_check(8'h81);
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
    initial begin #(TB_SIM_TIMEOUT) $display("Simulation TIMEOUT"); $finish; end
endmodule
