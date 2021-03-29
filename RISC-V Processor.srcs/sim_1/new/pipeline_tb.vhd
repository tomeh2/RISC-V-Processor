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

    signal clk, reset : std_logic;
begin
    uut : entity work.pipeline(rtl)
          port map(clk => clk,
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
        wait for T * 50;
    end process;
    
--    process
--    begin
--        -- Writing starting values to registers using I-type instructions
--        wait for T * 10;
--        instr_bus <= "00000000101000001000000010010011";        -- ADDI x1, x1, 10
--        wait for T;
--        instr_bus <= "00000001010000010110000100010011";        -- ORI x2, x2, 20
--        wait for T;
--        instr_bus <= "00000000111100100100001000010011";        -- XORI x4, x4, 15
--        wait for T;
--        instr_bus <= "00000000010100101000001010010011";        -- ADDI x5, x5, 5
--        wait for T;
--        instr_bus <= "00000000000000000000000000000000";        -- NOP
--        wait for T * 10;
        
--        instr_bus <= "00000000000100010000000110110011";        -- ADD x3, x2, x1 (x3 = x2 + x1)
--        wait for T;
--        instr_bus <= "01000000010100100000001100110011";        -- SUB x6, x4, x5 (x6 = x4 - x5)
--        wait for T;
--        instr_bus <= "00000000000000000000000000000000";
--        wait for T * 10;
        
--        instr_bus <= "00000000000100111000001110010011";
--        wait for T;
--        instr_bus <= "00000000000100111000001110010011";
--        wait for T;
--        instr_bus <= "00000000000100111000001110010011";
--        wait for T;
--        instr_bus <= "00000000000100111000001110010011";
--        wait for T;
--        instr_bus <= "00000000000100111000001110010011";
--        wait for T;
--        instr_bus <= "00000000000000000000000000000000";
--        wait for T * 10;
        
--        instr_bus <= "00000000101001000000010000010011";        -- ADDI r8, r8, 10
--        wait for T; 
--        instr_bus <= "00000000001001001000010010010011";        -- ADDI r9, r9, 2
--        wait for T; 
--        instr_bus <= "01000000100001000000010000110011";        -- SUB r8, r8, r8
--        wait for T;
--        instr_bus <= "00000000100101000000010000110011";        -- ADD r8, r8, r9
--        wait for T;
--        instr_bus <= "11111111111101000100010000010011";        -- XORI r8, r8, X"FFF"
--        wait for T;
--        instr_bus <= "00000000000000000000000000000000";
--        wait for T * 10;
--    end process;

end Behavioral;














