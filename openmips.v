module openmips(
    input wire          rst,
    input wire          clk,
    input wire[31:0]    rom_data_i,
    
    output wire         rom_ce_o,
    output wire[31:0]   rom_addr_o
);
    //connect pc_reg to if_id////////////////////////////////
    wire[31:0] pc;

    pc_reg pc_reg0(
        .rst(rst), .clk(clk), .pc(pc), 
        .ce(rom_ce_o)
    );

    //connect if_id to id///////////////////////////////////
    wire[31:0] id_pc_i;
    wire[31:0] id_inst_i;

    if_id if_id0(
       .if_pc(pc), .if_inst(rom_data_i), .rst(rst), .clk(clk), 
       .id_pc(id_pc_i), .id_inst(id_inst_i)
    );

    //connect id to id_ex///////////////////////////////////
    wire[7:0]   id_aluop_o;
    wire[31:0]  id_reg1_o;
    wire[31:0]  id_reg2_o;
    wire[4:0]   id_wd_o;
    wire        id_wreg_o;
    //connect id to regfile
    wire        reg1_read;
    wire[4:0]   reg1_addr;
    wire        reg2_read;
    wire[4:0]   reg2_addr;
    //connect regfile to id
    wire[31:0]  reg1_data;
    wire[31:0]  reg2_data;
    id id_0(
       .pc_i(id_pc_i), .inst_i(id_inst_i), .reg1_data_i(reg1_data), .reg2_data_i(reg2_data),
       .rst(rst), .aluop_o(id_aluop_o), .reg1_o(id_reg1_o), .reg2_o(id_reg2_o), 
       .wreg_o(id_wreg_o), .wd_o(id_wd_o), .reg2_addr_o(reg2_addr), .reg2_read_o(reg2_read),
       .reg1_addr_o(reg1_addr), .reg1_read_o(reg1_read)
    );

    
    //connect id_ex to ex///////////////////////////////////
    wire[7:0]   ex_aluop_i;
    wire[31:0]  ex_reg1_i;
    wire[31:0]  ex_reg2_i;
    wire[4:0]   ex_wd_i;
    wire        ex_wreg_i;
    id_ex id_ex0(
        .id_aluop(id_aluop_o), .id_reg1(id_reg1_o), .id_reg2(id_reg2_o), .id_wd(id_wd_o),
        .id_wreg(id_wreg_o), .rst(rst), .clk(clk), .ex_aluop(ex_aluop_i), .ex_reg1(ex_reg1_i),
        .ex_reg2(ex_reg2_i), .ex_wd(ex_wd_i), .ex_wreg(ex_wreg_i)
    );
    //connect ex to ex_mem///////////////////////////////////
    wire[31:0]  ex_wdata_o;
    wire[4:0]   ex_wd_o;
    wire        ex_wreg_o;
    ex ex_0(
        .aluop_i(ex_aluop_i), .reg1_i(ex_reg1_i), .reg2_i(ex_reg2_i), .wd_i(ex_wd_i),
        .wreg_i(ex_wreg_i), .rst(rst), .wdata_o(ex_wdata_o), .wd_o(ex_wd_o), .wreg_o(ex_wreg_o)
        );

    //connect ex_mem 
    wire[31:0]  mem_wdata_i;
    wire[4:0]   mem_wd_i;
    wire        mem_wreg_i;
    ex_mem ex_mem0(
        .ex_wdata(ex_wdata_o), .ex_wd(ex_wd_o), .ex_wreg(ex_wreg_o),
        .rst(rst), .clk(clk), 
        .mem_wdata(mem_wdata_i), .mem_wd(mem_wd_i), .mem_wreg(mem_wreg_i)
    );

    //connect mem
    wire[31:0]  mem_wdata_o;
    wire[4:0]   mem_wd_o;
    wire        mem_wreg_o;
    mem mem0(
        .wdata_i(mem_wdata_i), .wd_i(mem_wd_i), .wreg_i(mem_wreg_i),
        .rst(rst), .wdata_o(mem_wdata_o), .wd_o(mem_wd_o), .wreg_o(mem_wreg_o)
    );
    
    //connect mem_wb to regfile///////////////////////////////
    wire        wb_wreg_o;
    wire[4:0]   wb_wd_i;
    wire[31:0]  wb_data_i;

    //connect mem_wb
    mem_wb mem_wb0(
        .mem_wdata(mem_wdata_o), .mem_wd(mem_wd_o), .mem_wreg(mem_wreg_o), 
        .rst(rst), .clk(clk),
        .wb_wdata(wb_data_i), .wb_wd(wb_wd_i), .wb_wreg(wb_wreg_o)
    );

    regfile regfile0(.re1(reg1_read), .raddr1(reg1_addr), .re2(reg2_read), .raddr2(reg2_addr),
                     .we(wb_wreg_o), .waddr(wb_wd_i), .wdata(wb_data_i), .rst(rst), .clk(clk),
                     .rdata1(reg1_data), .rdata2(reg2_data));


    //the module input and output/////////////////////////////
    assign rom_addr_o = pc;
endmodule
