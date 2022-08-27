TEST_DIR = tb
CORE_DIR = core
BUILDS_DIR = builds

default: vcd

clean:	
	rm -rf *.json *.blif *.edif *.out *.vcd *.values
	rm -rf builds
	@ls -l

vcd:
	@echo "-------------------------------------------------------"
	@echo "Generating the VDD executable script from Verilog files"
	@echo "-------------------------------------------------------"
	@mkdir -p ${BUILDS_DIR}/vcd
	@echo "$(wildcard ${TEST_DIR}/*)"
	@for file in $(notdir $(basename $(wildcard ${TEST_DIR}/*))); do\
		echo "-------------------------------------------------------";\
		echo "Compiling $$file...";\
		echo "-------------------------------------------------------";\
		iverilog -Wall -o "${BUILDS_DIR}/vcd/$(addsuffix .vvp,$$file)" top.v ${CORE_DIR}/* "${TEST_DIR}/$(addsuffix .v,$$file)";\
		echo "-------------------------------------------------------";\
		echo "Generating VCD Wave for $$file...";\
		echo "-------------------------------------------------------";\
		cd ${BUILDS_DIR}/vcd;\
		vvp $(addsuffix .vvp,$$file);\
		cd ../..;\
	done


cycloneiv: 
	@echo "Generating Cyclone IV files"
	@mkdir -p builds/cycloneiv
	yosys -p "-family cycloneiv -edif builds/cycloneiv/top_cycloneiv.edif -blif builds/cycloneiv/top_cycloneiv.blif -json builds/cycloneiv/top_cycloneiv.json" top.v \
		`cat verilog.includes | grep -v "^#" | tr '\012' ' '`