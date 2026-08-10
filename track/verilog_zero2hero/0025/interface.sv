module ram #(
    parameter int AW = 4,
    parameter int DW = 8
)(
    input  logic          clk,
    input  logic          we,
    input  logic [AW-1:0] addr,
    input  logic [DW-1:0] wdata,
    output logic [DW-1:0] rdata
);
    // declare a 2-D array and drive rdata with a registered read

endmodule
