module adders (
    input  logic a,
    input  logic b,
    input  logic cin,
    output logic h_sum,
    output logic h_cout,
    output logic sum,
    output logic cout
);
    assign {h_cout, h_sum} = a + b;
    assign {cout,  sum}    = a + b + cin;
endmodule
