----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2021 08:42:40 PM
-- Design Name: 
-- Module Name: rom_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rom_tb is
--  Port ( );
end rom_tb;

architecture Behavioral of rom_tb is
    constant T : time := 20ns;

    signal addr : std_logic_vector(7 downto 0) := "00000000";
    signal data : std_logic_vector(31 downto 0);
begin
    rom : entity work.rom_memory(memory)
          port map(read_addr => addr,
                   data_out => data);

    process
    begin
        addr <= std_logic_vector(unsigned(addr) + 1);
        wait for T;
    end process;
end Behavioral;









