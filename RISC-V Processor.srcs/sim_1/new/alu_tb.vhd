----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2021 07:43:19 PM
-- Design Name: 
-- Module Name: alu_tb - Behavioral
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

entity alu_tb is
--  Port ( );
end alu_tb;

architecture Behavioral of alu_tb is
    signal alu_op : std_logic_vector(3 downto 0);
    signal op_1, op_2 : std_logic_vector(31 downto 0);
    signal res : std_logic_vector(31 downto 0);
begin
    uut : entity work.alu(rtl)
          generic map(OPERAND_WIDTH_BITS => 32)
          port map(alu_op => alu_op,
                   op_1 => op_1,
                   op_2 => op_2,
                   res => res);
                   
    process
    begin
        -- ADD
        alu_op <= "0000";
        op_1 <= X"0000_0000";
        op_2 <= X"0000_FFFF";
        wait for 1ns;
        assert (res = X"0000_FFFF") report "ADD: Result incorrect" severity failure;
        wait for 9ns;
        op_1 <= X"0000_FFFF";
        op_2 <= X"0000_FFFF";
        wait for 1ns;
        assert (res = X"0001_FFFE") report "ADD: Result incorrect" severity failure;
        wait for 9ns;
        op_1 <= X"0000_0001";
        op_2 <= X"FFFF_FFFF";
        wait for 1ns;
        assert (res = X"0000_0000") report "ADD: Result incorrect" severity failure;
        wait for 9ns;
        -- SLL (Shift Left Logical)
        alu_op <= "0001";
        op_1 <= X"0000_0000";
        op_2 <= X"0000_0000";
        wait for 1ns;
        assert (res = X"0000_0000") report "SLL: Result incorrect" severity failure;
        wait for 9ns;
        op_1 <= X"0000_0001";
        op_2 <= X"0000_0000";
        wait for 1ns;
        assert (res = X"0000_0002") report "SLL: Result incorrect" severity failure;
        wait for 9ns;
        op_1 <= X"F000_0000";
        op_2 <= X"0000_0000";
        wait for 1ns;
        assert (res = X"E000_0000") report "SLL: Result incorrect" severity failure;
        wait for 9ns;
        -- SLT (Set on Less Then)
        alu_op <= "0010";
        op_1 <= X"0000_0000";
        op_2 <= X"0000_0000";
        wait for 1ns;
        assert (res = X"0000_0000") report "SLT: Result incorrect" severity failure;
        wait for 9ns;
        op_1 <= X"0000_000F";
        op_2 <= X"0000_0000";
        wait for 1ns;
        assert (res = X"0000_0000") report "SLT: Result incorrect" severity failure;
        wait for 9ns;
        op_1 <= X"0000_0000";
        op_2 <= X"0000_000F";
        wait for 1ns;
        assert (res = X"0000_0001") report "SLT: Result incorrect" severity failure;
        wait for 9ns;
        op_1 <= X"8000_0000";
        op_2 <= X"0000_0000";
        wait for 1ns;
        assert (res = X"0000_0001") report "SLT: Result incorrect" severity failure;
        wait for 9ns;
        -- SLTU (Set on Less Then Unsigned)
        alu_op <= "0011";
        op_1 <= X"0000_0000";
        op_2 <= X"0000_0000";
        wait for 1ns;
        assert (res = X"0000_0000") report "SLTU: Result incorrect" severity failure;
        wait for 9ns;
        op_1 <= X"0000_000F";
        op_2 <= X"0000_0000";
        wait for 1ns;
        assert (res = X"0000_0000") report "SLTU: Result incorrect" severity failure;
        wait for 9ns;
        op_1 <= X"0000_0000";
        op_2 <= X"0000_000F";
        wait for 1ns;
        assert (res = X"0000_0001") report "SLTU: Result incorrect" severity failure;
        wait for 9ns;
        -- XOR
        alu_op <= "0100";
        op_1 <= X"0F0F_FFFF";
        op_2 <= X"F0F0_FFFF";
        wait for 1ns;
        assert (res = X"FFFF_0000") report "XOR: Result incorrect" severity failure;
        wait for 9ns;
        -- SRL (Shift Right Logical)
        alu_op <= "0101";
        op_1 <= X"0000_0001";
        op_2 <= X"0000_0000";
        wait for 1ns;
        assert (res = X"0000_0000") report "SRL: Result incorrect" severity failure;
        wait for 9ns;
        op_1 <= X"0000_0002";
        op_2 <= X"0000_0000";
        wait for 1ns;
        assert (res = X"0000_0001") report "SRL: Result incorrect" severity failure;
        wait for 9ns;
        op_1 <= X"FFFF_FFFF";
        op_2 <= X"0000_0000";
        wait for 1ns;
        assert (res = X"7FFF_FFFF") report "SRL: Result incorrect" severity failure;
        wait for 9ns;
        -- OR
        alu_op <= "0110";
        op_1 <= X"F0F0_F0F0";
        op_2 <= X"FFFF_0000";
        wait for 1ns;
        assert (res = X"FFFF_F0F0") report "OR: Result incorrect" severity failure;
        wait for 9ns;
        -- AND
        alu_op <= "0111";
        op_1 <= X"FFFF_0000";
        op_2 <= X"F0F0_F0F0";
        wait for 1ns;
        assert (res = X"F0F0_0000") report "AND: Result incorrect" severity failure;
        wait for 9ns;
        -- SUB
        alu_op <= "1000";
        op_1 <= X"0000_FFFF";
        op_2 <= X"0000_FFFF";
        wait for 1ns;
        assert (res = X"0000_0000") report "SUB: Result incorrect" severity failure;
        wait for 9ns;
        op_1 <= X"0000_0000";
        op_2 <= X"0000_0001";
        wait for 1ns;
        assert (res = X"FFFF_FFFF") report "SUB: Result incorrect" severity failure;
        wait for 9ns;
        op_1 <= X"FFFF_FFFF";
        op_2 <= X"0001_FFFF";
        wait for 1ns;
        assert (res = X"FFFE_0000") report "SUB: Result incorrect" severity failure;
        wait for 9ns;
        -- SRA (Shift Right Arithmetic)
        alu_op <= "1101";
        op_1 <= X"F000_0000";
        op_2 <= X"0000_0000";
        wait for 1ns;
        assert (res = X"F800_0000") report "SRA: Result incorrect" severity failure;
        wait for 9ns;
        wait;
    end process;

end Behavioral;















