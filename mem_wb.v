module mem_wb(
    input wire          mem_wreg,
    input wire[31:0]    mem_wdata,
    input wire[4:0]     mem_wd,
    input wire          mem_whilo,
    input wire[31:0]    mem_hi,
    input wire[31:0]    mem_lo,

    input wire          rst,
    input wire          clk,

    output reg          wb_wreg,
    output reg[31:0]    wb_wdata,
    output reg[4:0]     wb_wd,
    output reg          wb_whilo,
    output reg[31:0]    wb_hi,
    output reg[31:0]    wb_lo
);
    always @ (posedge clk) begin
        if(rst == 1'b1) begin
            wb_wdata    <= 32'h00000000;
            wb_wd       <= 5'b00000;
            wb_wreg     <= 1'b0;

            wb_whilo    <= 1'b0;
            wb_hi       <= 32'h00000000;
            wb_lo       <= 32'h00000000;
        end else begin
            wb_wdata    <= mem_wdata;
            wb_wd       <= mem_wd;
            wb_wreg     <= mem_wreg;

            wb_whilo    <= mem_whilo;
            wb_hi       <= mem_hi;
            wb_lo       <= mem_lo;
        end
    end
endmodule
