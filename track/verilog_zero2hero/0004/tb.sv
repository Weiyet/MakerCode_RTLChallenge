`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic [7:0] in;
    logic all_ones, any_one, parity;
    int ERR_COUNT = 0;

    reduction_ops DUT (.in(in), .all_ones(all_ones), .any_one(any_one), .parity(parity));

    initial begin
        for (int i = 0; i < 30; i++) begin
            in = $random;
            #5;
            if (all_ones !== (&in)) begin ERR_COUNT++; $error("%0tns all_ones in=%b got=%b", $time, in, all_ones); end
            if (any_one  !== (|in)) begin ERR_COUNT++; $error("%0tns any_one in=%b got=%b",  $time, in, any_one);  end
            if (parity   !== (^in)) begin ERR_COUNT++; $error("%0tns parity in=%b got=%b",   $time, in, parity);   end
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
