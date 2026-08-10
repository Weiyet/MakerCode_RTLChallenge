`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic [7:0]  a, b;
    logic [15:0] cat;
    logic [31:0] rep4;
    logic [7:0]  nib_swap;
    int ERR_COUNT = 0;

    concat_replicate DUT (.a(a), .b(b), .cat(cat), .rep4(rep4), .nib_swap(nib_swap));

    initial begin
        for (int i = 0; i < 20; i++) begin
            a = $random; b = $random;
            #5;
            if (cat      !== {a, b})             begin ERR_COUNT++; $error("%0tns cat=%h",  $time, cat);  end
            if (rep4     !== {4{a}})             begin ERR_COUNT++; $error("%0tns rep4=%h", $time, rep4); end
            if (nib_swap !== {a[3:0], a[7:4]})   begin ERR_COUNT++; $error("%0tns nib_swap=%h", $time, nib_swap); end
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
