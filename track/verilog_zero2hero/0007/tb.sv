`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic a, b, cin, h_sum, h_cout, sum, cout;
    int ERR_COUNT = 0;
    adders DUT (.a(a), .b(b), .cin(cin), .h_sum(h_sum), .h_cout(h_cout), .sum(sum), .cout(cout));
    initial begin
        for (int i = 0; i < 8; i++) begin
            {a, b, cin} = i[2:0]; #5;
            if ({h_cout, h_sum} !== (a + b))       begin ERR_COUNT++; $error("half a=%b b=%b", a, b); end
            if ({cout,  sum}    !== (a + b + cin)) begin ERR_COUNT++; $error("full a=%b b=%b cin=%b", a, b, cin); end
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
