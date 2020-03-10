module openmips(
    input wire          rst,
    input wire          clk,
    input wire[31:0]    rom_data_i,
    
    output wire         rom_ce_o,
    output wire[31:0]   rom_addr_o
);
    // module input and output
    assign rom_addr_o = pc;
    
    // connect pc_reg
    wire[31:0] pc;
    pc_reg pc_reg0(
        // control signal
        .rst(rst), .clk(clk),
        // input data
        // output data
        .pc(pc), .ce(rom_ce_o)
    );

    // connect if_id
    wire[31:0] id_pc_i;
    wire[31:0] id_inst_i;
    if_id if_id0(
        // control signal
        .rst(rst), .clk(clk),
        // input data
        .if_pc(pc), .if_inst(rom_data_i),
        // output data
        .id_pc(id_pc_i), .id_inst(id_inst_i)
    );

    // connect id
    wire[2:0]   id_alusel_o;
    wire[7:0]   id_aluop_o;
    wire        reg1_read;
    wire[4:0]   reg1_addr;
    wire[31:0]  reg1_data;
    wire        reg2_read;
    wire[4:0]   reg2_addr;
    wire[31:0]  reg2_data;
    wire[31:0]  id_reg1_o;
    wire[31:0]  id_reg2_o;
    wire        id_wreg_o;
    wire[4:0]   id_wd_o;
    id id_0(
        // control signal
        .rst(rst),
        // input data
        .pc_i(id_pc_i), .inst_i(id_inst_i), .reg1_data_i(reg1_data), .reg2_data_i(reg2_data),
        // output data
        .reg2_read_o(reg2_read), .reg2_addr_o(reg2_addr),
        .reg1_read_o(reg1_read), .reg1_addr_o(reg1_addr),
        .aluop_o(id_aluop_o), .alusel_o(id_alusel_o),
        .reg1_o(id_reg1_o), .reg2_o(id_reg2_o),
        .wreg_o(id_wreg_o), .wd_o(id_wd_o),
        // data conflict
            // from ex
        .ex_wreg_i(ex_wreg_o), .ex_wd_i(ex_wd_o), .ex_wdata_i(ex_wdata_o),
            // from mem
        .mem_wreg_i(mem_wreg_o), .mem_wd_i(mem_wd_o), .mem_wdata_i(mem_wdata_o)
            // conflict between wb & id has beed settled by in register reading
    );

    
    // connect id_ex
    wire[7:0]   ex_aluop_i;
    wire[2:0]   ex_alusel_i;
    wire[31:0]  ex_reg1_i;
    wire[31:0]  ex_reg2_i;
    wire        ex_wreg_i;
    wire[4:0]   ex_wd_i;
    id_ex id_ex0(
        // control signal
        .rst(rst), .clk(clk),
        // input data
        .id_aluop(id_aluop_o), .id_alusel(id_alusel_o), 
        .id_reg1(id_reg1_o), .id_reg2(id_reg2_o),
        .id_wd(id_wd_o), .id_wreg(id_wreg_o),
        // output data
        .ex_aluop(ex_aluop_i), .ex_alusel(ex_alusel_i),
        .ex_reg1(ex_reg1_i), .ex_reg2(ex_reg2_i),
        .ex_wreg(ex_wreg_i), .ex_wd(ex_wd_i)
    );

    // connect ex
    wire        ex_wreg_o;
    wire[4:0]   ex_wd_o;
    wire[31:0]  ex_wdata_o;
    wire        ex_whilo_o;
    wire[31:0]  ex_hi_o;
    wire[31:0]  ex_lo_o;
    wire[31:0]  HI;
    wire[31:0]  LO;
    ex ex_0(
        // control signal
        .rst(rst),
        // input data
        .aluop_i(ex_aluop_i), .alusel_i(ex_alusel_i),
        .reg1_i(ex_reg1_i), .reg2_i(ex_reg2_i),
        .wreg_i(ex_wreg_i), .wd_i(ex_wd_i),
        .hi_i(HI), .lo_i(LO),
        // output data
        .wreg_o(ex_wreg_o), .wd_o(ex_wd_o), .wdata_o(ex_wdata_o),
        .whilo_o(ex_whilo_o), .hi_o(ex_hi_o), .lo_o(ex_lo_o),
        // data conflict
            // from mem
        .mem_whilo_i(mem_whilo_o), .mem_hi_i(mem_hi_o), .mem_lo_i(mem_lo_o),
            // from wb
        .wb_whilo_i(wb_whilo_i), .wb_hi_i(wb_hi_i), .wb_lo_i(wb_lo_i)
        );

    // connect ex_mem 
    wire        mem_wreg_i;
    wire[4:0]   mem_wd_i;
    wire[31:0]  mem_wdata_i;
    wire        mem_whilo_i;
    wire[31:0]  mem_hi_i;
    wire[31:0]  mem_lo_i;
    ex_mem ex_mem0(
        // control signal
        .rst(rst), .clk(clk),
        // input data
        .ex_wreg(ex_wreg_o), .ex_wd(ex_wd_o), .ex_wdata(ex_wdata_o),
        .ex_whilo(ex_whilo_o), .ex_hi(ex_hi_o), .ex_lo(ex_lo_o),
        // output data
        .mem_wreg(mem_wreg_i), .mem_wd(mem_wd_i), .mem_wdata(mem_wdata_i),
        .mem_whilo(mem_whilo_i), .mem_hi(mem_hi_i), .mem_lo(mem_lo_i)
    );

    // connect mem
    wire        mem_wreg_o;
    wire[4:0]   mem_wd_o;
    wire[31:0]  mem_wdata_o;
    wire        mem_whilo_o;
    wire[31:0]  mem_hi_o;
    wire[31:0]  mem_lo_o;
    mem mem0(
        // control signal
        .rst(rst),
        // input data
        .wreg_i(mem_wreg_i), .wd_i(mem_wd_i), .wdata_i(mem_wdata_i),
        .whilo_i(mem_whilo_i), .hi_i(mem_hi_i), .lo_i(mem_lo_i),
        // output data
        .wreg_o(mem_wreg_o), .wd_o(mem_wd_o), .wdata_o(mem_wdata_o),
        .whilo_o(mem_whilo_o), .hi_o(mem_hi_o), .lo_o(mem_lo_o)
    );
    
    // connect mem_wb
    wire        wb_wreg_o;
    wire[4:0]   wb_wd_i;
    wire[31:0]  wb_data_i;
    wire        wb_whilo_i;
    wire[31:0]  wb_hi_i;
    wire[31:0]  wb_lo_i;
    mem_wb mem_wb0(
        // control signal
        .rst(rst), .clk(clk),
        // input data
        .mem_wreg(mem_wreg_o), .mem_wd(mem_wd_o), .mem_wdata(mem_wdata_o),
        .mem_whilo(mem_whilo_o), .mem_hi(mem_hi_o), .mem_lo(mem_lo_o),
        // output data
        .wb_wreg(wb_wreg_o), .wb_wd(wb_wd_i), .wb_wdata(wb_data_i),
        .wb_whilo(wb_whilo_i), .wb_hi(wb_hi_i), .wb_lo(wb_lo_i)
    );

    // connect regfile
    regfile regfile0(
        // control signal
        .rst(rst), .clk(clk),
        // input data
        .re1(reg1_read), .raddr1(reg1_addr), 
        .re2(reg2_read), .raddr2(reg2_addr),
        .we(wb_wreg_o), .waddr(wb_wd_i), .wdata(wb_data_i), 
        // output data
        .rdata1(reg1_data), .rdata2(reg2_data)
    );


    hilo_reg hilo_reg0(
        // control signal
        .rst(rst), .clk(clk),
        // input data
        .we(wb_whilo_i), .hi_i(wb_hi_i), .lo_i(wb_lo_i),
        // output data
        .hi_o(HI), .lo_o(LO)
    );
    
endmodule
