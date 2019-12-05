module ex(
    input wire[7:0]     aluop_i,
    input wire[2:0]     alusel_i,
    input wire[31:0]    reg1_i,
    input wire[31:0]    reg2_i,
    input wire[4:0]     wd_i,
    input wire          wreg_i,
    input wire[31:0]    hi_i,
    input wire[31:0]    lo_i,
    
    input wire          wb_whilo_i,
    input wire[31:0]    wb_hi_i,
    input wire[31:0]    wb_lo_i,
    
    input wire          mem_whilo_i,
    input wire[31:0]    mem_hi_i,
    input wire[31:0]    mem_lo_i,

    input wire rst,
    
    output reg          wreg_o,
    output reg[31:0]    wdata_o,
    output reg[4:0]     wd_o,     

    output reg          whilo_o,
    output reg[31:0]    hi_o,
    output reg[31:0]    lo_o
);
    reg[31:0]   logicout;
    reg[31:0]   shiftres;
    reg[31:0]   moveres;
    reg[31:0]   arithmaticres;
    reg[31:0]   HI;
    reg[31:0]   LO;

    always @ (*) begin
        case(aluop_i)
            8'b00100100: begin  //and,  addi
                logicout <= reg1_i & reg2_i;
            end
            8'b00100101: begin  //or,   ori,   lui
                logicout <= reg1_i | reg2_i;
            end
            8'b00100110: begin  //xor,  xori
                logicout <= reg1_i ^ reg2_i;
            end
            8'b00100111: begin  //nor
                logicout <= ~(reg1_i | reg2_i);
            end
            default: begin
            end
        endcase
    end

    always @ (*) begin
        case(aluop_i)
            8'b01111100: begin  //sll, sllv, nop, ssnop, sync,  pref
                shiftres <= reg2_i << reg1_i[4:0];
            end
            8'b00000010: begin  //srl
                shiftres <= reg2_i >> reg1_i[4:0];
            end
            8'b00000011: begin  //sra
                shiftres <= ({32{reg2_i[31]}} << (6'd32-{1'b0, reg1_i[4:0]})) 
                                            | reg2_i >> reg1_i[4:0];
            end
        endcase
    end

    //  make sure HI, LO get newest value
    always @(*) begin
        if(rst == 1'b1) begin
            HI  <= 32'h00000000;
            LO  <= 32'h00000000;
        end else if(mem_whilo_i == 1'b1) begin
            HI  <= mem_hi_i;
            LO  <= mem_lo_i;
        end else if(wb_whilo_i == 1'b1) begin
            HI  <= wb_hi_i;
            LO  <= wb_lo_i;
        end else begin
            HI  <= hi_i;
            LO  <= lo_i;
        end
    end
    always @(*) begin
        case(aluop_i)
        8'b00001011: begin      //movn
            moveres <= reg1_i;
        end
        8'b00001011: begin      //movz
            moveres <= reg1_i;
        end
        8'b00010000: begin      //mfhi
            moveres <= HI;
        end
        8'b00010010: begin      //mflo
            moveres <= LO;
        end
        default: begin
        end
        endcase
    end


    always @(*) begin
        if(rst == 1'b1) begin
            whilo_o <= 1'b0;
            hi_o    <= 32'h00000000;
            lo_o    <= 32'h00000000;
        end else begin
            case(aluop_i)
            8'b00010001: begin  //mthi
                whilo_o <= 1'b1;
                hi_o    <= reg1_i;
                lo_o    <= LO;
            end 
            8'b00010011: begin  //mtlo
                whilo_o <= 1'b1;
                lo_o    <= reg1_i;
                hi_o    <= HI;
            end
            default: begin
                whilo_o <= 1'b0;
                hi_o    <= 32'h00000000;
                lo_o    <= 32'h00000000;
            end
            endcase
        end
    end

    // for arithmatic calculation
    wire ov_sum;
    wire[31:0]  reg2_i_mux;
    wire[31:0]  result_sum;
    wire        reg1_lt_reg2;
    wire[31:0]  reg1_i_not;

    assign reg2_i_mux = (aluop_i==8'b00100010||
                         aluop_i==8'b00100011||
                         aluop_i==8'b00101010)?
                        (~reg2_i+1):reg2_i;

    assign result_sum = reg1_i + reg2_i_mux;

    assign ov_sum = ((!reg1_i[31]&&!reg2_i[31]&&result_sum[31])||
                    (reg1_i[31]&&reg2_i[31]&&!result_sum[31]));

    assign reg1_lt_reg2 =   (aluop_i==8'b00101010)?
                            (reg1_i[31]&&!reg2_i[31])||
                            (!reg1_i[31]&&!reg2_i[31]&&result_sum[31])||
                            (reg1_i[31]&&reg2_i[31]&&result_sum[31]):
                            (reg1_i<reg2_i);
    
    assign reg1_i_not   = ~reg1_i;
    
    always @(*) begin
        case(aluop_i)
            8'b00100000, 8'b01010101, 8'b00100001, 8'b01010110: begin  //add, addi, addu, addiu
                arithmaticres <=    result_sum;
            end
            8'b00100010, 8'b00100011: begin
                arithmaticres <=    result_sum;
            end
            8'b00101010, 8'b00101011: begin
                arithmaticres <=    reg1_lt_reg2;
            end
            8'b10110000: begin
                arithmeticres <=    reg1_i[31] ? 0 : reg1_i[30] ? 1 : reg1_i[29] ? 2 :
                                    reg1_i[28] ? 3 : reg1_i[27] ? 4 : reg1_i[26] ? 5 :
                                    reg1_i[25] ? 6 : reg1_i[24] ? 7 : reg1_i[23] ? 8 : 
                                    reg1_i[22] ? 9 : reg1_i[21] ? 10 : reg1_i[20] ? 11 :
                                    reg1_i[19] ? 12 : reg1_i[18] ? 13 : reg1_i[17] ? 14 : 
                                    reg1_i[16] ? 15 : reg1_i[15] ? 16 : reg1_i[14] ? 17 : 
                                    reg1_i[13] ? 18 : reg1_i[12] ? 19 : reg1_i[11] ? 20 :
                                    reg1_i[10] ? 21 : reg1_i[9] ? 22 : reg1_i[8] ? 23 : 
                                    reg1_i[7] ? 24 : reg1_i[6] ? 25 : reg1_i[5] ? 26 : 
                                    reg1_i[4] ? 27 : reg1_i[3] ? 28 : reg1_i[2] ? 29 : 
                                    reg1_i[1] ? 30 : reg1_i[0] ? 31 : 32 ;
            end
            8'b10110001: begin
                arithmeticres <=    (reg1_i_not[31] ? 0 : reg1_i_not[30] ? 1 : reg1_i_not[29] ? 2 :
                                    reg1_i_not[28] ? 3 : reg1_i_not[27] ? 4 : reg1_i_not[26] ? 5 :
                                    reg1_i_not[25] ? 6 : reg1_i_not[24] ? 7 : reg1_i_not[23] ? 8 : 
                                    reg1_i_not[22] ? 9 : reg1_i_not[21] ? 10 : reg1_i_not[20] ? 11 :
                                    reg1_i_not[19] ? 12 : reg1_i_not[18] ? 13 : reg1_i_not[17] ? 14 : 
                                    reg1_i_not[16] ? 15 : reg1_i_not[15] ? 16 : reg1_i_not[14] ? 17 : 
                                    reg1_i_not[13] ? 18 : reg1_i_not[12] ? 19 : reg1_i_not[11] ? 20 :
                                    reg1_i_not[10] ? 21 : reg1_i_not[9] ? 22 : reg1_i_not[8] ? 23 : 
                                    reg1_i_not[7] ? 24 : reg1_i_not[6] ? 25 : reg1_i_not[5] ? 26 : 
                                    reg1_i_not[4] ? 27 : reg1_i_not[3] ? 28 : reg1_i_not[2] ? 29 : 
                                    reg1_i_not[1] ? 30 : reg1_i_not[0] ? 31 : 32) ;
            end
            default: begin
               arithmaticres <=     32'h00000000; 
            end
        endcase
    end

    always @(*) begin
        if(rst == 1'b1) begin
            wreg_o  <= 1'b0;
            wdata_o <= 32'h00000000;
            wd_o    <= 5'b00000;
        end else begin
            wreg_o  <= wreg_i;
            wd_o    <= wd_i;
            case(alusel_i)
            3'b001: begin
                wdata_o <= logicout;
            end
            3'b010: begin
                wdata_o <= shiftres;
            end
            3'b011: begin
                wdata_o <= moveres;
            end
            default: begin
                wdata_o <= 32'h00000000;
            end
            endcase
        end
    end
endmodule