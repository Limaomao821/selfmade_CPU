module id(
    input wire[31:0]        pc_i,
    input wire[31:0]        inst_i,

    input wire[31:0]        reg1_data_i,
    input wire[31:0]        reg2_data_i,

    input rst,

    //to solve data conflict between exe and decode
    input wire[31:0]        ex_wdata_i,
    input wire[4:0]         ex_wd_i,
    input wire              ex_wreg_i,
    //to solve data conflit between mem and decode
    input wire[31:0]        mem_wdata_i,
    input wire[4:0]         mem_wd_i,
    input wire              mem_wreg_i,

    output reg[7:0]         aluop_o,
    //I don't understand why we need alusel_o, so I just don't use it in my code
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
    reg[32:0]   imm         = 32'h00000000;
    
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    //need to refer to verilog syntax book to find out why 
    //the four variables below can't be declared as reg
    wire[5:0]   opcode      = inst_i[31:26];
    wire[4:0]   shamt       = inst_i[10:6];
    wire[5:0]   funct       = inst_i[5:0];   
    wire[25:0]  jump_addr   = inst_i[25:0]; 

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
            imm             <= 32'h00000000;
            
            case(opcode)
                6'b000000: begin
                    case(funct)
                        //the next four cases share some same codes
                        6'b100100: begin    //and 
                           aluop_o      <= 8'b00100100;
                           wreg_o       <= 1'b1;
                           reg2_read_o  <= 1'b1;
                           reg1_read_o  <= 1'b1;
                        end
                        6'b100101: begin    //or
                            aluop_o     <= 8'b00100101;
                            wreg_o      <= 1'b1;
                            reg2_read_o <= 1'b1;
                            reg1_read_o <= 1'b1;
                        end
                        6'b100110: begin    //xor
                            aluop_o     <= 8'b00100110;
                            wreg_o      <= 1'b1;
                            reg2_read_o <= 1'b1;
                            reg1_read_o <= 1'b1;
                        end
                        6'b100111: begin    //nor
                            aluop_o     <= 8'b00100111;
                            wreg_o      <= 1'b1;
                            reg2_read_o <= 1'b1;
                            reg1_read_o <= 1'b1;
                        end

                        //the next three cases share some same codes
                        6'b000000: begin    //sll, nop, ssnop
                            aluop_o     <= 8'b01111100;
                            imm[4:0]    <= shamt;
                            wreg_o      <= 1'b1;
                            reg2_read_o <= 1'b1;
                        end
                        6'b000010: begin    //srl
                            aluop_o     <= 8'b00000010;
                            imm[4:0]    <= shamt;
                            wreg_o      <= 1'b1;
                            reg2_read_o <= 1'b1;
                        end
                        6'b000011: begin    //sra
                            aluop_o     <= 8'b00000011;
                            imm[4:0]    <= shamt;
                            wreg_o      <= 1'b1;
                            reg2_read_o <= 1'b1;

                        //the next three cases share some same code
                        end
                        6'b000100: begin    //sllv
                            aluop_o     <= 8'b01111100;
                            wreg_o      <= 1'b1;
                            reg1_read_o <= 1'b1;
                            reg2_read_o <= 1'b1;
                        end
                        6'b000110: begin    //srlv
                            aluop_o     <= 8'b00000010;
                            wreg_o      <= 1'b1;
                            reg1_read_o <= 1'b1;
                            reg2_read_o <= 1'b1;
                        end
                        6'b000111: begin    //srav
                            aluop_o     <= 8'b00000011;
                            wreg_o      <= 1'b1;
                            reg1_read_o <= 1'b1;
                            reg2_read_o <= 1'b1;
                        end

                        6'b001111: begin    //sync
                            aluop_o     <= 8'b01111100;
                            wreg_o      <= 1'b0;
                            reg1_read_o <= 1'b0;
                            reg2_read_o <= 1'b0;
                        end
                        default: begin
                        end
                    endcase
                end
                //the next four cases shares some same codes
                6'b001100: begin            //andi
                    aluop_o     <= 8'b00100100;
                    wd_o        <= inst_i[20:16];
                    wreg_o      <= 1'b1;
                    imm[15:0]   <= inst_i[15:0];
                    reg1_read_o <= 1'b1;
                    reg2_read_o <= 1'b0;
                end
                6'b001110: begin            //xori
                    aluop_o     <= 8'b00100110;
                    wd_o        <= inst_i[20:16];
                    wreg_o      <= 1'b1;
                    imm[15:0]   <= inst_i[15:0];
                    reg1_read_o <= 1'b1;
                    reg2_read_o <= 1'b0;
                end
                6'b001101: begin            //ori
                    aluop_o     <= 8'b00100101;
                    wreg_o      <= 1'b1;
                    wd_o        <= inst_i[20:16];
                    reg1_read_o <= 1'b1;
                    reg2_read_o <= 1'b0;
                    imm[15:0]   <= inst_i[15:0];
                end
                6'b001111: begin            //lui
                    aluop_o     <= 8'b00100101;
                    wreg_o      <= 1'b1;
                    wd_o        <= inst_i[20:16];
                    reg1_read_o <= 1'b1;
                    reg2_read_o <= 1'b0;
                    imm[31:16]   <= inst_i[15:0];
                end
                6'b110011: begin            //pref
                    aluop_o     <= 8'b01111100;
                    wd_o        <= 5'b00000;
                    wreg_o      <= 1'b0;
                    reg1_read_o <= 1'b0;
                    reg2_read_o <= 1'b0;
                end
                default: begin
                end
            endcase
        end
    end

    always @ (*) begin
        if(rst == 1'b1) begin
            reg1_o  <= 32'h00000000;
        end else if((reg1_read_o == 1'b1) && (reg1_addr_o == ex_wd_i) && (ex_wreg_i == 1'b1)) begin
            reg1_o  <= ex_wdata_i;
        end else if((reg1_read_o == 1'b1) && (reg1_addr_o == mem_wd_i) && (mem_wreg_i == 1'b1)) begin
            reg1_o  <= mem_wdata_i;
        end else if(reg1_read_o == 1'b0) begin
            reg1_o  <= imm;
        end else if(reg1_read_o == 1'b1) begin
            reg1_o  <= reg1_data_i;
        end else begin
            reg1_o  <= 32'h00000000;
        end
    end
    
    always @ (*) begin
        if(rst == 1'b1) begin
            reg2_o  <= 32'h00000000;
        end else if((reg2_read_o == 1'b1) && (reg2_addr_o == ex_wd_i) && (ex_wreg_i == 1'b1)) begin
            reg2_o  <= ex_wdata_i;
        end else if((reg2_read_o == 1'b1) && (reg2_addr_o == mem_wd_i) && (mem_wreg_i == 1'b1)) begin
            reg2_o  <= mem_wdata_i;
        end else if(reg2_read_o == 1'b0) begin
            reg2_o  <= imm;
        end else if(reg2_read_o == 1'b1) begin
            reg2_o  <= reg2_data_i;
        end else begin
            reg2_o  <= 32'h00000000;
        end
    end

endmodule
