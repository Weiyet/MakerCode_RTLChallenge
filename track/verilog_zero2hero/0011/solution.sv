module priority_encoder (
    input  logic [3:0] in,
    output logic [1:0] pos,
    output logic       valid
);
    always_comb begin
        valid = 1'b1;
        casez (in)
            4'b1???: pos = 2'd3;
            4'b01??: pos = 2'd2;
            4'b001?: pos = 2'd1;
            4'b0001: pos = 2'd0;
            default: begin pos = 2'd0; valid = 1'b0; end
        endcase
    end
endmodule
