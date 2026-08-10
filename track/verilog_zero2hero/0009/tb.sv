`timescale 1ns/1ps
module tb #(parameter int W = 8);
    localparam TB_SIM_TIMEOUT = 100000;
    logic [W-1:0] d0, d1, d2, d3, y, exp;
    logic [1:0] sel;
    int ERR_COUNT = 0;

    mux4to1 #(.W(W)) DUT (.d0(d0), .d1(d1), .d2(d2), .d3(d3), .sel(sel), .y(y));

    initial begin
        for (int t = 0; t < 40; t++) begin
            d0 = $random; d1 = $random; d2 = $random; d3 = $random; sel = $random;
            #5;
            case (sel)
                2'd0: exp = d0;
                2'd1: exp = d1;
                2'd2: exp = d2;
                default: exp = d3;
            endcase
            if (y !== exp) begin ERR_COUNT++; $error("%0tns sel=%0d y=%h exp=%h", $time, sel, y, exp); end
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
