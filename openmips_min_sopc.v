module openmips_min_sopc(
    input wire rst,
    input wire clk
);
    wire[31:0]  inst_addr;
    wire[31:0]  inst;
    wire        rom_ce;

    openmips openmips0(
        .rst(rst), .clk(clk), .rom_data_i(inst),
        .rom_ce_o(rom_ce), .rom_addr_o(inst_addr)
    );

    inst_rom inst_rom0(
        .ce(rom_ce), .addr(inst_addr), .inst(inst)
    );
endmodule
