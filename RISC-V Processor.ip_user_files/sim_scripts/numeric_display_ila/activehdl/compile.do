vlib work
vlib activehdl

vlib activehdl/xpm
vlib activehdl/xil_defaultlib

vmap xpm activehdl/xpm
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xpm  -sv2k12 "+incdir+../../../../RISC-V Processor.gen/sources_1/ip/numeric_display_ila/hdl/verilog" \
"E:/Programs/Xilinx_Vivado/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"E:/Programs/Xilinx_Vivado/Vivado/2020.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"E:/Programs/Xilinx_Vivado/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -93 \
"../../../../RISC-V Processor.gen/sources_1/ip/numeric_display_ila/sim/numeric_display_ila.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

