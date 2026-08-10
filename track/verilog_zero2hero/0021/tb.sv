`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic clk, d, q, q_exp;
    int ERR_COUNT = 0;

    dff DUT (.clk(clk), .d(d), .q(q));

    initial begin clk = 0; forever #5 clk = ~clk; end

    always_ff @(posedge clk) q_exp <= d;

    always @(posedge clk) begin
        #1;
        if (q !== q_exp) begin ERR_COUNT++; $error("%0tns q=%b expected=%b", $time, q, q_exp); end
    end

    initial begin
        d = 0;
        @(negedge clk);
        for (int i = 0; i < 40; i++) begin d = $random; @(negedge clk); end
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
