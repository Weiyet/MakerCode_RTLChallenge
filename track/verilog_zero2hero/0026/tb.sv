`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic clk, rst_n, sig, rise, fall;
    logic prev_e, rise_e, fall_e;
    int ERR_COUNT = 0;

    edge_detector DUT (.clk(clk), .rst_n(rst_n), .sig(sig), .rise(rise), .fall(fall));

    initial begin clk = 0; forever #5 clk = ~clk; end

    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) begin prev_e <= 0; rise_e <= 0; fall_e <= 0; end
        else begin prev_e <= sig; rise_e <= sig & ~prev_e; fall_e <= ~sig & prev_e; end

    always @(posedge clk) begin
        #1;
        if (rise !== rise_e) begin ERR_COUNT++; $error("%0tns rise=%b exp=%b", $time, rise, rise_e); end
        if (fall !== fall_e) begin ERR_COUNT++; $error("%0tns fall=%b exp=%b", $time, fall, fall_e); end
    end

    initial begin
        rst_n = 0; sig = 0;
        repeat(3) @(negedge clk);
        rst_n = 1;
        for (int i = 0; i < 60; i++) begin sig = $random; @(negedge clk); end
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
