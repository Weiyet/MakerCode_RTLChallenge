`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic a, b, sum, cout;
    int ERR_COUNT = 0;

    half_adder DUT (.a(a), .b(b), .sum(sum), .cout(cout));

    initial begin
        for (int i = 0; i < 4; i++) begin
            {a, b} = i[1:0];
            #5;
            if ({cout, sum} !== (a + b)) begin ERR_COUNT++; $error("%0tns a=%b b=%b {cout,sum}=%b%b exp=%0d", $time, a, b, cout, sum, a+b); end
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
    initial begin #(TB_SIM_TIMEOUT) $display("Simulation TIMEOUT"); $finish; end
endmodule
