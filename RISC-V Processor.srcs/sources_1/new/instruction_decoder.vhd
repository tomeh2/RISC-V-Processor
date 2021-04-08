----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2021 08:41:55 PM
-- Design Name: 
-- Module Name: instruction_decoder - rtl
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

entity instruction_decoder is
    port(
        instr_bus : in std_logic_vector(31 downto 0);         
        
        -- Generated data signals     
        imm_field_data : out std_logic_vector(19 downto 0);
        
        -- Generated output control signals
        
        alu_op : out std_logic_vector(3 downto 0);                                          -- Decoded ALU operation
        prog_flow_cntrl : out std_logic_vector(1 downto 0);                                 -- Determines whether to branch and what type of branch it is (00 - NO BRANCH | 01 - UNCOND_1 | 10 - UNCOND_2 | 11 - COND)
        reg_rd_addr_1, reg_rd_addr_2, reg_wr_addr : out std_logic_vector(4 downto 0);       -- Decoded register selection addresses
        reg_rd_1_used, reg_rd_2_used : out std_logic;                                       -- Specifies whether 
        reg_wr_en : out std_logic;                                                          -- Register write enable control signal
        sel_immediate : out std_logic                                                       -- Selects whether the second ALU operand is from a register or immediate
    );
end instruction_decoder;

architecture rtl of instruction_decoder is

begin
    process(all)
    begin
        -- Sets all outputs to zero to make sure that they don't have stray (or old) values
        alu_op <= (others => '0');
        reg_wr_en <= '0';
        sel_immediate <= '0';
        reg_rd_1_used <= '0';
        reg_rd_2_used <= '0';
        prog_flow_cntrl <= "00";
        
        -- Register addresses are always decoded, but not used unless needed to simplify decoding
        reg_rd_addr_1 <= instr_bus(19 downto 15);
        reg_rd_addr_2 <= instr_bus(24 downto 20);
        reg_wr_addr <= instr_bus(11 downto 7);
        
        -- Immediates are always decoded, but not used unless specified by the instruction
        imm_field_data <= (others => '0');
        
        -- ALU Operation decoding
        if (instr_bus(6 downto 0) = "0110011") then
            alu_op <= instr_bus(30) & instr_bus(14 downto 12);
            
            reg_rd_1_used <= '1';
            reg_rd_2_used <= '1';
            reg_wr_en <= '1';
        elsif (instr_bus(6 downto 0) = "0010011") then
            alu_op <= '0' & instr_bus(14 downto 12);
            imm_field_data <= "00000000" & instr_bus(31 downto 20);
            
            reg_rd_1_used <= '1';
            reg_rd_2_used <= '0';
            reg_wr_en <= '1';
            sel_immediate <= '1';
        elsif (instr_bus(6 downto 0) = "1101111") then
            alu_op <= "0000";
            imm_field_data <= instr_bus(31 downto 12);
            
            reg_wr_en <= '1';
            prog_flow_cntrl <= "01";
        elsif (instr_bus(6 downto 0) = "1100111") then
            alu_op <= "0000";
            imm_field_data <= "00000000" & instr_bus(31 downto 20);
            
            reg_rd_1_used <= '1';
            reg_wr_en <= '1';
            prog_flow_cntrl <= "10";
        else 
            alu_op <= "0000";
        end if;
    end process;

end rtl;














