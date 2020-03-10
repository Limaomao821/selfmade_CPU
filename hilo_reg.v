// Advantages of this kind of design
// It could save the time of reading register hi and lo
// Because every clock, they are already there
module hilo_reg(
    input wire          rst,
    input wire          clk,

    input wire          we,
    input wire[31:0]    hi_i,
    input wire[31:0]    lo_i,

    output reg[31:0]    hi_o,
    output reg[31:0]    lo_o
);
    always @(posedge clk) begin
        if(rst==1'b1) begin
            hi_o <= 32'h00000000;
            lo_o <= 32'h00000000;
        end else if(we==1'b1) begin
            hi_o  <= hi_i;
            lo_o  <= lo_i;
        end
    end
endmodule