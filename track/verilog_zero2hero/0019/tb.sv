`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic clk, rst_n, d, q_sync, q_async;
    logic exp_sync, exp_async;
    int ERR_COUNT = 0;

    dff_reset DUT (.clk(clk), .rst_n(rst_n), .d(d), .q_sync(q_sync), .q_async(q_async));

    initial begin clk = 0; forever #5 clk = ~clk; end

    always_ff @(posedge clk)
        if (!rst_n) exp_sync <= 1'b0; else exp_sync <= d;
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) exp_async <= 1'b0; else exp_async <= d;

    always @(posedge clk) begin
        #1;
        if (q_sync  !== exp_sync)  begin ERR_COUNT++; $error("%0tns q_sync=%b exp=%b",  $time, q_sync,  exp_sync);  end
        if (q_async !== exp_async) begin ERR_COUNT++; $error("%0tns q_async=%b exp=%b", $time, q_async, exp_async); end
    end

    initial begin
        rst_n = 0; d = 0;
        repeat(3) @(negedge clk);
        rst_n = 1;
        for (int i = 0; i < 40; i++) begin
            d = $random;
            if (i == 12) rst_n = 0;      // mid-cycle async reset pulse
            if (i == 14) rst_n = 1;
            @(negedge clk);
        end
        repeat(2) @(posedge clk);
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
