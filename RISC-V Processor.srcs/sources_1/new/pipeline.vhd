----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2021 10:55:59 PM
-- Design Name: 
-- Module Name: pipeline - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Note that WRITEBACK stage does not have its own module.
-- That is because in the writeback stage we only bring the data
-- signals to the registers without doing any processing on it.

-- Signal naming convention:
-- signal [First 3 letters of the module]_[Signal name]_[In / Out]

entity pipeline is
    port(
        instr_bus_test : in std_logic_vector(31 downto 0);
        clk, reset : in std_logic
    );
end pipeline;

architecture rtl of pipeline is
    -- DECODE STAGE SIGNALS
    signal dec_data_bus_in, dec_instr_bus_in : std_logic_vector(31 downto 0);
    signal dec_reg_data_1_out, dec_reg_data_2_out : std_logic_vector(31 downto 0);
    signal dec_reg_wr_addr_out : std_logic_vector(4 downto 0);
    signal dec_alu_op_out : std_logic_vector(3 downto 0);
    signal dec_reg_wr_en_out : std_logic;
    
    -- EXECUTE STAGE SIGNALS
    signal exe_reg_data_bus_1_in, exe_reg_data_bus_2_in : std_logic_vector(31 downto 0);
    signal exe_alu_res_out : std_logic_vector(31 downto 0);
    signal exe_alu_op_in : std_logic_vector(3 downto 0);
    
    -- MEMORY STAGE SIGNALS
    signal mem_data_bus_in : std_logic_vector(31 downto 0);
    signal mem_data_bus_out : std_logic_vector(31 downto 0);
    
    -- WRITEBACK STAGE SIGNALS
    signal wrb_data_bus_out : std_logic_vector(31 downto 0);
    signal wrb_reg_addr_out : std_logic_vector(4 downto 0);
    signal wrb_reg_we : std_logic;
    
    -- PASSTHROUGH SIGNALS (Signal lines which are connected between pipeline registers)
    signal pt_reg_wr_en_exe, pt_reg_wr_en_mem : std_logic;                              -- Register file write enable signal
    signal pt_reg_wr_addr_exe, pt_reg_wr_addr_mem : std_logic_vector(4 downto 0);       -- Destination register address
    
begin
    dec_instr_bus_in <= instr_bus_test;

    -- ================== STAGE INITIALIZATIONS ==================
    stage_decode : entity work.stage_decode(arch)
                   port map(data_bus => dec_data_bus_in,
                            instr_bus => dec_instr_bus_in,
                            reg_data_1 => dec_reg_data_1_out,
                            reg_data_2 => dec_reg_data_2_out,
                            alu_op => dec_alu_op_out,
                            reg_wr_addr_in => wrb_reg_addr_out,
                            reg_wr_addr_out => dec_reg_wr_addr_out,
                            reg_wr_en_dec_out => dec_reg_wr_en_out,
                            reg_wr_en => wrb_reg_we,
                            clk => clk,
                            reset => reset);
                            
    stage_execute : entity work.stage_execute(arch)
                    port map(reg_data_bus_1 => exe_reg_data_bus_1_in,
                             reg_data_bus_2 => exe_reg_data_bus_2_in,
                             alu_res_bus => exe_alu_res_out,
                             alu_op => exe_alu_op_in);
    
    stage_memory : entity work.stage_memory(arch)
                   port map(data_bus_in => mem_data_bus_in,
                            data_bus_out => mem_data_bus_out);
    
    -- ============ PIPELINE REGISTER INITIALIZATIONS ============
    reg_de : entity work.register_var(arch)
             generic map(WIDTH_BITS => 74)
                      -- Datapath data signals in
             port map(d(31 downto 0) => dec_reg_data_1_out,
                      d(63 downto 32) => dec_reg_data_2_out,
                      -- Datapath control signals in
                      d(67 downto 64) => dec_alu_op_out,
                      d(72 downto 68) => dec_reg_wr_addr_out,
                      d(73) => dec_reg_wr_en_out,
                      -- Datapath data signals out
                      q(31 downto 0) => exe_reg_data_bus_1_in,
                      q(63 downto 32) => exe_reg_data_bus_2_in,
                      -- Datapath control signals out
                      q(67 downto 64) => exe_alu_op_in,
                      q(72 downto 68) => pt_reg_wr_addr_exe,
                      q(73) => pt_reg_wr_en_exe,
                      -- Register control
                      clk => clk,
                      reset => reset,
                      en => '1');
                      
    reg_em : entity work.register_var(arch)
             generic map(WIDTH_BITS => 38)
                      -- Datapath data signals in
             port map(d(31 downto 0) => exe_alu_res_out,
                      -- Datapath control signals in
                      d(36 downto 32) => pt_reg_wr_addr_exe,
                      d(37) => pt_reg_wr_en_exe,
                      -- Datapath data signals out
                      q(31 downto 0) => mem_data_bus_in,
                      -- Datapath control signals out
                      q(36 downto 32) => pt_reg_wr_addr_mem,
                      q(37) => pt_reg_wr_en_mem,
                      -- Register control
                      clk => clk,
                      reset => reset,
                      en => '1');
                      
    reg_mw : entity work.register_var(arch)
             generic map(WIDTH_BITS => 38)
                      -- Datapath data signals in
             port map(d(31 downto 0) => mem_data_bus_out,
                      -- Datapath control signals in
                      d(36 downto 32) => pt_reg_wr_addr_mem,
                      d(37) => pt_reg_wr_en_mem,
                      -- Datapath data signals out
                      q(31 downto 0) => wrb_data_bus_out,
                      -- Datapath control signals out
                      q(36 downto 32) => wrb_reg_addr_out,
                      q(37) => wrb_reg_we,
                      -- Register control
                      clk => clk,
                      reset => reset,
                      en => '1');
                      
    -- Signal assignments
    dec_data_bus_in <= wrb_data_bus_out;
end rtl;


















