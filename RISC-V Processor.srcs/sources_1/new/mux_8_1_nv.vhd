library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- The only difference between this mux and the other 8-to-1 mux is that this
-- one uses std_logic objects for I/O and not std_logic_vector

entity mux_8_1_nv is
    port(
        in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7 : in std_logic;
        output : out std_logic;
        sel : in std_logic_vector(2 downto 0)
    );
end mux_8_1_nv;

architecture rtl of mux_8_1_nv is

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
        '0' when others;

end rtl;
