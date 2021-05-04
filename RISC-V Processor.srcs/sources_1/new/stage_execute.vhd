----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2021 10:37:46 PM
-- Design Name: 
-- Module Name: stage_execute - arch
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity stage_execute is
    port(
        -- Input / Output data signals
        reg_data_bus_1, reg_data_bus_2 : in std_logic_vector(31 downto 0);
        forward_data_em, forward_data_mw : in std_logic_vector(31 downto 0);
        imm_field_data : in std_logic_vector(19 downto 0);
        alu_res_bus : out std_logic_vector(31 downto 0);
        
        pc_curr_addr : in std_logic_vector(31 downto 0);
        pc_dest_addr : out std_logic_vector(31 downto 0);
        -- Input / Output control signals
        alu_op : in std_logic_vector(3 downto 0);
        prog_flow_cntrl : in std_logic_vector(1 downto 0);             -- Branching control signal
        branch_condition : in std_logic_vector(2 downto 0);
        branch_taken_cntrl : out std_logic;                            -- Tells the pipeline whether the branch has been taken or not
        em_forward_1, em_forward_2 : in std_logic;                     -- Forwards from pipeline register E/M
        mw_forward_1, mw_forward_2 : in std_logic;                     -- Forwards from pipeline register M/W
        sel_immediate : in std_logic;                                  -- Selects whether the input to the ALU comes from the register or immediate value
        sel_big_immediate : in std_logic;
        sel_op_1_pc : in std_logic
    );
end stage_execute;

architecture arch of stage_execute is
    signal i_sign_ext_out : std_logic_vector(31 downto 0);
    signal i_sign_ext_out_shifted : std_logic_vector(31 downto 0);
    signal i_sign_ext_shift_sel_out : std_logic_vector(31 downto 0);
    signal i_alu_op_1, i_alu_op_2 : std_logic_vector(31 downto 0);  -- ALU operand input values
    signal i_alu_res : std_logic_vector(31 downto 0);
    
    -- Control signals multiplexers
    signal i_sel_mux_1 : std_logic_vector(1 downto 0);
    signal i_sel_mux_2 : std_logic_vector(2 downto 0);
    
    -- Control signals for branching
    signal i_branch_base_addr : std_logic_vector(31 downto 0);
    signal i_branch_base_addr_sel : std_logic_vector(1 downto 0);
    
    signal i_branch_en, i_branch_unc : std_logic;
    signal i_alu_comp_res : std_logic;
begin
    alu : entity work.alu(rtl)
          port map(op_1 => i_alu_op_1,
                   op_2 => i_alu_op_2,
                   alu_op => alu_op,
                   res => i_alu_res);
                   
    bu : entity work.branch_unit(rtl)
          port map(base_addr => i_branch_base_addr,
                   imm_field_data => imm_field_data,
                   pc_dest_addr => pc_dest_addr,
                   alu_comp_res => i_alu_comp_res,
                   sel_condition_cntrl => branch_condition,
                   branch_unconditional => i_branch_unc,
                   branch_taken_cntrl => i_branch_en,
                   prog_flow_cntrl => prog_flow_cntrl);
                   
    sign_extender : entity work.sign_extender(rtl)
                    generic map(EXTENDED_SIZE_BITS => 32,
                                IMMEDIATE_SIZE_BITS => 20)
                    port map(immediate_in => imm_field_data,
                             extended_out => i_sign_ext_out);
    
    mux_alu_op_1 : entity work.mux_4_1(rtl)
                   generic map(WIDTH_BITS => 32)
                   port map(in_0 => reg_data_bus_1,
                            in_1 => forward_data_em,
                            in_2 => forward_data_mw,
                            in_3 => pc_curr_addr,
                            output => i_alu_op_1,
                            sel => i_sel_mux_1);
                            
    mux_alu_op_2 : entity work.mux_8_1(rtl) 
                   generic map(WIDTH_BITS => 32)
                   port map(in_0 => reg_data_bus_2,
                            in_1 => forward_data_em,
                            in_2 => forward_data_mw,
                            in_3 => i_sign_ext_out,
                            in_4 => x"00000004",
                            in_5 => i_sign_ext_out_shifted,
                            in_6 => x"00000000",
                            in_7 => x"00000000",
                            output => i_alu_op_2,
                            sel => i_sel_mux_2);
                            
    mux_agu_base_addr : entity work.mux_4_1(rtl)
                        generic map(WIDTH_BITS => 32)
                        port map(in_0 => pc_curr_addr,
                                 in_1 => reg_data_bus_1,
                                 in_2 => forward_data_em,
                                 in_3 => forward_data_mw,
                                 output => i_branch_base_addr,
                                 sel => i_branch_base_addr_sel);
                            
    i_sign_ext_out_shifted <= i_sign_ext_out(19 downto 0) & "000000000000";
                            
    alu_res_bus <= i_alu_res;
                            
    -- Control signal generation for multiplexers
    i_sel_mux_1 <= (((not em_forward_1) and mw_forward_1) or i_branch_unc or sel_op_1_pc) & (em_forward_1 or i_branch_unc or sel_op_1_pc);
    --i_sel_mux_2 <= i_branch_unc & (mw_forward_2 or sel_immediate) & ((em_forward_2 and not mw_forward_2) or sel_immediate);
    i_sel_mux_2 <= (i_branch_unc or sel_big_immediate) & (mw_forward_2 or sel_immediate) & ((em_forward_2 and not mw_forward_2) or sel_immediate or sel_big_immediate);
    
    i_alu_comp_res <= i_alu_res(0);
    
    branch_taken_cntrl <= i_branch_en;
    
    -- Branch address calculation base address data source selection signal
    i_branch_base_addr_sel <= (((not em_forward_1) and mw_forward_1 and prog_flow_cntrl(1) and (not prog_flow_cntrl(0))) or (em_forward_1 and (not mw_forward_1) and prog_flow_cntrl(1) and (not prog_flow_cntrl(0)))) &
                              ((not em_forward_1) and prog_flow_cntrl(1) and (not prog_flow_cntrl(0))); 
end arch;














