----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2021 08:57:28 PM
-- Design Name: 
-- Module Name: register_var_tb - Behavioral
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

entity register_var_tb is
--  Port ( );
end register_var_tb;

architecture Behavioral of register_var_tb is
    constant T : time := 20ns;
    signal d, q : std_logic_vector(63 downto 0);
    signal clk, rst, en : std_logic;
begin
    uut : entity work.register_var
                 generic map(WIDTH_BITS => 64)
                 port map(d => d,
                          q => q,
                          clk => clk,
                          rst => rst,
                          en => en);

    process
    begin
        clk <= '0';
        wait for T / 2;
        clk <= '1';
        wait for T / 2;
    end process;
    
    process
    begin
        rst <= '1';
        wait for T;
        wait for 1ns;
        rst <= '0';
        d <= X"FFFF_FFFF_FFFF_FFFF";
        en <= '1';
        wait until rising_edge(clk);
        wait for 1ns;
        assert (q = X"FFFF_FFFF_FFFF_FFFF") report "Unexpected register value" severity failure;
        d <= X"F0F0_F0F0_F0F0_F0F0";
        en <= '0';
        wait until rising_edge(clk);
        wait for 1ns;
        assert (q = X"FFFF_FFFF_FFFF_FFFF") report "Unexpected register value" severity failure;
        wait until rising_edge(clk);
        
    end process;

end Behavioral;













