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
        instr_addr_bus, data_addr_bus : out std_logic_vector(31 downto 0);      -- Address busses for reading memory locations (HARVARD ARCH.)
        instr_bus : in std_logic_vector(31 downto 0);                          
        data_bus : out std_logic_vector(31 downto 0);                         -- Data bus for reading/writing memory or I/O devices
    
        clk, reset : in std_logic
    );
end pipeline;

architecture rtl of pipeline is
    -- FETCH STAGE SIGNALS
    signal fet_instr_bus_out, fet_pc_out : std_logic_vector(31 downto 0);

    -- DECODE STAGE SIGNALS
    signal dec_data_bus_in, dec_instr_bus_in : std_logic_vector(31 downto 0);
    signal dec_reg_data_1_out, dec_reg_data_2_out : std_logic_vector(31 downto 0);
    signal dec_reg_mem_data_out : std_logic_vector(31 downto 0);
    signal dec_imm_field_out : std_logic_vector(19 downto 0);
    signal dec_reg_wr_addr_out : std_logic_vector(4 downto 0);
    signal dec_reg_addr_1, dec_reg_addr_2 : std_logic_vector(4 downto 0);         -- Read register addresses for forwarding puropses
    signal dec_reg_1_used, dec_reg_2_used : std_logic;
    signal dec_alu_op_out : std_logic_vector(3 downto 0);
    signal dec_branch_condition_out : std_logic_vector(2 downto 0);
    signal dec_prog_flow_cntrl_out : std_logic_vector(1 downto 0);                
    signal dec_reg_wr_en_out : std_logic;
    signal dec_sel_immediate_out : std_logic;
    signal dec_sel_mem_output_out : std_logic;
    signal dec_em_forward_1, dec_em_forward_2 : std_logic;
    signal dec_mw_forward_1, dec_mw_forward_2 : std_logic;
    
    -- EXECUTE STAGE SIGNALS
    signal exe_reg_data_bus_1_in, exe_reg_data_bus_2_in : std_logic_vector(31 downto 0);
    signal exe_alu_imm_data_in : std_logic_vector(19 downto 0);
    signal exe_alu_res_out : std_logic_vector(31 downto 0);
    signal exe_pc_val_in : std_logic_vector(31 downto 0);
    signal exe_alu_op_in : std_logic_vector(3 downto 0);
    signal exe_branch_condition_in : std_logic_vector(2 downto 0);
    signal exe_prog_flow_cntrl_in : std_logic_vector(1 downto 0);
    signal exe_reg_addr_1, exe_reg_addr_2 : std_logic_vector(4 downto 0);
    signal exe_reg_1_used, exe_reg_2_used : std_logic;
    signal exe_sel_immediate_in : std_logic;
    
    -- MEMORY STAGE SIGNALS
    signal mem_data_bus_in : std_logic_vector(31 downto 0);
    signal mem_data_bus_out : std_logic_vector(31 downto 0);
    signal mem_addr_bus_in : std_logic_vector(31 downto 0);
    signal mem_sel_output_in : std_logic;
    
    -- WRITEBACK STAGE SIGNALS
    signal wrb_data_bus_out : std_logic_vector(31 downto 0);
    signal wrb_reg_addr_out : std_logic_vector(4 downto 0);
    signal wrb_reg_we : std_logic;
    
    -- PASSTHROUGH SIGNALS (Signal lines which are connected between pipeline registers)
    signal pt_reg_wr_en_exe, pt_reg_wr_en_mem : std_logic;                              -- Register file write enable signal
    signal pt_mem_sel_output : std_logic;
    signal pt_reg_wr_addr_exe, pt_reg_wr_addr_mem : std_logic_vector(4 downto 0);       -- Destination register address
    signal pt_pc_val_fet : std_logic_vector(31 downto 0);
    signal pt_reg_mem_data_exe : std_logic_vector(31 downto 0);
    
    -- BRANCHING SPECIFIC SIGNALS
    signal sp_branch_taken_cntrl : std_logic;
    signal sp_pc_dest_addr : std_logic_vector(31 downto 0);
    
    -- PIPELINE REGISTER CONTROL SIGNALS
    signal pc_reset_fd, pc_reset_de, pc_reset_em, pc_reset_mw : std_logic;
    
begin
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
    stage_fetch : entity work.stage_fetch(arch)
                  port map(instr_addr_bus => instr_addr_bus,
                           pc_out => fet_pc_out,
                           pc_overwrite_value => sp_pc_dest_addr,
                           pc_overwrite_en => sp_branch_taken_cntrl,
                           clk => clk,
                           reset => reset);
    
    stage_decode : entity work.stage_decode(arch)
                   port map(data_bus => dec_data_bus_in,
                            instr_bus => dec_instr_bus_in,
                            reg_data_1 => dec_reg_data_1_out,
                            reg_data_2 => dec_reg_data_2_out,
                            reg_mem_data => dec_reg_mem_data_out,
                            imm_field_data => dec_imm_field_out,
                            alu_op => dec_alu_op_out,
                            branch_condition => dec_branch_condition_out,
                            prog_flow_cntrl => dec_prog_flow_cntrl_out,
                            sel_immediate => dec_sel_immediate_out,
                            reg_rd_addr_1_out => dec_reg_addr_1,
                            reg_rd_addr_2_out => dec_reg_addr_2,
                            reg_wr_addr_in => wrb_reg_addr_out,
                            reg_wr_addr_out => dec_reg_wr_addr_out,
                            reg_wr_en_dec_out => dec_reg_wr_en_out,
                            reg_rd_1_used => dec_reg_1_used,
                            reg_rd_2_used => dec_reg_2_used,
                            reg_wr_en => wrb_reg_we,
                            sel_mem_output => dec_sel_mem_output_out,
                            clk => clk,
                            reset => reset);
                            
    stage_execute : entity work.stage_execute(arch)
                    port map(reg_data_bus_1 => exe_reg_data_bus_1_in,
                             reg_data_bus_2 => exe_reg_data_bus_2_in,
                             forward_data_em => mem_addr_bus_in,
                             forward_data_mw => wrb_data_bus_out,
                             imm_field_data => exe_alu_imm_data_in,
                             pc_curr_addr => exe_pc_val_in,
                             pc_dest_addr => sp_pc_dest_addr,
                             alu_res_bus => exe_alu_res_out,
                             alu_op => exe_alu_op_in,
                             branch_condition => exe_branch_condition_in,
                             prog_flow_cntrl => exe_prog_flow_cntrl_in,
                             sel_immediate => exe_sel_immediate_in,
                             branch_taken_cntrl => sp_branch_taken_cntrl,
                             em_forward_1 => dec_em_forward_1,
                             em_forward_2 => dec_em_forward_2,
                             mw_forward_1 => dec_mw_forward_1,
                             mw_forward_2 => dec_mw_forward_2);
    
    stage_memory : entity work.stage_memory(arch)
                   port map(mem_data_in => mem_data_bus_in,
                            mem_data_out => mem_data_bus_out,
                            mem_addr_in => mem_addr_bus_in,
                            sel_output => mem_sel_output_in);
    
    -- ============ PIPELINE REGISTER INITIALIZATIONS ============
    reg_fd : entity work.register_var(arch)
             generic map(WIDTH_BITS => 64)
                      -- Datapath data signals in
             port map(d(31 downto 0) => instr_bus,
                      -- Datapath control signals in
                      d(63 downto 32) => fet_pc_out,
                      -- Datapath data signals out
                      q(31 downto 0) => dec_instr_bus_in,
                      -- Datapath control signals out
                      q(63 downto 32) => pt_pc_val_fet,
                      -- Register control
                      clk => clk,
                      reset => pc_reset_fd,
                      en => '1');
    
    reg_de : entity work.register_var(arch)
             generic map(WIDTH_BITS => 177)
                      -- Datapath data signals in
             port map(d(31 downto 0) => dec_reg_data_1_out,
                      d(63 downto 32) => dec_reg_data_2_out,
                      d(95 downto 64) => dec_reg_mem_data_out,
                      d(115 downto 96) => dec_imm_field_out,
                      -- Datapath control signals in
                      d(120 downto 116) => dec_reg_addr_1,
                      d(125 downto 121) => dec_reg_addr_2,
                      d(129 downto 126) => dec_alu_op_out,
                      d(131 downto 130) => dec_prog_flow_cntrl_out,
                      d(136 downto 132) => dec_reg_wr_addr_out,
                      d(168 downto 137) => pt_pc_val_fet,
                      d(171 downto 169) => dec_branch_condition_out,
                      d(172) => dec_reg_wr_en_out,
                      d(173) => dec_sel_immediate_out,
                      d(174) => dec_reg_1_used,
                      d(175) => dec_reg_2_used,
                      d(176) => dec_sel_mem_output_out,
                      -- Datapath data signals out
                      q(31 downto 0) => exe_reg_data_bus_1_in,
                      q(63 downto 32) => exe_reg_data_bus_2_in,
                      q(95 downto 64) => pt_reg_mem_data_exe,
                      q(115 downto 96) => exe_alu_imm_data_in,
                      -- Datapath control signals out
                      q(120 downto 116) => exe_reg_addr_1,
                      q(125 downto 121) => exe_reg_addr_2,
                      q(129 downto 126) => exe_alu_op_in,
                      q(131 downto 130) => exe_prog_flow_cntrl_in,
                      q(136 downto 132) => pt_reg_wr_addr_exe,
                      q(168 downto 137) => exe_pc_val_in,
                      q(171 downto 169) => exe_branch_condition_in,
                      q(172) => pt_reg_wr_en_exe,
                      q(173) => exe_sel_immediate_in,
                      q(174) => exe_reg_1_used,
                      q(175) => exe_reg_2_used,
                      q(176) => pt_mem_sel_output,
                      -- Register control
                      clk => clk,
                      reset => pc_reset_de,
                      en => '1');
                      
    reg_em : entity work.register_var(arch)
             generic map(WIDTH_BITS => 71)
                      -- Datapath data signals in
             port map(d(31 downto 0) => exe_alu_res_out,
                      -- Datapath control signals in
                      d(36 downto 32) => pt_reg_wr_addr_exe,
                      d(68 downto 37) => pt_reg_mem_data_exe,
                      d(69) => pt_reg_wr_en_exe,
                      d(70) => pt_mem_sel_output,
                      -- Datapath data signals out
                      q(31 downto 0) => mem_addr_bus_in,
                      -- Datapath control signals out
                      q(36 downto 32) => pt_reg_wr_addr_mem,
                      q(68 downto 37) => mem_data_bus_in,
                      q(69) => pt_reg_wr_en_mem,
                      q(70) => mem_sel_output_in,
                      -- Register control
                      clk => clk,
                      reset => pc_reset_em,
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
                      reset => pc_reset_mw,
                      en => '1');
                      
    -- Signal assignments
    dec_data_bus_in <= wrb_data_bus_out;
    
    -- Pipeline register control signal assignments
    pc_reset_fd <= reset or sp_branch_taken_cntrl; 
    pc_reset_de <= reset or sp_branch_taken_cntrl; 
    pc_reset_em <= reset; 
    pc_reset_mw <= reset; 
end rtl;


















