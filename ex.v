module ex(
    input wire[7:0]     aluop_i,
    input wire[31:0]    reg1_i,
    input wire[31:0]    reg2_i,
    input wire[4:0]     wd_i,
    input wire          wreg_i,

    input wire rst,

    output reg[31:0]    wdata_o,
    output reg[4:0]     wd_o,     
    output reg          wreg_o
);
    always @ (*) begin
        if(rst == 1'b1) begin
            wdata_o <= 32'h00000000;
            wd_o    <= 5'b00000;
            wreg_o  <= 1'b0;
        end else begin
            wd_o    <= wd_i;
            wreg_o  <= wreg_i;
            case(aluop_i)
                8'b00100100: begin  //and
                    wdata_o <= reg1_i & reg2_i;
                end
                8'b01011001: begin  //andi
                    wdata_o <= reg2_i & reg1_i;
                end
                8'b00100101: begin  //or
                    wdata_o <= reg1_i | reg2_i;
                end
                8'b00100101: begin  //ori
                    wdata_o     <= reg1_i | reg2_i;
                end
                8'b00100110: begin  //xor
                    wdata_o <= reg1_i ^ reg2_i;
                end
                8'b01011011: begin  //xori
                    wdata_o <= reg2_i ^ reg1_i;
                end
                8'b00100111: begin  //nor
                    wdata_o <= ~(reg1_i | reg2_i);
                end

                //apparently, the next 6 cases shares some same operations
                //in decoder stage, we could integrate them into one
                8'b01111100: begin  //nop, ssnop and sll
                    wdata_o <= reg2_i << reg1_i[4:0];
                end
                8'b00000100: begin   //sllv
                    wdata_o <= reg2_i << reg1_i[4:0];
                end
                8'b00000010: begin  //srl
                    wdata_o <= reg2_i >> reg1_i[4:0];
                end
                8'b00000110: begin  //srlv
                    wdata_o <= reg2_i >> reg1_i[4:0];
                end
                8'b00000011: begin  //sra
                    wdata_o <= ({32{reg2_i[31]}} << (6'd32-{1'b0, reg1_i[4:0]})) 
												| reg2_i >> reg1_i[4:0];
                end                
                8'b00000111: begin  //srav
                    wdata_o <= ({32{reg2_i[31]}} << (6'd32-{1'b0, reg1_i[4:0]})) 
												| reg2_i >> reg1_i[4:0];
                end

                8'b00000000: begin  //sync, pref
                    wd_o    <= 5'b00000;
                    wreg_o  <= 1'b0;
                    wdata_o <= 32'h00000000;
                end
                8'b01011100: begin  //lui
                    wdata_o <= {reg2_i[15:0],reg1_i[15:0]};
                end
                default: begin
                end

            endcase
        end
    end
endmodule
