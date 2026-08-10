module parallel_join (
    input  logic       start,
    output logic [2:0] flag,
    output logic       done
);
    initial begin
        flag = 3'b000;
        done = 1'b0;
        @(posedge start);
        fork
            begin #10 flag[0] = 1'b1; end
            begin #20 flag[1] = 1'b1; end
            begin #30 flag[2] = 1'b1; end
        join
        done = 1'b1;
    end
endmodule
