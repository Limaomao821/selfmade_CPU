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

    //convenient to see into regfiles
    //for debug purpose only
    wire[31:0] regs_0;
    wire[31:0] regs_1;
    wire[31:0] regs_2;
    wire[31:0] regs_3;
    wire[31:0] regs_4;
    wire[31:0] regs_5;
    wire[31:0] regs_6;
    wire[31:0] regs_7;
    wire[31:0] regs_8;
    wire[31:0] regs_9;
    wire[31:0] regs_10;
    wire[31:0] regs_11;
    wire[31:0] regs_12;
    wire[31:0] regs_13;
    wire[31:0] regs_14;
    wire[31:0] regs_15;
    wire[31:0] regs_16;
    wire[31:0] regs_17;
    wire[31:0] regs_18;
    wire[31:0] regs_19;
    wire[31:0] regs_20;
    wire[31:0] regs_21;
    wire[31:0] regs_22;
    wire[31:0] regs_23;
    wire[31:0] regs_24;
    wire[31:0] regs_25;
    wire[31:0] regs_26;
    wire[31:0] regs_27;
    wire[31:0] regs_28;
    wire[31:0] regs_29;
    wire[31:0] regs_30;
    wire[31:0] regs_31;

    assign regs_0   = regs[0];
    assign regs_1   = regs[1];
    assign regs_2   = regs[2];
    assign regs_3   = regs[3];
    assign regs_4   = regs[4];
    assign regs_5   = regs[5];
    assign regs_6   = regs[6];
    assign regs_7   = regs[7];
    assign regs_8   = regs[8];
    assign regs_9   = regs[9];
    assign regs_10  = regs[10];
    assign regs_11  = regs[11];
    assign regs_12  = regs[12];
    assign regs_13  = regs[13];
    assign regs_14  = regs[14];
    assign regs_15  = regs[15];
    assign regs_16  = regs[16];
    assign regs_17  = regs[17];
    assign regs_18  = regs[18];
    assign regs_19  = regs[19];
    assign regs_20  = regs[20];
    assign regs_21  = regs[21];
    assign regs_22  = regs[22];
    assign regs_23  = regs[23];
    assign regs_24  = regs[24];
    assign regs_25  = regs[25];
    assign regs_26  = regs[26];
    assign regs_27  = regs[27];
    assign regs_28  = regs[28];
    assign regs_29  = regs[29];
    assign regs_30  = regs[30];
    assign regs_31  = regs[31];

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
            rdata2 <= regs[raddr2];
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
