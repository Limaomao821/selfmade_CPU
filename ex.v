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
                8'b00100101: begin
                    wdata_o     <= reg1_i | reg2_i;
                end
                default: begin
                end
            endcase
        end
    end
endmodule
