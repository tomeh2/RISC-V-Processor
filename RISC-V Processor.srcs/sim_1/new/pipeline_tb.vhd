----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2021 08:51:36 PM
-- Design Name: 
-- Module Name: pipeline_tb - Behavioral
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

entity pipeline_tb is
--  Port ( );
end pipeline_tb;

architecture Behavioral of pipeline_tb is
    constant T : time := 20ns;

    signal instr_bus : std_logic_vector(31 downto 0);
    signal clk, reset : std_logic;
begin
    uut : entity work.pipeline(rtl)
          port map(instr_bus_test => instr_bus,
                   clk => clk,
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
        wait for T * 10;
        instr_bus <= "00000000000100010000000110110011";        -- ADD x3, x2, x1 (x3 = x2 + x1)
        wait for T;
        instr_bus <= "01000000010100100000001100110011";        -- SUB x6, x4, x5 (x6 = x4 - x5)
        wait for T;
        instr_bus <= "00000000000000000000000000000000";
        wait for T * 20;
    end process;

end Behavioral;














