----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/11/2021 09:22:13 PM
-- Design Name: 
-- Module Name: barrel_shifter_tb - Behavioral
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

entity barrel_shifter_tb is
--  Port ( );
end barrel_shifter_tb;

architecture Behavioral of barrel_shifter_tb is
    signal data_in, data_out : std_logic_vector(31 downto 0);
    signal shift_ammount : std_logic_vector(4 downto 0);
    signal shift_arith : std_logic;
    signal shift_direction : std_logic;
begin
    uut : entity work.barrel_shifter_32(rtl)
          port map(data_in => data_in,
                   data_out => data_out,
                   shift_arith => shift_arith,
                   shift_ammount => shift_ammount,
                   shift_direction => shift_direction);
                   
    process
    begin
        data_in <= X"FFFFFFFF";
        shift_ammount <= "00000";
        shift_arith <= '0';
        shift_direction <= '0';
        wait for 20ns;
        data_in <= X"FFFFFFFF";
        shift_ammount <= "00001";
        shift_arith <= '0';
        shift_direction <= '0';
        wait for 20ns;
        data_in <= X"FFFFFFFF";
        shift_ammount <= "00010";
        shift_arith <= '0';
        shift_direction <= '0';
        wait for 20ns;
        data_in <= X"FFFFFFFF";
        shift_ammount <= "00100";
        shift_arith <= '0';
        shift_direction <= '0';
        wait for 20ns;
        data_in <= X"FFFFFFFF";
        shift_ammount <= "01000";
        shift_arith <= '0';
        shift_direction <= '0';
        wait for 20ns;
        data_in <= X"FFFFFFFF";
        shift_ammount <= "10000";
        shift_arith <= '0';
        shift_direction <= '0';
        wait for 20ns;
        data_in <= X"FFFFFFFF";
        shift_ammount <= "00011";
        shift_arith <= '0';
        shift_direction <= '0';
        wait for 20ns;
        data_in <= X"FFFFFFFF";
        shift_ammount <= "00111";
        shift_arith <= '0';
        shift_direction <= '0';
        wait for 20ns;
        data_in <= X"FFFFFFFF";
        shift_ammount <= "01111";
        shift_arith <= '0';
        shift_direction <= '0';
        wait for 20ns;
        data_in <= X"FFFFFFFF";
        shift_ammount <= "11111";
        shift_arith <= '0';
        shift_direction <= '0';
        wait for 20ns;
        
        
        
        data_in <= X"FFFFFFFF";
        shift_ammount <= "00000";
        shift_arith <= '0';
        shift_direction <= '1';
        wait for 20ns;
        data_in <= X"FFFFFFFF";
        shift_ammount <= "00001";
        shift_arith <= '0';
        shift_direction <= '1';
        wait for 20ns;
        data_in <= X"FFFFFFFF";
        shift_ammount <= "00010";
        shift_arith <= '0';
        shift_direction <= '1';
        wait for 20ns;
        data_in <= X"FFFFFFFF";
        shift_ammount <= "00100";
        shift_arith <= '0';
        shift_direction <= '1';
        wait for 20ns;
        data_in <= X"FFFFFFFF";
        shift_ammount <= "01000";
        shift_arith <= '0';
        shift_direction <= '1';
        wait for 20ns;
        data_in <= X"FFFFFFFF";
        shift_ammount <= "10000";
        shift_arith <= '0';
        shift_direction <= '1';
        wait for 20ns;
        data_in <= X"FFFFFFFF";
        shift_ammount <= "00011";
        shift_arith <= '0';
        shift_direction <= '1';
        wait for 20ns;
        data_in <= X"FFFFFFFF";
        shift_ammount <= "00111";
        shift_arith <= '0';
        shift_direction <= '1';
        wait for 20ns;
        data_in <= X"FFFFFFFF";
        shift_ammount <= "01111";
        shift_arith <= '0';
        shift_direction <= '1';
        wait for 20ns;
        data_in <= X"FFFFFFFF";
        shift_ammount <= "11111";
        shift_arith <= '0';
        shift_direction <= '1';
        wait for 20ns;
        
        data_in <= X"FF000000";
        shift_ammount <= "00000";
        shift_arith <= '1';
        shift_direction <= '0';
        wait for 20ns;
        data_in <= X"FF000000";
        shift_ammount <= "00001";
        shift_arith <= '1';
        shift_direction <= '0';
        wait for 20ns;
        data_in <= X"FF000000";
        shift_ammount <= "00010";
        shift_arith <= '1';
        shift_direction <= '0';
        wait for 20ns;
        data_in <= X"FF000000";
        shift_ammount <= "00100";
        shift_arith <= '1';
        shift_direction <= '0';
        wait for 20ns;
        data_in <= X"FF000000";
        shift_ammount <= "01000";
        shift_arith <= '1';
        shift_direction <= '0';
        wait for 20ns;
        data_in <= X"FF000000";
        shift_ammount <= "10000";
        shift_arith <= '1';
        shift_direction <= '0';
        wait for 20ns;
        data_in <= X"FF000000";
        shift_ammount <= "00011";
        shift_arith <= '1';
        shift_direction <= '0';
        wait for 20ns;
        data_in <= X"FF000000";
        shift_ammount <= "00111";
        shift_arith <= '1';
        shift_direction <= '0';
        wait for 20ns;
        data_in <= X"FF000000";
        shift_ammount <= "01111";
        shift_arith <= '1';
        shift_direction <= '0';
        wait for 20ns;
        data_in <= X"FF000000";
        shift_ammount <= "11111";
        shift_arith <= '1';
        shift_direction <= '0';
        wait for 20ns;
    end process;


end Behavioral;












