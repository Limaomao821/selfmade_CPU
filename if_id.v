module if_id(
    input wire[31:0] if_pc,
    input wire[31:0] if_inst,

    input wire       rst,
    input wire       clk,

    output reg[31:0] id_pc,
    output reg[31:0] id_inst
);
    always @ (posedge clk) begin
        if(rst == 1'b1) begin
            id_pc <= 32'h00000000;
            id_inst <= 32'h00000000;
        end else begin
            id_pc <= if_pc;
            id_inst <= if_inst;
        end
    end
endmodule
