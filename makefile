module_test: pc_reg.v if_id.v id.v regfile.v hilo_reg.v id_ex.v ex.v ex_mem.v mem.v mem_wb.v openmips.v \
			inst_rom.v openmips_min_sopc.v openmips_min_sopc_tb.v
			iverilog -o module_test pc_reg.v if_id.v id.v regfile.v hilo_reg.v id_ex.v ex.v ex_mem.v mem.v \
			mem_wb.v openmips.v inst_rom.v openmips_min_sopc.v openmips_min_sopc_tb.v 
			vvp module_test
			gtkwave wave.vcd

rebuilt:
	rm module_test
	make

clean:
	rm module_test
