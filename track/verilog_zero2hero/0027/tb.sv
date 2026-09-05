`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic clk, rst_n, din, detected;
    logic [3:0] sr;
    logic det_e;
    int ERR_COUNT = 0;

    seq_detector_1011 DUT (.clk(clk), .rst_n(rst_n), .din(din), .detected(detected));

    initial begin clk = 0; forever #5 clk = ~clk; end

    // golden: last 4 bits == 1011
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) sr <= 4'b0; else sr <= {sr[2:0], din};
    assign det_e = (sr == 4'b1011);

    always @(posedge clk) begin
        #1;
        if (detected !== det_e) begin ERR_COUNT++; $error("%0tns detected=%b exp=%b sr=%b", $time, detected, det_e, sr); end
    end

    initial begin
        rst_n = 0; din = 0;
        repeat(3) @(negedge clk);
        rst_n = 1;
        // include the overlapping pattern 1011011 plus random
        for (int i = 0; i < 100; i++) begin din = $random; @(negedge clk); end
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
    initial begin #(TB_SIM_TIMEOUT) $error("Simulation TIMEOUT"); $finish; end
endmodule
