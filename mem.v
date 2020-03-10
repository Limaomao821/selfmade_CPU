module mem(
    input wire[31:0]    wdata_i,
    input wire[4:0]     wd_i,
    input wire          wreg_i,
    input wire          whilo_i,
    input wire[31:0]    hi_i,
    input wire[31:0]    lo_i,

    input rst,

    output reg[31:0]    wdata_o,
    output reg[4:0]     wd_o,
    output reg          wreg_o,
    output reg          whilo_o,
    output reg[31:0]    hi_o,
    output reg[31:0]    lo_o
);
    always @ (*) begin
        if(rst == 1'b1) begin
            wdata_o <= 32'h00000000;
            wd_o    <= 5'b00000;
            wreg_o  <= 1'b0;

            whilo_o <= 1'b0;
            hi_o    <= 32'h00000000;
            lo_o    <= 32'h00000000;
        end else begin
            wdata_o <= wdata_i;
            wd_o    <= wd_i;
            wreg_o  <= wreg_i;

            whilo_o <= whilo_i;
            hi_o    <= hi_i;
            lo_o    <= lo_i;
        end
    end
endmodule
