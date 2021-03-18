----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2021 09:13:38 PM
-- Design Name: 
-- Module Name: instruction_decoder_tb - Behavioral
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

entity instruction_decoder_tb is
--  Port ( );
end instruction_decoder_tb;

architecture Behavioral of instruction_decoder_tb is
    signal instr_bus : std_logic_vector(31 downto 0);
    signal reg_rd_addr_1, reg_rd_addr_2, reg_wr_addr : std_logic_vector(4 downto 0);
    signal alu_op : std_logic_vector(3 downto 0);
begin
    uut : entity work.instruction_decoder(rtl)
                 port map(instr_bus => instr_bus,
                          reg_rd_addr_1 => reg_rd_addr_1,
                          reg_rd_addr_2 => reg_rd_addr_2,
                          reg_wr_addr => reg_wr_addr,
                          alu_op => alu_op);
                          
    process
    begin
        -- ADD Instruction
        instr_bus <= "00000001111100001000011100110011";
        wait for 1 ns;
        assert (reg_rd_addr_1 = "00001") report "R1 decoding incorrect" severity failure;
        assert (reg_rd_addr_2 = "11111") report "R2 decoding incorrect" severity failure;
        assert (reg_wr_addr = "01110") report "Rd decoding incorrect" severity failure;
        assert (alu_op = "0000") report "ALU Operation decoding incorrect [ADD]" severity failure;
        wait for 9ns;
        -- SUB Instruction
        instr_bus <= "01000001111100001000011100110011";
        wait for 1 ns;
        assert (reg_rd_addr_1 = "00001") report "R1 decoding incorrect" severity failure;
        assert (reg_rd_addr_2 = "11111") report "R2 decoding incorrect" severity failure;
        assert (reg_wr_addr = "01110") report "Rd decoding incorrect" severity failure;
        assert (alu_op = "1000") report "ALU Operation decoding incorrect [SUB]" severity failure;
        wait for 9ns;
        -- SLL Instruction
        instr_bus <= "00000001111100001001011100110011";
        wait for 1 ns;
        assert (reg_rd_addr_1 = "00001") report "R1 decoding incorrect" severity failure;
        assert (reg_rd_addr_2 = "11111") report "R2 decoding incorrect" severity failure;
        assert (reg_wr_addr = "01110") report "Rd decoding incorrect" severity failure;
        assert (alu_op = "0001") report "ALU Operation decoding incorrect [SLL]" severity failure;
        wait for 9ns;
        -- SLT Instruction
        instr_bus <= "00000001111100001010011100110011";
        wait for 1 ns;
        assert (reg_rd_addr_1 = "00001") report "R1 decoding incorrect" severity failure;
        assert (reg_rd_addr_2 = "11111") report "R2 decoding incorrect" severity failure;
        assert (reg_wr_addr = "01110") report "Rd decoding incorrect" severity failure;
        assert (alu_op = "0010") report "ALU Operation decoding incorrect [SLT]" severity failure;
        wait for 9ns;
        -- SLTU Instruction
        instr_bus <= "00000001111100001011011100110011";
        wait for 1 ns;
        assert (reg_rd_addr_1 = "00001") report "R1 decoding incorrect" severity failure;
        assert (reg_rd_addr_2 = "11111") report "R2 decoding incorrect" severity failure;
        assert (reg_wr_addr = "01110") report "Rd decoding incorrect" severity failure;
        assert (alu_op = "0011") report "ALU Operation decoding incorrect [SLTU]" severity failure;
        wait for 9ns;
        -- XOR Instruction
        instr_bus <= "00000001111100001100011100110011";
        wait for 1 ns;
        assert (reg_rd_addr_1 = "00001") report "R1 decoding incorrect" severity failure;
        assert (reg_rd_addr_2 = "11111") report "R2 decoding incorrect" severity failure;
        assert (reg_wr_addr = "01110") report "Rd decoding incorrect" severity failure;
        assert (alu_op = "0100") report "ALU Operation decoding incorrect [XOR]" severity failure;
        wait for 9ns;
        -- SRL Instruction
        instr_bus <= "00000001111100001101011100110011";
        wait for 1 ns;
        assert (reg_rd_addr_1 = "00001") report "R1 decoding incorrect" severity failure;
        assert (reg_rd_addr_2 = "11111") report "R2 decoding incorrect" severity failure;
        assert (reg_wr_addr = "01110") report "Rd decoding incorrect" severity failure;
        assert (alu_op = "0101") report "ALU Operation decoding incorrect [SRL]" severity failure;
        wait for 9ns;
        -- SRA Instruction
        instr_bus <= "01000001111100001101011100110011";
        wait for 1 ns;
        assert (reg_rd_addr_1 = "00001") report "R1 decoding incorrect" severity failure;
        assert (reg_rd_addr_2 = "11111") report "R2 decoding incorrect" severity failure;
        assert (reg_wr_addr = "01110") report "Rd decoding incorrect" severity failure;
        assert (alu_op = "1101") report "ALU Operation decoding incorrect [SRA]" severity failure;
        wait for 9ns;
        -- OR Instruction
        instr_bus <= "00000001111100001110011100110011";
        wait for 1 ns;
        assert (reg_rd_addr_1 = "00001") report "R1 decoding incorrect" severity failure;
        assert (reg_rd_addr_2 = "11111") report "R2 decoding incorrect" severity failure;
        assert (reg_wr_addr = "01110") report "Rd decoding incorrect" severity failure;
        assert (alu_op = "0110") report "ALU Operation decoding incorrect [OR]" severity failure;
        wait for 9ns;
        -- AND Instruction
        instr_bus <= "00000001111100001111011100110011";
        wait for 1 ns;
        assert (reg_rd_addr_1 = "00001") report "R1 decoding incorrect" severity failure;
        assert (reg_rd_addr_2 = "11111") report "R2 decoding incorrect" severity failure;
        assert (reg_wr_addr = "01110") report "Rd decoding incorrect" severity failure;
        assert (alu_op = "0111") report "ALU Operation decoding incorrect [AND]" severity failure;
        wait for 9ns;
    end process;

end Behavioral;
















