----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/15/2021 10:21:52 PM
-- Design Name: 
-- Module Name: alu - rtl
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
    generic(
        OPERAND_WIDTH_BITS : integer := 32
    );
    port(
        alu_op : in std_logic_vector(3 downto 0);
        op_1, op_2 : in std_logic_vector(OPERAND_WIDTH_BITS - 1 downto 0);              -- Operand inputs
        res : out std_logic_vector(OPERAND_WIDTH_BITS - 1 downto 0)
    );
end alu;

architecture rtl of alu is

begin
    process(all)
    begin
        if (alu_op = "0000") then                                       -- ADD
            res <= std_logic_vector(signed(op_1) + signed(op_2));
        elsif (alu_op = "0001") then                                    -- SLL (Shift Left Logical)
            res <= op_1((OPERAND_WIDTH_BITS - 1) - 1 downto 0) & '0';
        elsif (alu_op = "0010") then                                    -- SLT (Signed Less Then)
            if (signed(op_1) < signed(op_2)) then
                res <= X"00000001";
            else
                res <= X"00000000";
            end if;
        elsif (alu_op = "0011") then                                    -- SLTU (Unsigned Less Then) This instruction implementation is not 100% correct (see spec)
            if (unsigned(op_1) < unsigned(op_2)) then
                res <= X"00000001";
            else
                res <= X"00000000";
            end if;
        elsif (alu_op = "0100") then                                    -- XOR
            res <= op_1 xor op_2;
        elsif (alu_op = "0101") then                                    -- SRL (Shift Right Logical)
            res <= "0" & op_1((OPERAND_WIDTH_BITS - 1) downto 1);
        elsif (alu_op = "0110") then                                    -- OR
            res <= op_1 or op_2;
        elsif (alu_op = "0111") then                                    -- AND
            res <= op_1 and op_2;
        elsif (alu_op = "1000") then                                    -- SUB
            res <= std_logic_vector(signed(op_1) - signed(op_2));
        elsif (alu_op = "1101") then                                    -- SRA (Shift Right Arithmetic)
            res <= op_1(31) & op_1((OPERAND_WIDTH_BITS - 1) downto 1);
        else 
            res <= (others => '0');
        end if;
    end process;

end rtl;
