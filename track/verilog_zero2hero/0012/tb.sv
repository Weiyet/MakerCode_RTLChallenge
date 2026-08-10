`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic [1:0] sel;
    logic [7:0] a, b, c, y, exp;
    int ERR_COUNT = 0;
    sel_mux DUT (.sel(sel), .a(a), .b(b), .c(c), .y(y));
    initial begin
        // First drive sel=0 so a latch (if present) would hold a non-zero value,
        // then hit sel=3 which must produce a defined 0.
        a = 8'hAA; b = 8'hBB; c = 8'hCC;
        for (int s = 0; s < 4; s++) begin
            sel = 2'd0; #5;                 // load y with 'a'
            sel = s[1:0]; #5;
            case (sel) 2'd0: exp=a; 2'd1: exp=b; 2'd2: exp=c; default: exp=8'h00; endcase
            if (y !== exp) begin ERR_COUNT++; $error("sel=%0d y=%h exp=%h (inferred latch?)", sel, y, exp); end
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
