module stats (
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic [7:0] mx,
    output logic [8:0] sum,
    output logic [7:0] absdiff
);
    function automatic logic [7:0] get_max(input logic [7:0] x, y);
        get_max = (x > y) ? x : y;
    endfunction

    task automatic sum_absdiff(input logic [7:0] x, y,
                               output logic [8:0] s, output logic [7:0] ad);
        s  = x + y;
        ad = (x > y) ? (x - y) : (y - x);
    endtask

    always_comb begin
        mx = get_max(a, b);
        sum_absdiff(a, b, sum, absdiff);
    end
endmodule
