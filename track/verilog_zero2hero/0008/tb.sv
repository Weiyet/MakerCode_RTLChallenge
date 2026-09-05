`timescale 1ns/1ps
module tb #(parameter int WIDTH = 4);
    localparam TB_SIM_TIMEOUT = 100000;
    logic [WIDTH-1:0] a, b, sum;
    logic cin, cout;
    logic [WIDTH:0] exp;
    int ERR_COUNT = 0;

    ripple_adder #(.WIDTH(WIDTH)) DUT (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    initial begin
        for (int t = 0; t < 40; t++) begin
            a = $random; b = $random; cin = $random;
            #5;
            exp = a + b + cin;
            if ({cout, sum} !== exp) begin ERR_COUNT++; $error("%0tns a=%0d b=%0d cin=%b got=%0d exp=%0d", $time, a, b, cin, {cout,sum}, exp); end
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
