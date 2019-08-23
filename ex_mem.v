module ex_mem(
    input wire[31:0]    ex_wdata,
    input wire[4:0]     ex_wd,
    input wire          ex_wreg,

    input wire          rst,
    input wire          clk,

    output reg[31:0]   mem_wdata,
    output reg[4:0]    mem_wd,
    output reg         mem_wreg
);
    always @ (posedge clk) begin
        if(rst == 1'b1) begin
            mem_wdata   <= 32'h00000000;
            mem_wd      <= 5'b00000;
            mem_wreg    <= 1'b0;
        end else begin
            mem_wdata   <= ex_wdata;
            mem_wd      <= ex_wd;
            mem_wreg    <= ex_wreg;
        end
    end
endmodule
