`timescale 1ns/1ps
module tb;
    localparam TB_SIM_TIMEOUT = 100000;
    logic a, b, y_not, y_and, y_or, y_xor, y_nand, y_nor, y_xnor;
    int ERR_COUNT = 0;
    gates DUT (.a(a), .b(b), .y_not(y_not), .y_and(y_and), .y_or(y_or),
               .y_xor(y_xor), .y_nand(y_nand), .y_nor(y_nor), .y_xnor(y_xnor));
    initial begin
        for (int i = 0; i < 4; i++) begin
            {a, b} = i[1:0]; #5;
            if (y_not  !== ~a)      begin ERR_COUNT++; $error("not");  end
            if (y_and  !== (a&b))   begin ERR_COUNT++; $error("and");  end
            if (y_or   !== (a|b))   begin ERR_COUNT++; $error("or");   end
            if (y_xor  !== (a^b))   begin ERR_COUNT++; $error("xor");  end
            if (y_nand !== ~(a&b))  begin ERR_COUNT++; $error("nand"); end
            if (y_nor  !== ~(a|b))  begin ERR_COUNT++; $error("nor");  end
            if (y_xnor !== ~(a^b))  begin ERR_COUNT++; $error("xnor"); end
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
