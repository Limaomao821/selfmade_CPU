module id_ex(
    input wire[7:0]     id_aluop,
    input wire[2:0]     id_alusel,
    input wire[31:0]    id_reg1,
    input wire[31:0]    id_reg2,
    input wire[4:0]     id_wd,
    input wire          id_wreg,
    
    input wire          rst,
    input wire          clk,

    output reg[7:0]     ex_aluop,
    output reg[2:0]     ex_alusel,
    output reg[31:0]    ex_reg1,
    output reg[31:0]    ex_reg2,
    output reg[4:0]     ex_wd,
    output reg          ex_wreg
);
    always @ (posedge clk) begin
        if(rst == 1'b1) begin
            ex_aluop    <= 7'b0000000;
            ex_alusel   <= 2'b00;
            ex_reg1     <= 32'h00000000;
            ex_reg2     <= 32'h00000000;
            ex_wd       <= 5'b00000;
            ex_wreg     <= 1'b0;
        end else begin
            ex_aluop    <= id_aluop;
            ex_alusel   <= id_alusel;
            ex_reg1     <= id_reg1;
            ex_reg2     <= id_reg2;
            ex_wd       <= id_wd;
            ex_wreg     <= id_wreg;
        end
    end

endmodule
