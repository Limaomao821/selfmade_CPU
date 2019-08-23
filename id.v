module id(
    input wire[31:0]        pc_i,
    input wire[31:0]        inst_i,

    input wire[31:0]        reg1_data_i,
    input wire[31:0]        reg2_data_i,

    input rst,

    output reg[7:0]         aluop_o,
    //output reg[2:0]         alusel_o,
    output reg[31:0]        reg1_o,
    output reg[31:0]        reg2_o,
    output reg              wreg_o,
    output reg[4:0]         wd_o,

    output reg[4:0]         reg2_addr_o,
    output reg              reg2_read_o,
    output reg[4:0]         reg1_addr_o,
    output reg              reg1_read_o
);
    wire[5:0] opcode = inst_i[31:26];
    reg[32:0]  imm; 

    always @ (*) begin
        if(rst == 1'b1) begin
            aluop_o         <= 8'b00000000;
            reg1_o          <= 32'h00000000;
            reg2_o          <= 32'h00000000;

            wreg_o          <= 1'b0;
            wd_o            <= 5'b00000;
            reg2_read_o     <= 1'b0;
            reg2_addr_o     <= 5'b00000;
            reg1_read_o     <= 1'b0;
            reg1_addr_o     <= 5'b00000;
        end else begin
            wreg_o          <= 1'b0;
            wd_o            <= inst_i[15:11];
            reg1_read_o     <= 1'b0;
            reg1_addr_o     <= inst_i[25:21];
            reg2_read_o     <= 1'b0;
            reg2_addr_o     <= inst_i[20:16];
            
            case(opcode)
                6'b001101: begin
                   aluop_o      <= 8'b00100101;
                   wreg_o       <= 1'b1;
                   wd_o         <= inst_i[20:16];
                   reg1_read_o  <= 1'b1;
                   reg2_read_o  <= 1'b0;
                   imm          <= {16'h0000, inst_i[15:0]};
                end
                default: begin
                end
            endcase
        end
    end

    always @ (*) begin
        if(rst == 1'b1) begin
            reg1_o  <= 32'h00000000;
        end else if(reg1_read_o == 1'b1) begin
            reg1_o  <= reg1_data_i;
        end else begin
            reg1_o  <= 32'h00000000;
        end
    end
    
    always @ (*) begin
        if(rst == 1'b1) begin
            reg2_o  <= 32'h00000000;
        end else if(reg2_read_o == 1'b0) begin
            reg2_o  <= imm;
        end else if(reg2_read_o == 1'b1) begin
            reg2_o  <= reg2_data_i;
        end else begin
            reg2_o  <= 32'h00000000;
        end
    end

endmodule
