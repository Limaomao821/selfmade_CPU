module ex(
    input wire[7:0]     aluop_i,
    input wire[2:0]     alusel_i,
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
        end else if(mem_whilo_O == 1'b1) begin
            HI  <= mem_hi_i;
            LO  <= mem_lo_i;
        end else if(wb_whilo_o == 1'b1) begin
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