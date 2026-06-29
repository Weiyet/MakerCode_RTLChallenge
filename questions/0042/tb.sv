`timescale 1ns / 1ps

module tb;

parameter INPUT_WIDTH = 8;            // overridable via -P (see input_vector.txt)
parameter COUNT_WIDTH = 4;            // overridable via -P (see input_vector.txt)
localparam TB_SIM_TIMEOUT = 30000000;

reg  [INPUT_WIDTH-1:0] data_in;
wire [COUNT_WIDTH-1:0] count_out;

integer ERR_COUNT = 0;

// DUT
population_counter #(
    .INPUT_WIDTH(INPUT_WIDTH),
    .COUNT_WIDTH(COUNT_WIDTH)
) DUT (
    .data_in(data_in),
    .count_out(count_out)
);

// Reference popcount
function [COUNT_WIDTH-1:0] count_ones(input [INPUT_WIDTH-1:0] data);
    integer k;
    begin
        count_ones = 0;
        for (k = 0; k < INPUT_WIDTH; k = k + 1)
            if (data[k]) count_ones = count_ones + 1;
    end
endfunction

// Predefined vectors
reg [INPUT_WIDTH-1:0] tv_data [0:19];
reg [COUNT_WIDTH-1:0] tv_expect;

initial begin
    tv_data[0]  = 98;
    tv_data[1]  = 213; 
    tv_data[2]  = 532; 
    tv_data[3]  = 880; 
    tv_data[4]  = 10;
    tv_data[5]  = 2; 
    tv_data[6]  = 5;
    tv_data[7]  = 888; 
    tv_data[8]  = 255;
    tv_data[9]  = 255;
    tv_data[10] = 1; 
    tv_data[11] = 0;
    tv_data[12] = 99; 
    tv_data[13] = 339;
    tv_data[14] = 199;
    tv_data[15] = 433; 
    tv_data[16] = 34; 
    tv_data[17] = 321; 
    tv_data[18] = 323;
    tv_data[19] = 132; 
end

// Test Sequence
integer i;
initial begin
    $display("Running predefined vector test:");
    for (i = 0; i < 20; i = i + 1) begin
        data_in = tv_data[i];
        #2;
        tv_expect = count_ones(tv_data[i]);
        if (count_out !== tv_expect) begin
            ERR_COUNT = ERR_COUNT + 1;
            $error("FAIL input=%h expected=%0d got=%0d", data_in, tv_expect, count_out);
        end else begin
            $display("PASS input=%h -> %0d", data_in, count_out);
        end
        #8;
    end

    // Exhaustive Test
    $display("Running exhaustive 8-bit test:");
    for (i = 0; i < 256; i = i + 1) begin
        data_in = i;
        #1;
        if (count_out !== count_ones(i)) begin
            ERR_COUNT = ERR_COUNT + 1;
            if (ERR_COUNT < 10)
                $error("FAIL EX input=%h expected=%0d got=%0d",
                         data_in, count_ones(i), count_out);
        end
    end

    check_result;
end

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
