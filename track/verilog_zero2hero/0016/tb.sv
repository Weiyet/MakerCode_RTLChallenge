`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic [3:0] bcd;
    logic [6:0] seg, exp;
    int ERR_COUNT = 0;

    bcd_to_7seg DUT (.bcd(bcd), .seg(seg));

    function automatic logic [6:0] golden(input logic [3:0] d);
        case (d)
            4'd0: golden = 7'h3F; 4'd1: golden = 7'h06; 4'd2: golden = 7'h5B;
            4'd3: golden = 7'h4F; 4'd4: golden = 7'h66; 4'd5: golden = 7'h6D;
            4'd6: golden = 7'h7D; 4'd7: golden = 7'h07; 4'd8: golden = 7'h7F;
            4'd9: golden = 7'h6F; default: golden = 7'h00;
        endcase
    endfunction

    initial begin
        for (int i = 0; i < 16; i++) begin
            bcd = i[3:0];
            #5;
            exp = golden(bcd);
            if (seg !== exp) begin ERR_COUNT++; $error("%0tns bcd=%0d seg=%h exp=%h", $time, bcd, seg, exp); end
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
