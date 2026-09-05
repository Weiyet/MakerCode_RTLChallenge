`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic a, b, sel, y;
    logic exp;
    int ERR_COUNT = 0;

    mux2to1 DUT (.a(a), .b(b), .sel(sel), .y(y));

    initial begin
        for (int i = 0; i < 8; i++) begin
            {a, b, sel} = i[2:0];
            #5;
            exp = sel ? b : a;
            if (y !== exp) begin
                ERR_COUNT++;
                $error("%0tns a=%b b=%b sel=%b y=%b expected=%b", $time, a, b, sel, y, exp);
            end else $display("%0tns a=%b b=%b sel=%b y=%b", $time, a, b, sel, y);
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
