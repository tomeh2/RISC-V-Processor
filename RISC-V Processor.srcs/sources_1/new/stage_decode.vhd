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
        data_bus, instr_bus : in std_logic_vector(31 downto 0);
        reg_data_1, reg_data_2 : out std_logic_vector(31 downto 0);
        
        -- Input / Output control signals
        clk, reset : in std_logic;
        alu_op : out std_logic_vector (3 downto 0)
    );
end stage_decode;

architecture arch of stage_decode is
    signal i_alu_op : std_logic_vector(3 downto 0);
    signal i_reg_rd_addr_1, i_reg_rd_addr_2, i_reg_wr_addr : std_logic_vector(4 downto 0);
    signal i_reg_wr_en : std_logic;
begin
    instruction_decoder : entity work.instruction_decoder
                          port map(instr_bus => instr_bus,
                                   alu_op => i_alu_op,
                                   reg_rd_addr_1 => i_reg_rd_addr_1,
                                   reg_rd_addr_2 => i_reg_rd_addr_2,
                                   reg_wr_addr => i_reg_wr_addr,
                                   reg_wr_en => i_reg_wr_en);
                                   
    register_file : entity work.register_file
                    port map(rd_addr_1 => i_reg_rd_addr_1,
                             rd_addr_2 => i_reg_rd_addr_2,
                             wr_en => i_reg_wr_en,
                             wr_addr => i_reg_wr_addr,
                             wr_data => data_bus,      
                             reset => reset,                
                             clk => clk);

end arch;












