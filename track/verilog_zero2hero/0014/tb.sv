`timescale 1ns/1ps
module tb #(parameter int W = 8);
    localparam TB_SIM_TIMEOUT = 100000;
    logic [W-1:0] a, b, y, exp;
    logic [2:0] op;
    logic zero;
    int ERR_COUNT = 0;

    alu #(.W(W)) DUT (.a(a), .b(b), .op(op), .y(y), .zero(zero));

    initial begin
        for (int t = 0; t < 200; t++) begin
            a = $random; b = $random; op = $random;
            #5;
            case (op)
                3'd0: exp = a + b;
                3'd1: exp = a - b;
                3'd2: exp = a & b;
                3'd3: exp = a | b;
                3'd4: exp = a ^ b;
                3'd5: exp = a << b[2:0];
                3'd6: exp = a >> b[2:0];
                default: exp = (a < b) ? 1 : 0;
            endcase
            if (y !== exp) begin ERR_COUNT++; $error("%0tns op=%0d a=%h b=%h y=%h exp=%h", $time, op, a, b, y, exp); end
            if (zero !== (exp == 0)) begin ERR_COUNT++; $error("%0tns zero flag wrong op=%0d y=%h", $time, op, y); end
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
