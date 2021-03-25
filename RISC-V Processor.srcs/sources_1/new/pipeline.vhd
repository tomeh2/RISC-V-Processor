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
    signal dec_alu_imm_data_out : std_logic_vector(11 downto 0);
    signal dec_reg_wr_addr_out : std_logic_vector(4 downto 0);
    signal dec_reg_addr_1, dec_reg_addr_2 : std_logic_vector(4 downto 0);         -- Read register addresses for forwarding puropses
    signal dec_reg_1_used, dec_reg_2_used : std_logic;
    signal dec_alu_op_out : std_logic_vector(3 downto 0);
    signal dec_reg_wr_en_out : std_logic;
    signal dec_sel_immediate_out : std_logic;
    signal dec_em_forward_1, dec_em_forward_2 : std_logic;
    signal dec_mw_forward_1, dec_mw_forward_2 : std_logic;
    
    -- EXECUTE STAGE SIGNALS
    signal exe_reg_data_bus_1_in, exe_reg_data_bus_2_in : std_logic_vector(31 downto 0);
    signal exe_alu_imm_data_in : std_logic_vector(11 downto 0);
    signal exe_alu_res_out : std_logic_vector(31 downto 0);
    signal exe_alu_op_in : std_logic_vector(3 downto 0);
    signal exe_reg_addr_1, exe_reg_addr_2 : std_logic_vector(4 downto 0);
    signal exe_reg_1_used, exe_reg_2_used : std_logic;
    signal exe_sel_immediate_in : std_logic;
    
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

    -- ================ PIPELINE CONTROL ENTITIES ================
    forwarding_unit : entity work.forwarding_unit(rtl)
                      port map(de_reg_src_addr_1 => exe_reg_addr_1,
                               de_reg_src_addr_2 => exe_reg_addr_2,
                               de_reg_1_used => exe_reg_1_used,
                               de_reg_2_used => exe_reg_2_used,
                               em_reg_dest_used => pt_reg_wr_en_mem,
                               mw_reg_dest_used => wrb_reg_we,
                               em_reg_dest_addr => pt_reg_wr_addr_mem,
                               mw_reg_dest_addr => wrb_reg_addr_out,
                               em_hazard_src_1 => dec_em_forward_1,
                               em_hazard_src_2 => dec_em_forward_2,
                               mw_hazard_src_1 => dec_mw_forward_1,
                               mw_hazard_src_2 => dec_mw_forward_2);

    -- ================== STAGE INITIALIZATIONS ==================
    stage_decode : entity work.stage_decode(arch)
                   port map(data_bus => dec_data_bus_in,
                            instr_bus => dec_instr_bus_in,
                            reg_data_1 => dec_reg_data_1_out,
                            reg_data_2 => dec_reg_data_2_out,
                            alu_imm_data => dec_alu_imm_data_out,
                            alu_op => dec_alu_op_out,
                            sel_immediate => dec_sel_immediate_out,
                            reg_rd_addr_1_out => dec_reg_addr_1,
                            reg_rd_addr_2_out => dec_reg_addr_2,
                            reg_wr_addr_in => wrb_reg_addr_out,
                            reg_wr_addr_out => dec_reg_wr_addr_out,
                            reg_wr_en_dec_out => dec_reg_wr_en_out,
                            reg_rd_1_used => dec_reg_1_used,
                            reg_rd_2_used => dec_reg_2_used,
                            reg_wr_en => wrb_reg_we,
                            clk => clk,
                            reset => reset);
                            
    stage_execute : entity work.stage_execute(arch)
                    port map(reg_data_bus_1 => exe_reg_data_bus_1_in,
                             reg_data_bus_2 => exe_reg_data_bus_2_in,
                             forward_data_em => mem_data_bus_in,
                             forward_data_mw => wrb_data_bus_out,
                             alu_imm_data_bus => exe_alu_imm_data_in,
                             alu_res_bus => exe_alu_res_out,
                             alu_op => exe_alu_op_in,
                             sel_immediate => exe_sel_immediate_in,
                             em_forward_1 => dec_em_forward_1,
                             em_forward_2 => dec_em_forward_2,
                             mw_forward_1 => dec_mw_forward_1,
                             mw_forward_2 => dec_mw_forward_2);
    
    stage_memory : entity work.stage_memory(arch)
                   port map(data_bus_in => mem_data_bus_in,
                            data_bus_out => mem_data_bus_out);
    
    -- ============ PIPELINE REGISTER INITIALIZATIONS ============
    reg_de : entity work.register_var(arch)
             generic map(WIDTH_BITS => 99)
                      -- Datapath data signals in
             port map(d(31 downto 0) => dec_reg_data_1_out,
                      d(63 downto 32) => dec_reg_data_2_out,
                      d(75 downto 64) => dec_alu_imm_data_out,
                      -- Datapath control signals in
                      d(80 downto 76) => dec_reg_addr_1,
                      d(85 downto 81) => dec_reg_addr_2,
                      d(89 downto 86) => dec_alu_op_out,
                      d(94 downto 90) => dec_reg_wr_addr_out,
                      d(95) => dec_reg_wr_en_out,
                      d(96) => dec_sel_immediate_out,
                      d(97) => dec_reg_1_used,
                      d(98) => dec_reg_2_used,
                      -- Datapath data signals out
                      q(31 downto 0) => exe_reg_data_bus_1_in,
                      q(63 downto 32) => exe_reg_data_bus_2_in,
                      q(75 downto 64) => exe_alu_imm_data_in,
                      -- Datapath control signals out
                      q(80 downto 76) => exe_reg_addr_1,
                      q(85 downto 81) => exe_reg_addr_2,
                      q(89 downto 86) => exe_alu_op_in,
                      q(94 downto 90) => pt_reg_wr_addr_exe,
                      q(95) => pt_reg_wr_en_exe,
                      q(96) => exe_sel_immediate_in,
                      q(97) => exe_reg_1_used,
                      q(98) => exe_reg_2_used,
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


















