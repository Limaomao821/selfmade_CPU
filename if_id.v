module if_id(
    input wire[31:0]    if_pc,
    input wire[31:0]    if_inst,
    input wire[5:0]     stall,

    input wire          rst,
    input wire          clk,

    output reg[31:0] id_pc,
    output reg[31:0] id_inst
);
    always @ (posedge clk) begin
        if(rst == 1'b1) begin
            id_pc <= 32'h00000000;
            id_inst <= 32'h00000000;
        end else if(stall[1] == `Stop && stall[2] == `NoStop) begin
            id_pc <= `ZeroWord;
            id_inst <= `ZeroWord;
        end else if(stall[1] == 'NoStop) begin
            id_pc   <= if_pc;
            id_inst <= if_inst;
    end
endmodule
