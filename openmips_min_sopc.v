module openmips_min_sopc(
    input wire  rst,
    input wire  clk
);
    wire[31:0]  inst_addr;
    wire[31:0]  inst;
    wire        rom_ce;

    openmips openmips0(
        // control signal
        .rst(rst), .clk(clk), 
        // input data
        .rom_data_i(inst),
        // output data
        .rom_ce_o(rom_ce), .rom_addr_o(inst_addr)
    );
    inst_rom inst_rom0(
        // input data
        .ce(rom_ce), .addr(inst_addr),
        // output data
        .inst(inst)
    );
endmodule
