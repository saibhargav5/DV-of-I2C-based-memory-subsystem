VLOG_FLAGS = -source -lint -sv

fst:
	rm -rf transcript work *.vcd
	vlog $(VLOG_FLAGS) my_pkg.sv I2C.sv controller.sv memory.sv i2c_top.sv mux8to1.sv  shiftregister.sv dff.sv top.sv 
	vsim -c -voptargs=+acc=npr top -do "vcd file dump.vcd; vcd add -r top/*; run -all; quit"

clean:
	rm -rf transcript work *.vcd