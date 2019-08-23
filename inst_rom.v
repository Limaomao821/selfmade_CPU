module inst_rom(
    input wire          ce,
    input wire[31:0]    addr,
    
    output reg[31:0]   inst
);

   reg[31:0] inst_mem[131070:0];

   initial $readmemh("inst_rom.data", inst_mem);

   always @ (*) begin
       if(ce == 1'b0) begin
           inst <= 32'h00000000;
       end else begin
           inst <= inst_mem[addr[16:2]];
       end
   end
endmodule
