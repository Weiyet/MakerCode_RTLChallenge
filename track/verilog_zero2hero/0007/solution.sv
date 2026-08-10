module concat_replicate (
    input  logic [7:0]  a,
    input  logic [7:0]  b,
    output logic [15:0] cat,
    output logic [31:0] rep4,
    output logic [7:0]  nib_swap
);
    assign cat      = {a, b};
    assign rep4     = {4{a}};
    assign nib_swap = {a[3:0], a[7:4]};
endmodule
