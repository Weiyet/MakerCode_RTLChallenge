`timescale 1ns/1ps
module tb #(parameter int STABLE = 4);
    localparam TB_SIM_TIMEOUT = 200000;
    localparam int CW = (STABLE <= 1) ? 1 : $clog2(STABLE);
    logic clk, rst_n, noisy, clean;
    logic clean_e;
    logic [CW-1:0] cnt_e;
    int ERR_COUNT = 0;

    debouncer #(.STABLE(STABLE)) DUT (.clk(clk), .rst_n(rst_n), .noisy(noisy), .clean(clean));

    initial begin clk = 0; forever #5 clk = ~clk; end

    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) begin clean_e <= 1'b0; cnt_e <= '0; end
        else if (noisy != clean_e) begin
            if (cnt_e == STABLE-1) begin clean_e <= noisy; cnt_e <= '0; end
            else cnt_e <= cnt_e + 1'b1;
        end else cnt_e <= '0;

    always @(posedge clk) begin
        #1;
        if (clean !== clean_e) begin ERR_COUNT++; $error("%0tns clean=%b exp=%b", $time, clean, clean_e); end
    end

    initial begin
        rst_n = 0; noisy = 0;
        repeat(3) @(negedge clk);
        rst_n = 1;
        // bursts of bounce then stable stretches
        for (int i = 0; i < 200; i++) begin
            if (i % 20 < 6) noisy = $random;   // bounce
            else            noisy = (i % 40 < 20);  // stable level
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
