----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2021 08:52:13 PM
-- Design Name: 
-- Module Name: register - arch
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

entity register_var is
    generic(
        WIDTH_BITS : integer := 32
    );
    port(
            d : in std_logic_vector(WIDTH_BITS - 1 downto 0);
            q : out std_logic_vector(WIDTH_BITS - 1 downto 0);
            clk : in std_logic;
            reset, en : in std_logic
    );
end register_var;

architecture arch of register_var is

begin
    process(clk)
    begin
        if (rising_edge(clk)) then
            if (reset = '1') then
                q <= (others => '0');
            elsif (en = '1') then
                q <= d;
            end if;
        end if;
    end process;

end arch;











