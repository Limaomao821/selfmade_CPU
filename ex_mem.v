module ex_mem(
    input wire[31:0]    ex_wdata,
    input wire[4:0]     ex_wd,
    input wire          ex_wreg,
    input wire          ex_whilo,
    input wire[31:0]    ex_hi,
    input wire[31:0]    ex_lo,

    input wire          rst,
    input wire          clk,

    output reg[31:0]    mem_wdata,
    output reg[4:0]     mem_wd,
    output reg          mem_wreg,
    output reg          mem_whilo,
    output reg[31:0]    mem_hi,
    output reg[31:0]    mem_lo
);
    always @ (posedge clk) begin
        if(rst == 1'b1) begin
            mem_wdata   <= 32'h00000000;
            mem_wd      <= 5'b00000;
            mem_wreg    <= 1'b0;

            mem_whilo   <= 1'b0;
            mem_hi      <= 32'h00000000;
            mem_lo      <= 32'h00000000;
        end else begin
            mem_wdata   <= ex_wdata;
            mem_wd      <= ex_wd;
            mem_wreg    <= ex_wreg;

            mem_whilo   <= ex_whilo;
            mem_hi      <= ex_hi;
            mem_lo      <= ex_lo;
        end
    end
endmodule
