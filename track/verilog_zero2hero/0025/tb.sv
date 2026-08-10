`timescale 1ns/1ps
module tb #(parameter int W = 8);
    localparam TB_SIM_TIMEOUT = 100000;
    logic clk, rst_n, load, en, up_down;
    logic [W-1:0] load_val, count, exp;
    int ERR_COUNT = 0;

    updown_counter #(.W(W)) DUT (.clk(clk), .rst_n(rst_n), .load(load),
        .load_val(load_val), .en(en), .up_down(up_down), .count(count));

    initial begin clk = 0; forever #5 clk = ~clk; end

    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n)    exp <= '0;
        else if (load) exp <= load_val;
        else if (en)   exp <= up_down ? exp + 1'b1 : exp - 1'b1;

    always @(posedge clk) begin
        #1;
        if (count !== exp) begin ERR_COUNT++; $error("%0tns count=%0d exp=%0d", $time, count, exp); end
    end

    initial begin
        rst_n = 0; load = 0; en = 0; up_down = 1; load_val = 0;
        repeat(3) @(negedge clk);
        rst_n = 1;
        for (int i = 0; i < 80; i++) begin
            load = ($random % 8 == 0); load_val = $random;
            en = $random; up_down = $random;
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
