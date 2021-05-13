----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/12/2021 08:36:32 PM
-- Design Name: 
-- Module Name: bin_to_hex_sseg_decoder - rtl
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

entity bin_to_hex_sseg_decoder is
    port(
        binary_in : in std_logic_vector(3 downto 0);
        
        sseg_out : out std_logic_vector(7 downto 0)     -- a b c d e f g dp
    );
end bin_to_hex_sseg_decoder;

architecture rtl of bin_to_hex_sseg_decoder is

begin
    with binary_in select sseg_out <= 
        "00000011" when "0000",
        "10011111" when "0001",
        "00100101" when "0010",
        "00001101" when "0011",
        "10011001" when "0100",
        "01001001" when "0101",
        "01000001" when "0110",
        "00011111" when "0111",
        "00000001" when "1000",
        "00001001" when "1001",
        "00010001" when "1010",
        "11000001" when "1011",
        "01100011" when "1100",
        "10000101" when "1101",
        "01100001" when "1110",
        "01110001" when "1111",
        "11111111" when others;

end rtl;






