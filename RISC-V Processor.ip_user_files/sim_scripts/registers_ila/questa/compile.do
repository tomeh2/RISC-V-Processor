vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xpm
vlib questa_lib/msim/xil_defaultlib

vmap xpm questa_lib/msim/xpm
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xpm  -sv "+incdir+../../../../RISC-V Processor.gen/sources_1/ip/registers_ila/hdl/verilog" \
"E:/Programs/Xilinx_Vivado/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"E:/Programs/Xilinx_Vivado/Vivado/2020.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93 \
"E:/Programs/Xilinx_Vivado/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib  -93 \
"../../../../RISC-V Processor.gen/sources_1/ip/registers_ila/sim/registers_ila.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

