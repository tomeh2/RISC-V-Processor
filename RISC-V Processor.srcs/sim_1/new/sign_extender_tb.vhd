----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/22/2021 08:38:51 PM
-- Design Name: 
-- Module Name: sign_extender_tb - Behavioral
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

entity sign_extender_tb is
--  Port ( );
end sign_extender_tb;

architecture Behavioral of sign_extender_tb is
    signal immediate : std_logic_vector(11 downto 0);
    signal extended : std_logic_vector(31 downto 0);
begin
    uut : entity work.sign_extender(rtl)
          generic map(IMMEDIATE_SIZE_BITS => 12,
                      EXTENDED_SIZE_BITS => 32)
          port map(immediate_in => immediate,
                   extended_out => extended);
                   
    process
    begin
        immediate <= "000000000000";
        wait for 1ns;
        assert (extended = X"00000000") report "Sign extension failed!" severity failure;
        immediate <= "100000000000";
        wait for 1ns;
        assert (extended = X"FFFFF800") report "Sign extension failed!" severity failure;
        immediate <= "101010101010";
        wait for 1ns;
        assert (extended = X"FFFFFAAA") report "Sign extension failed!" severity failure;
        immediate <= "010101010101";
        wait for 1ns;
        assert (extended = X"00000555") report "Sign extension failed!" severity failure;
    end process;

end Behavioral;











