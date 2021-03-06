module pc_reg(
    input wire          rst,
    input wire          clk,
    input wire[5:0]     stall,

    output reg[31:0]    pc,
    output reg          ce
);

//    always @ (posedge clk) begin
//        if(rst == 1'b1) begin
//            pc <= 32'h00000000;
//            ce <= 1'b0;
//        end else begin
//            pc <= pc + 4'h4;
//            ce <= 1'b1;
//        end
//    end

    always @ (posedge clk) begin
        if(rst == 1'b1) begin
            ce <= 1'b0;
        end else begin
            ce <= 1'b1;
        end
    end

    always @ (posedge clk) begin
        if(rst == 1'b1) begin
            pc <= 32'h00000000;
        end else if(stall[0] == `NoStop) begin
            pc <= pc + 4'h4;
        end else begin
            pc <= pc;
        end
    end
endmodule
