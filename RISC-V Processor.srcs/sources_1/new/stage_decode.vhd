----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2021 10:47:52 PM
-- Design Name: 
-- Module Name: stage_decode - arch
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

entity stage_decode is
    port(
        -- Input / Output data signals
        data_bus, instr_bus : in std_logic_vector(31 downto 0);         -- Data bus takes in data that is supposed to be written into the register file
        reg_data_1, reg_data_2 : out std_logic_vector(31 downto 0);
        reg_mem_data : out std_logic_vector(31 downto 0);
        imm_field_data : out std_logic_vector(19 downto 0);             -- Immediate values that are meant to be processed in the alu
        
        -- Input / Output control signals
        alu_op : out std_logic_vector (3 downto 0);
        sel_immediate : out std_logic;
        prog_flow_cntrl : out std_logic_vector(1 downto 0); 
        branch_condition : out std_logic_vector(2 downto 0);
        reg_wr_addr_out : out std_logic_vector(4 downto 0);
        reg_wr_en_dec_out : out std_logic;                              -- Register write enable signal decoder output
        reg_rd_addr_1_out, reg_rd_addr_2_out : out std_logic_vector(4 downto 0);
        reg_rd_1_used, reg_rd_2_used : out std_logic;
        mem_data_size : out std_logic_vector(1 downto 0);
        mem_wr_cntrl : out std_logic;
        mem_rd_cntrl : out std_logic;
        
        reg_wr_addr_in : in std_logic_vector(4 downto 0);               -- Register write address signal used to address the register file (comes from the writeback stage)
        reg_wr_en : in std_logic;                                       -- Register write enable signal used to control the register file (comes from the writeback stage)
        
        clk, reset : in std_logic
    );
end stage_decode;

architecture arch of stage_decode is
    -- ========== DEBUG COMPONENTS ==========
    COMPONENT ila_1
    PORT (
        clk : IN STD_LOGIC;
    
    
    
        probe0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
        probe1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
        probe2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
        probe3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
        probe4 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
        probe5 : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
        probe6 : IN STD_LOGIC_VECTOR(0 DOWNTO 0)
    );
    END COMPONENT  ;
    -- ========== END DEBUG COMPONENTS ==========

    signal i_reg_rd_addr_1, i_reg_rd_addr_2 : std_logic_vector(4 downto 0);
    signal i_reg_data_2 : std_logic_vector(31 downto 0);
    
    
    
    signal i_clk_temp : std_logic_vector(0 downto 0);
begin
    instruction_decoder : entity work.instruction_decoder
                          port map(instr_bus => instr_bus,
                                   imm_field_data => imm_field_data,
                                   alu_op => alu_op,
                                   branch_condition => branch_condition,
                                   sel_immediate => sel_immediate,
                                   prog_flow_cntrl => prog_flow_cntrl,
                                   reg_rd_addr_1 => i_reg_rd_addr_1,
                                   reg_rd_addr_2 => i_reg_rd_addr_2,
                                   reg_wr_addr => reg_wr_addr_out,
                                   reg_rd_1_used => reg_rd_1_used,
                                   reg_rd_2_used => reg_rd_2_used,
                                   reg_wr_en => reg_wr_en_dec_out,
                                   mem_data_size => mem_data_size,
                                   mem_wr_cntrl => mem_wr_cntrl,
                                   mem_rd_cntrl => mem_rd_cntrl);
                                   
    register_file : entity work.register_file
                    port map(rd_addr_1 => i_reg_rd_addr_1,
                             rd_addr_2 => i_reg_rd_addr_2,
                             rd_data_1 => reg_data_1,
                             rd_data_2 => i_reg_data_2,
                             wr_en => reg_wr_en,
                             wr_addr => reg_wr_addr_in,
                             wr_data => data_bus,      
                             reset => reset,                
                             clk => clk);
                             
    reg_data_2 <= i_reg_data_2;
    reg_mem_data <= i_reg_data_2;
                             
    reg_rd_addr_1_out <= i_reg_rd_addr_1;
    reg_rd_addr_2_out <= i_reg_rd_addr_2;
    
    
    i_clk_temp(0) <= clk;
    decode_stage_probes : ila_1
    PORT MAP (
        clk => clk,
    
    
    
        probe0 => data_bus, 
        probe1 => instr_bus, 
        probe2 => i_reg_data_2, 
        probe3 => i_reg_data_2, 
        probe4 => i_reg_data_2, 
        probe5 => i_reg_data_2(19 downto 0),
        probe6 => i_clk_temp
);

end arch;












