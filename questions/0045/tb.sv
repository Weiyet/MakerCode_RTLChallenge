`timescale 1ns / 1ps

module tb;

    //---------------------------------------------------------
    // Parameters
    //---------------------------------------------------------
    parameter WIDTH = 32;                 // overridable via -P tb.WIDTH (see input_vector.txt)
    localparam NUM_VECTORS = 32;          // Number of test vectors
    localparam TB_SIM_TIMEOUT = 30_000_000; // ns

    //---------------------------------------------------------
    // DUT Signals
    //---------------------------------------------------------
    reg  [WIDTH-1:0] a_in;
    reg  [WIDTH-1:0] b_in;
    reg  c_in;
    wire [WIDTH-1:0] sum_out;
    wire c_out;

    integer ERR_COUNT = 0;

    //---------------------------------------------------------
    // DUT Instantiation
    //---------------------------------------------------------
    carry_lookahead_adder #(
        .WIDTH(WIDTH)
    ) DUT (
        .a_in(a_in),
        .b_in(b_in),
        .c_in(c_in),
        .sum_out(sum_out),
        .c_out(c_out)
    );

    //---------------------------------------------------------
    // Reference ripple-carry adder
    //---------------------------------------------------------
    function automatic [WIDTH:0] ripple_add(input [WIDTH-1:0] a, input [WIDTH-1:0] b, input cin);
        logic [WIDTH:0] result;
        logic carry;
        begin
            carry = cin;
            for (int i=0; i<WIDTH; i++) begin
                result[i] = a[i] ^ b[i] ^ carry;
                carry = (a[i] & b[i]) | (a[i] & carry) | (b[i] & carry);
            end
            result[WIDTH] = carry;
            ripple_add = result;
        end
    endfunction

    //---------------------------------------------------------
    // Test vectors as integers
    //---------------------------------------------------------
    integer a_vector [0:NUM_VECTORS-1];
    integer b_vector [0:NUM_VECTORS-1];
    integer c_vector [0:NUM_VECTORS-1];

    //---------------------------------------------------------
    // Initialize test vectors
    //---------------------------------------------------------
    initial begin
        a_vector[0]  = 0;          b_vector[0]  = 0;          c_vector[0]  = 0;
        a_vector[1]  = 1;          b_vector[1]  = 1;          c_vector[1]  = 0;
        a_vector[2]  = 65535;      b_vector[2]  = 1;          c_vector[2]  = 0;
        a_vector[3]  = 4294967295; b_vector[3]  = 1;          c_vector[3]  = 0;
        a_vector[4]  = 305419896;  b_vector[4]  = 2271560481;  c_vector[4]  = 0;
        a_vector[5]  = 1431655766; b_vector[5]  = 1431655765;  c_vector[5]  = 1;
        a_vector[6]  = 2147483648; b_vector[6]  = 2147483648;  c_vector[6]  = 0;
        a_vector[7]  = 2147483647; b_vector[7]  = 1;          c_vector[7]  = 1;
        a_vector[8]  = 3735928559; b_vector[8]  = 3405691582;  c_vector[8]  = 0;
        a_vector[9]  = 252645135;  b_vector[9]  = 4042322160;  c_vector[9]  = 1;

        // Fill remaining vectors with random integers
        for (int i = 10; i < NUM_VECTORS; i = i + 1) begin
            a_vector[i] = $urandom;
            b_vector[i] = $urandom;
            c_vector[i] = $urandom % 2;
        end
    end

    //---------------------------------------------------------
    // Test sequence
    //---------------------------------------------------------
    initial begin
        $display("=== Testing predefined vectors ===");
        for (int i=0; i<NUM_VECTORS; i++) begin
            a_in = a_vector[i][WIDTH-1:0];  // automatically drop extra bits if WIDTH < 32
            b_in = b_vector[i][WIDTH-1:0];
            c_in = c_vector[i];
            #2;
            test_addition(i);
        end

        $display("=== Running exhaustive test for lower WIDTH if small ===");
        if (WIDTH <= 8) test_exhaustive(); // avoid huge loops for large WIDTH

        check_result();
    end

    //---------------------------------------------------------
    // Task: apply single test vector by index
    //---------------------------------------------------------
    task test_addition(input int idx);
        logic [WIDTH:0] expected;
        begin
            expected = ripple_add(a_in, b_in, c_in);

            if (sum_out !== expected[WIDTH-1:0]) begin
                ERR_COUNT++;
                $error("Vector %0d: A=%0d B=%0d Cin=%0b => Expected Sum=%0d Got Sum=%0d",
                       idx, a_in, b_in, c_in, expected[WIDTH-1:0], sum_out);
            end

            if (c_out !== expected[WIDTH]) begin
                ERR_COUNT++;
                $error("Vector %0d: A=%0d B=%0d Cin=%0b => Expected Cout=%0b Got Cout=%0b",
                       idx, a_in, b_in, c_in, expected[WIDTH], c_out);
            end
        end
    endtask

    //---------------------------------------------------------
    // Task: exhaustive test (for small WIDTH)
    //---------------------------------------------------------
    task test_exhaustive();
        logic [WIDTH:0] expected;
        begin
            for (int a=0; a<(1<<WIDTH); a++) begin
                for (int b=0; b<(1<<WIDTH); b++) begin
                    for (int cin=0; cin<=1; cin++) begin
                        a_in = a; b_in = b; c_in = cin;
                        #1;
                        expected = ripple_add(a,b,cin);
                        if (sum_out !== expected[WIDTH-1:0] || c_out !== expected[WIDTH]) begin
                            ERR_COUNT++;
                            if (ERR_COUNT <= 10)
                                $error("Exhaustive test failed: A=%0d B=%0d Cin=%0b => Sum=%0d Cout=%0b",
                                       a,b,cin,sum_out,c_out);
                        end
                    end
                end
            end
        end
    endtask

    //---------------------------------------------------------
    // Check result
    //---------------------------------------------------------
    //do not edit below
task check_result;
begin
   if(ERR_COUNT > 0) begin
      $display("Test failed with %0d errors.", ERR_COUNT);
   end else begin
      $display("Test PASS");
   end
   $finish;
end
endtask

string filename;

initial begin
   if ($value$plusargs("VCDFILE=%s",filename)) begin
      $dumpfile(filename);
      $dumpvars(0, DUT);
   end
end

initial begin
    #(TB_SIM_TIMEOUT)
    $display("Simulation TIMEOUT");
    $finish;
end

endmodule
