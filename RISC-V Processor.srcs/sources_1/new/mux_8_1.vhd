----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2021 07:52:27 PM
-- Design Name: 
-- Module Name: mux_8_1 - rtl
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

entity mux_8_1 is
    generic(
        WIDTH_BITS : integer
    );
    port(
        in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7 : in std_logic_vector(WIDTH_BITS - 1 downto 0);
        output : out std_logic_vector(WIDTH_BITS - 1 downto 0);
        sel : in std_logic_vector(2 downto 0)
    );
end mux_8_1;

architecture rtl of mux_8_1 is

begin
    with sel select output <=
        in_0 when "000",
        in_1 when "001",
        in_2 when "010",
        in_3 when "011",
        in_4 when "100",
        in_5 when "101",
        in_6 when "110",
        in_7 when "111",
        (others => '0') when others;

end rtl;









