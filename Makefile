default: 

clean:	
	rm -rf *.json *.blif *.edif *.out *.vcd *.values
	rm -rf builds
	@ls -l

vcd:  
	@echo "Generating the VDD executable script from Verilog files"
	@mkdir -p builds/vcd
	iverilog -Wall -o builds/vcd/top.out top.v \
		`cat verilog.includes | grep -v "^#" | tr '\012' ' '` \
		`cat verilog_tb.includes | grep -v "^#" | tr '\012' ' '`
	@echo "Running the top.out file to generate gtkwave file."
	@(cd builds/vcd; ./top.out)

cycloneiv: 
	@echo "Generating Cyclone IV files"
	@mkdir -p builds/cycloneiv
	yosys -p "-family cycloneiv -edif builds/cycloneiv/top_cycloneiv.edif -blif builds/cycloneiv/top_cycloneiv.blif -json builds/cycloneiv/top_cycloneiv.json" top.v \
		`cat verilog.includes | grep -v "^#" | tr '\012' ' '`