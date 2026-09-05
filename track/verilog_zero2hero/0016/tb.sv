`timescale 1ns/1ps
module tb #(parameter int WIDTH = 8);
    localparam TB_SIM_TIMEOUT = 100000;
    logic [WIDTH-1:0] in;
    logic [$clog2(WIDTH+1)-1:0] count;
    int exp;
    int ERR_COUNT = 0;

    popcount #(.WIDTH(WIDTH)) DUT (.in(in), .count(count));

    initial begin
        for (int t = 0; t < 60; t++) begin
            in = $random;
            #5;
            exp = 0;
            for (int i = 0; i < WIDTH; i++) exp += in[i];
            if (count !== exp[$clog2(WIDTH+1)-1:0]) begin ERR_COUNT++; $error("%0tns in=%b count=%0d exp=%0d", $time, in, count, exp); end
            #5;
        end
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
