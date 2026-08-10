`timescale 1ns/1ps
module tb #(parameter int W = 4);
    localparam TB_SIM_TIMEOUT = 100000;
    logic [W-1:0] bin, gray_in, gray, bin_out;
    logic [W-1:0] exp_gray, exp_bin;
    int ERR_COUNT = 0;

    gray_codec #(.W(W)) DUT (.bin(bin), .gray_in(gray_in), .gray(gray), .bin_out(bin_out));

    initial begin
        for (int v = 0; v < (1 << W); v++) begin
            bin = v[W-1:0];
            gray_in = v[W-1:0] ^ (v[W-1:0] >> 1);   // a valid gray code
            #5;
            exp_gray = bin ^ (bin >> 1);
            exp_bin  = 0;
            for (int i = 0; i < W; i++) exp_bin ^= (gray_in >> i);   // gray->bin = xor prefix
            if (gray    !== exp_gray) begin ERR_COUNT++; $error("%0tns bin=%b gray=%b exp=%b", $time, bin, gray, exp_gray); end
            if (bin_out !== exp_bin)  begin ERR_COUNT++; $error("%0tns gray_in=%b bin_out=%b exp=%b", $time, gray_in, bin_out, exp_bin); end
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
