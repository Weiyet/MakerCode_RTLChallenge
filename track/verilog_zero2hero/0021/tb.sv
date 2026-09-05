`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic clk = 0, din;
    logic [2:0] q;
    logic [2:0] gold;   // golden: {old din history}
    int ERR_COUNT = 0;
    shift3 DUT (.clk(clk), .din(din), .q(q));
    always #5 clk = ~clk;
    // golden reference model (correct non-blocking behaviour)
    always_ff @(posedge clk) gold <= {gold[1:0], din};
    always @(posedge clk) begin
        #1;
        if (q !== gold) begin ERR_COUNT++; $error("q=%b exp=%b (blocking assignment?)", q, gold); end
    end
    initial begin
        din = 0; @(negedge clk);
        for (int i = 0; i < 40; i++) begin din = $random; @(negedge clk); end
        repeat (3) @(posedge clk);
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
