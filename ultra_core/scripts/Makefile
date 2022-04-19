# @Author : darthvader
# @Date   : 2021-06-25

work = work

top_tb_name = ultra_core_tb

DELFILES = clean_linux

file_list:
	./gen_file_list.py

cmp:
	/tools/Xilinx/Vivado/2021.2/bin/xvlog -work $(work) -i ../sim -sv -f input_pkg.f -f input_sv.f -L uvm
	/tools/Xilinx/Vivado/2021.2/bin/xelab work.$(top_tb_name) -s $(top_tb_name)_sim -Odisable_unused_removal -L uvm -timescale 1ns/1ps -debug all

run_sim_wave:
	/tools/Xilinx/Vivado/2021.2/bin/xsim -wdb sim.wdb -log session.log -t logw.tcl $(top_tb_name)_sim -testplusarg "UVM_TESTNAME=ultra_core_sanity_test"
	/tools/Xilinx/Vivado/2021.2/bin/xsim sim.wdb -gui

view_wave:
	/tools/Xilinx/Vivado/2021.2/bin/xsim sim.wdb -gui

clean_linux:
	rm -rf modelsim.* transcript* vlog.* work vsim.wlf *.log *hbs *Xil xsim.dir *.jou *.pb *.f *~ *.vcd *.wdb *.hex
	clear

clean_dos:
	if exist modelsim.* del modelsim.* /F /S /Q /A
	if exist transcript* del transcript* /F /S /Q /A
	if exist vlog.* del vlog.* /F /S /Q /A
	if exist vsim.wlf del vsim.wlf /F /S /Q /A
	if exist *.log del *.log /F /S /Q /A
	if exist work rd work /q /s
	if exist covhtmlreport rd covhtmlreport /q /s
	if exist *hbs del *hbs /q /s
	if exist *Xil del *Xil /q /s
	if exist xsim.dir del xsim.dir /q /s
	if exist *.jou del *.jou /F /S /Q /A
	if exist *.pb del *.pb /F /S /Q /A

clean_log:
	if exist *.log del *.log /f /s /q /a

clean:
	make $(DELFILES)
	make clean -C ../firmware

fw_hex:
	make firmware.hex -C ../firmware
	cp ../firmware/firmware.hex .

run_all:
	make clean
	make fw_hex
	make file_list
	make cmp
	make run_sim_wave

rerun:
	make clean
	make fw_hex
	make file_list
	make cmp
