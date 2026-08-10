`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic a, b, cin, sum, cout;
    int ERR_COUNT = 0;

    full_adder DUT (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    initial begin
        for (int i = 0; i < 8; i++) begin
            {a, b, cin} = i[2:0];
            #5;
            if ({cout, sum} !== (a + b + cin)) begin ERR_COUNT++; $error("%0tns a=%b b=%b cin=%b got=%b%b exp=%0d", $time, a, b, cin, cout, sum, a+b+cin); end
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
