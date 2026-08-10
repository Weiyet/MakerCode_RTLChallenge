module tristate_buf (
    input  logic       oe,
    input  logic [7:0] din,
    output logic [7:0] dout
);
    assign dout = oe ? din : 8'bz;
endmodule
