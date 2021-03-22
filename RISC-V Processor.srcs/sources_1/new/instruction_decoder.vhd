----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2021 08:41:55 PM
-- Design Name: 
-- Module Name: instruction_decoder - rtl
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

entity instruction_decoder is
    port(
        instr_bus : in std_logic_vector(31 downto 0);         
        
        -- Generated data signals     
        alu_immediate_bus : out std_logic_vector(11 downto 0);
        
        -- Generated output control signals
        alu_op : out std_logic_vector(3 downto 0);                                          -- Decoded ALU operation
        reg_rd_addr_1, reg_rd_addr_2, reg_wr_addr : out std_logic_vector(4 downto 0);       -- Decoded register selection addresses
        reg_wr_en : out std_logic;                                                          -- Register write enable control signal
        sel_immediate : out std_logic                                                       -- Selects whether the second ALU operand is from a register or immediate
    );
end instruction_decoder;

architecture rtl of instruction_decoder is

begin
    process(all)
    begin
        -- Sets all outputs to zero to make sure that they don't have stray (or old) values
        alu_op <= (others => '0');
        reg_wr_en <= '0';
        sel_immediate <= '0';
        
        -- Register addresses are always decoded, but not used unless needed to simplify decoding
        reg_rd_addr_1 <= instr_bus(19 downto 15);
        reg_rd_addr_2 <= instr_bus(24 downto 20);
        reg_wr_addr <= instr_bus(11 downto 7);
        
        -- Immediates are always decoded, but not used unless specified by the instruction
        alu_immediate_bus <= instr_bus(31 downto 20);
        
        -- ALU Operation decoding
        if (instr_bus(6 downto 0) = "0110011") then
            alu_op <= instr_bus(30) & instr_bus(14 downto 12);
            reg_wr_en <= '1';
        elsif (instr_bus(6 downto 0) = "0010011") then
            alu_op <= '0' & instr_bus(14 downto 12);
            reg_wr_en <= '1';
            sel_immediate <= '1';
        else 
            alu_op <= "0000";
        end if;
    end process;

end rtl;














