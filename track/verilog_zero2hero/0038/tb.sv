`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic [7:0] a, b, mx, absdiff;
    logic [8:0] sum;
    int ERR_COUNT = 0;

    stats DUT (.a(a), .b(b), .mx(mx), .sum(sum), .absdiff(absdiff));

    initial begin
        for (int i = 0; i < 80; i++) begin
            a = $random; b = $random;
            #5;
            if (mx      !== ((a > b) ? a : b))              begin ERR_COUNT++; $error("%0tns mx=%0d a=%0d b=%0d", $time, mx, a, b); end
            if (sum     !== (a + b))                        begin ERR_COUNT++; $error("%0tns sum=%0d exp=%0d", $time, sum, a + b); end
            if (absdiff !== ((a > b) ? (a - b) : (b - a)))  begin ERR_COUNT++; $error("%0tns absdiff=%0d", $time, absdiff); end
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
