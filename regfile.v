module regfile(
    input wire              re1,    
    input wire[4:0]         raddr1,
    input wire              re2,
    input wire[4:0]         raddr2,
    input wire              we,
    input wire[4:0]         waddr,
    input wire[31:0]        wdata,

    input wire              rst,
    input wire              clk,

    output reg[31:0]        rdata1,
    output reg[31:0]        rdata2
);
    //32 regs in regfile
    reg[31:0] regs[0:31];

    //read data 1
    always @(*) begin
        if(rst == 1'b1) begin
            rdata1 <= 32'h00000000;
            regs[0] <= 32'h00000000;
        end else if((waddr == raddr1) && (re1 == 1'b1) && (we == 1'b1)) begin
            rdata1 <= wdata; 
        end else if(re1 == 1'b1) begin
            rdata1 <= regs[raddr1];
        end else begin
            rdata1 <= 32'h00000000;
        end
    end

    //read data 2
    always @(*) begin
        if(rst == 1'b1) begin
            rdata2 <= 32'h00000000;
            regs[0] <= 32'h00000000;
        end else if((waddr == raddr2) && (re2 == 1'b1) && (we == 1'b1)) begin
            rdata2 <= wdata; 
        end else if(re2 == 1'b1) begin
            rdata2 <= regs[raddr1];
        end else begin
            rdata2 <= 32'h00000000;
        end
    end

    //write data
    always @(posedge clk) begin
        if(rst == 1'b0) begin
            if((we == 1'b1) && (waddr == 5'b00000)) begin
                regs[waddr] <= 5'b00000;
            end else if((we == 1'b1) && (waddr != 5'b00000)) begin
                regs[waddr] <= wdata;
            end
        end
    end
endmodule
