@echo off
REM ****************************************************************************
REM Vivado (TM) v2020.2 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Tue May 04 18:57:51 +0200 2021
REM SW Build 3064766 on Wed Nov 18 09:12:45 MST 2020
REM
REM Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
REM simulate design
echo "xsim cpu_tb_behav -key {Behavioral:sim_1:Functional:cpu_tb} -tclbatch cpu_tb.tcl -view E:/Vivado Projects/RISC-V Processor/cpu_tb_behav.wcfg -view E:/Vivado Projects/RISC-V Processor/cpu_tb_pipeline.wcfg -view E:/Vivado Projects/RISC-V Processor/cpu_tb_fetch.wcfg -view E:/Vivado Projects/RISC-V Processor/cpu_tb_decode.wcfg -view E:/Vivado Projects/RISC-V Processor/cpu_tb_regfile.wcfg -view E:/Vivado Projects/RISC-V Processor/cpu_tb_execute.wcfg -view E:/Vivado Projects/RISC-V Processor/cpu_tb_memory.wcfg -view E:/Vivado Projects/RISC-V Processor/cpu_tb_bus_controller.wcfg -log simulate.log"
call xsim  cpu_tb_behav -key {Behavioral:sim_1:Functional:cpu_tb} -tclbatch cpu_tb.tcl -view E:/Vivado Projects/RISC-V Processor/cpu_tb_behav.wcfg -view E:/Vivado Projects/RISC-V Processor/cpu_tb_pipeline.wcfg -view E:/Vivado Projects/RISC-V Processor/cpu_tb_fetch.wcfg -view E:/Vivado Projects/RISC-V Processor/cpu_tb_decode.wcfg -view E:/Vivado Projects/RISC-V Processor/cpu_tb_regfile.wcfg -view E:/Vivado Projects/RISC-V Processor/cpu_tb_execute.wcfg -view E:/Vivado Projects/RISC-V Processor/cpu_tb_memory.wcfg -view E:/Vivado Projects/RISC-V Processor/cpu_tb_bus_controller.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
