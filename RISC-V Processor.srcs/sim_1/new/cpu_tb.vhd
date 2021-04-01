----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2021 09:11:00 PM
-- Design Name: 
-- Module Name: cpu_tb - Behavioral
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

entity cpu_tb is
end cpu_tb;

architecture Behavioral of cpu_tb is
    constant T : time := 20ns;

    signal addr_bus, data_bus : std_logic_vector(31 downto 0);
    signal clk, reset : std_logic;
begin
    uut : entity work.cpu(rtl)
          port map(addr_bus => addr_bus,
                   data_bus => data_bus,
                   clk_temp => clk,
                   reset => reset);
                   
    reset <= '1', '0' after T * 2;
                   
    process
    begin
        clk <= '0';
        wait for T / 2;
        clk <= '1';
        wait for T / 2;
    end process;
    
    process
    begin
        addr_bus <= (others => '0');
        data_bus <= (others => '0');
        wait for T * 50;
    end process;

end Behavioral;















