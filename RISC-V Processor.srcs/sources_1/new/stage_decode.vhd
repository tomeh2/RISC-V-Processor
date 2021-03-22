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
        alu_imm_data : out std_logic_vector(11 downto 0);               -- Immediate values that are meant to be processed in the alu
        
        -- Input / Output control signals
        alu_op : out std_logic_vector (3 downto 0);
        reg_wr_addr_out : out std_logic_vector(4 downto 0);
        reg_wr_en_dec_out : out std_logic;                              -- Register write enable signal decoder output
        
        reg_wr_addr_in : in std_logic_vector(4 downto 0);               -- Register write address signal used to address the register file (comes from the writeback stage)
        reg_wr_en : in std_logic;                                       -- Register write enable signal used to control the register file (comes from the writeback stage)
        
        clk, reset : in std_logic
    );
end stage_decode;

architecture arch of stage_decode is
    signal i_reg_rd_addr_1, i_reg_rd_addr_2 : std_logic_vector(4 downto 0);
begin
    instruction_decoder : entity work.instruction_decoder
                          port map(instr_bus => instr_bus,
                                   alu_immediate_bus => alu_imm_data,
                                   alu_op => alu_op,
                                   reg_rd_addr_1 => i_reg_rd_addr_1,
                                   reg_rd_addr_2 => i_reg_rd_addr_2,
                                   reg_wr_addr => reg_wr_addr_out,
                                   reg_wr_en => reg_wr_en_dec_out);
                                   
    register_file : entity work.register_file
                    port map(rd_addr_1 => i_reg_rd_addr_1,
                             rd_addr_2 => i_reg_rd_addr_2,
                             rd_data_1 => reg_data_1,
                             rd_data_2 => reg_data_2,
                             wr_en => reg_wr_en,
                             wr_addr => reg_wr_addr_in,
                             wr_data => data_bus,      
                             reset => reset,                
                             clk => clk);
                             
    

end arch;












