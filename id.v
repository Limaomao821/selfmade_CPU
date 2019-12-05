module id(
    input wire[31:0]        pc_i,
    input wire[31:0]        inst_i,

    input wire[31:0]        reg1_data_i,
    input wire[31:0]        reg2_data_i,

    input rst,

    // to solve data conflict between exe and decode
    input wire[31:0]        ex_wdata_i,
    input wire[4:0]         ex_wd_i,
    input wire              ex_wreg_i,
    // to solve data conflit between mem and decode
    input wire[31:0]        mem_wdata_i,
    input wire[4:0]         mem_wd_i,
    input wire              mem_wreg_i,

    output reg[7:0]         aluop_o,
    // I don't understand why we need alusel_o, so I just don't use it in my code
    // now I understand why alusel_o is needed
    // alusel_o is used to choose result from different kinds of calculation
    // because we need to use case to simulate real mux with no more than four inputs
    output reg[2:0]         alusel_o,

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
    // need to refer to verilog syntax book to find out why 
    // the four variables below can't be declared as reg
    wire[5:0]   opcode      = inst_i[31:26];
    wire[4:0]   shamt       = inst_i[10:6];
    wire[5:0]   funct       = inst_i[5:0];   
    wire[25:0]  jump_addr   = inst_i[25:0]; 

    always @ (*) begin
        if(rst == 1'b1) begin
            aluop_o         <= 8'b00000000;
            alusel_o        <= 3'b000;
            reg1_o          <= 32'h00000000;
            reg2_o          <= 32'h00000000;
            wreg_o          <= 1'b0;
            wd_o            <= 5'b00000;

            reg2_read_o     <= 1'b0;
            reg2_addr_o     <= 5'b00000;
            reg1_read_o     <= 1'b0;
            reg1_addr_o     <= 5'b00000;
        end else begin
            alusel_o        <= 3'b000;
            wreg_o          <= 1'b0;
            wd_o            <= inst_i[15:11];
            reg1_read_o     <= 1'b0;
            reg1_addr_o     <= inst_i[25:21];
            reg2_read_o     <= 1'b0;
            reg2_addr_o     <= inst_i[20:16];
            imm             <= 32'h00000000;
            
            case(opcode)
                6'b000000: begin    //special
                    case(funct)
                        //the next four cases share some same codes
                        6'b100100: begin    //and 
                           aluop_o      <= 8'b00100100;
                           wreg_o       <= 1'b1;
                           reg2_read_o  <= 1'b1;
                           reg1_read_o  <= 1'b1;
                           alusel_o     <= `EXE_RES_LOGIC;
                        end
                        6'b100101: begin    //or
                            aluop_o     <= 8'b00100101;
                            wreg_o      <= 1'b1;
                            reg2_read_o <= 1'b1;
                            reg1_read_o <= 1'b1;
                            alusel_o     <= `EXE_RES_LOGIC;
                        end
                        6'b100110: begin    //xor
                            aluop_o     <= 8'b00100110;
                            wreg_o      <= 1'b1;
                            reg2_read_o <= 1'b1;
                            reg1_read_o <= 1'b1;
                            alusel_o     <= `EXE_RES_LOGIC;
                        end
                        6'b100111: begin    //nor
                            aluop_o     <= 8'b00100111;
                            wreg_o      <= 1'b1;
                            reg2_read_o <= 1'b1;
                            reg1_read_o <= 1'b1;
                            alusel_o     <= `EXE_RES_LOGIC;
                        end

                        6'b000000: begin    //sll, nop, ssnop
                            aluop_o     <= 8'b01111100;
                            alusel_o     <= `EXE_RES_SHIFT;
                            imm[4:0]    <= shamt;
                            wreg_o      <= 1'b1;
                            reg2_read_o <= 1'b1;
                        end
                        6'b000010: begin    //srl
                            aluop_o     <= 8'b00000010;
                            alusel_o    <= `EXE_RES_SHIFT;
                            imm[4:0]    <= shamt;
                            wreg_o      <= 1'b1;
                            reg2_read_o <= 1'b1;
                        end
                        6'b000011: begin    //sra
                            aluop_o     <= 8'b00000011;
                            alusel_o    <= `EXE_RES_SHIFT;
                            imm[4:0]    <= shamt;
                            wreg_o      <= 1'b1;
                            reg2_read_o <= 1'b1;
                        end

                        6'b000100: begin    //sllv
                            aluop_o     <= 8'b01111100;
                            alusel_o    <= `EXE_RES_SHIFT;
                            wreg_o      <= 1'b1;
                            reg1_read_o <= 1'b1;
                            reg2_read_o <= 1'b1;
                        end
                        6'b000110: begin    //srlv
                            aluop_o     <= 8'b00000010;
                            alusel_o    <= `EXE_RES_SHIFT;
                            wreg_o      <= 1'b1;
                            reg1_read_o <= 1'b1;
                            reg2_read_o <= 1'b1;    
                        end
                        6'b000111: begin    //srav
                            aluop_o     <= 8'b00000011;
                            alusel_o    <= `EXE_RES_SHIFT;
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

                        //move calculation
                        6'b001011: begin    //movn
                            aluop_o     <= 8'b00001011;
                            alusel_o    <= `EXE_RES_MOVE;
                            if(reg2_o != 32'h00000000) begin
                                wreg_o      <= 1'b1; 
                            end else begin
                                wreg_o      <= 1'b0;
                            end
                            reg1_read_o <= 1'b1;
                            reg2_read_o <= 1'b1;
                        end
                        6'b001010:begin     //movz
                            aluop_o     <= 8'b00001011;
                            alusel_o    <= `EXE_RES_MOVE;
                            if(reg2_o == 32'h00000000) begin
                                wreg_o      <= 1'b1; 
                            end else begin
                                wreg_o      <= 1'b0;
                            end
                            reg1_read_o <= 1'b1;
                            reg2_read_o <= 1'b1;                         
                        end 
                        6'b010000: begin    //mfhi
                            aluop_o     <= 8'b00010000;
                            alusel_o    <= `EXE_RES_MOVE;
                            wreg_o      <= 1'b1;
                        end
                        6'b010010: begin    //mflo
                            aluop_o     <= 8'b00010010;
                            alusel_o    <= `EXE_RES_MOVE;
                            wreg_o      <= 1'b1;
                        end
                        6'b010001: begin    //mthi
                            aluop_o     <= 8'b00010001;
                            reg1_read_o <= 1'b1;                            
                        end
                        6'b010011: begin    //mtlo
                            aluop_o     <= 8'b00010011;
                            reg1_read_o <= 1'b1;
                        end
                        
                        // arithmatic calculation
                        6'b100000: begin    //add
                            aluop_o     <= 8'b00100000;
                            alusel_o    <= `EXE_RES_ARITHMETIC;
                            reg1_read_o      <= 1'b1;
                            reg2_read_o      <= 1'b1;
                            wreg_o      <= 1'b1;
                        end
                        6'b100001: begin    //addu
                            aluop_o     <= 8'b00100001;
                            alusel_o    <= `EXE_RES_ARITHMETIC;
                            reg1_read_o      <= 1'b1;
                            reg2_read_o      <= 1'b1;
                            wreg_o      <= 1'b1;
                        end
                        6'b100010: begin    //sub
                            aluop_o     <= 8'b00100010;
                            alusel_o    <= `EXE_RES_ARITHMETIC;
                            reg1_read_o      <= 1'b1;
                            reg2_read_o      <= 1'b1;
                            wreg_o      <= 1'b1;
                        end
                        6'b100011: begin    //subu                            
                            aluop_o     <= 8'b00100011;
                            alusel_o    <= `EXE_RES_ARITHMETIC;
                            reg1_read_o      <= 1'b1;
                            reg2_read_o      <= 1'b1;
                            wreg_o      <= 1'b1;
                        end
                        6'b101010: begin    //slt
                            aluop_o     <= 8'b00101010;
                            alusel_o    <= `EXE_RES_ARITHMETIC;
                            reg1_read_o      <= 1'b1;
                            reg2_read_o      <= 1'b1;
                            wreg_o      <= 1'b1;
                        end
                        6'b101011: begin    //sltu
                            aluop_o     <= 8'b00101011;
                            alusel_o    <= `EXE_RES_ARITHMETIC;
                            reg1_read_o      <= 1'b1;
                            reg2_read_o      <= 1'b1;
                            wreg_o      <= 1'b1;
                        end

                        6’b011000: begin    //mult
                            aluop_o     <= 8'b00011000;
                            // may not need aluse_o
                            // of course do not need alusel_o
                            // alusel_o is for select data for wdata_t
                            // but multu and mult use hi_o and lo_o
                            // may not need aluse_o
                            // alusel_o    <= `EXE_RES_ARITHMETIC;
                            reg1_read_o <= 1'b1;
                            reg2_read_o <= 1'b1;
                        end
                        6'b011001: begin    //multu
                            aluop_o     <= 8'b00011001;
                            // may not need aluse_o
                            // of course do not need alusel_o
                            // alusel_o is for select data for wdata_t
                            // but multu and mult use hi_o and lo_o
                            // alusel_o    <= `EXE_RES_ARITHMETIC;
                            reg1_read_o <= 1'b1;
                            reg2_read_o <= 1'b1;
                        end
                        default: begin
                        end
                    endcase
                end

                6'b001100: begin    //andi
                    aluop_o     <= 8'b00100100;
                    alusel_o    <= `EXE_RES_LOGIC;
                    wd_o        <= inst_i[20:16];
                    wreg_o      <= 1'b1;
                    reg1_read_o <= 1'b1;
                    reg2_read_o <= 1'b0;
                    imm[15:0]   <= inst_i[15:0];
                end
                6'b001110: begin    //xori
                    aluop_o     <= 8'b00100110;
                    alusel_o    <= `EXE_RES_LOGIC;
                    wd_o        <= inst_i[20:16];
                    wreg_o      <= 1'b1;
                    reg1_read_o <= 1'b1;
                    reg2_read_o <= 1'b0;
                    imm[15:0]   <= inst_i[15:0];
                end
                6'b001101: begin    //ori
                    aluop_o     <= 8'b00100101;
                    alusel_o    <= `EXE_RES_LOGIC;
                    wreg_o      <= 1'b1;
                    wd_o        <= inst_i[20:16];
                    reg1_read_o <= 1'b1;
                    reg2_read_o <= 1'b0;
                    imm[15:0]   <= inst_i[15:0];
                end
                6'b001111: begin    //lui
                    aluop_o     <= 8'b00100101;
                    alusel_o    <= `EXE_RES_LOGIC;
                    wreg_o      <= 1'b1;
                    wd_o        <= inst_i[20:16];
                    reg1_read_o <= 1'b1;
                    reg2_read_o <= 1'b0;
                    imm[31:16]  <= inst_i[15:0];
                end
                6'b110011: begin    //pref, now considered as nop
                    aluop_o     <= 8'b01111100;
                    alusel_o    <= `EXE_RES_SHIFT;
                    wreg_o      <= 1'b0;
                    wd_o        <= 5'b00000;
                    reg1_read_o <= 1'b0;
                    reg2_read_o <= 1'b0;
                end

                //arithmatic calculation with immediate
                6'b001000: begin    //addi
                    aluop_o     <= 8'b01010101;
                    alusel_o    <= `EXE_RES_ARITHMETIC;
                    reg1_read_o <= 1'b1;
                    wd_o        <= inst_i[20:16];
                    wreg_o      <= 1'b1;
                    imm[15:0]   <= {{16{inst_i[15]}}, inst_i[15:0]};
                end
                6'b001001: begin    //addiu
                    aluop_o     <= 8'b01010110;
                    alusel_o    <= `EXE_RES_ARITHMETIC;
                    reg1_read_o <= 1'b1;
                    wd_o        <= inst_i[20:16];
                    wreg_o      <= 1'b1;
                    imm[15:0]   <= {{16{inst_i[15]}}, inst_i[15:0]};
                end
                6'b001010: begin    //slti
                    aluop_o     <= 8'b00101010;
                    alusel_o    <= `EXE_RES_ARITHMETIC;
                    reg1_read_o <= 1'b1;
                    wd_o        <= inst_i[20:16];
                    wreg_o      <= 1'b1;
                    imm[15:0]   <= {{16{inst_i[15]}}, inst_i[15:0]};
                end
                6'b001011: begin    //sltiu
                    aluop_o     <= 8'b00101011;
                    alusel_o    <= `EXE_RES_ARITHMETIC;
                    reg1_read_o <= 1'b1;
                    wreg_o      <= 1'b1;
                    wd_o        <= inst_i[20:16];
                    imm[15:0]   <= {{16{inst_i[15]}}, inst_i[15:0]};
                end
                6'b011100: begin    //special2
                    case(funct)
                        6'b100000: begin    //clz
                            aluop_o     <= 8'b10110000;
                            alusel_o    <= `EXE_RES_ARITHMETIC;
                            reg1_read_o <= 1'b1;
                            wreg_o      <= 1'b1;
                        end
                        6'b100001:  begin   //clo
                            aluop_o     <= 8'b10110001;
                            alusel_o    <= `EXE_RES_ARITHMETIC;
                            reg1_read_o <= 1'b1;
                            wreg_o      <= 1'b1;
                        end
                        6'b000010:  begin   //mul
                            aluop_o     <= 8'b10101001;
                            alusel_o    <= `EXE_RES_ARITHMETIC;
                            wreg_o      <= 1'b1;
                            reg1_read_o <= 1'b1;
                            reg2_read_o <= 1'b1;
                        end
                        default: begin
                        end              
                    endcase
                end
                default: begin
                end
            endcase
        end
    end

    // determine the source of reg1_o
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
    
    // determine the source of reg2_o
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
