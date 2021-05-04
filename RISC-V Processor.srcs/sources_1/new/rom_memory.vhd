----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2021 08:29:26 PM
-- Design Name: 
-- Module Name: rom_memory - memory
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

entity rom_memory is
    generic(
        ADDR_WIDTH_BITS : integer := 8;
        DATA_WIDTH_BITS : integer := 32
    );
    port(
        read_addr : in std_logic_vector(ADDR_WIDTH_BITS - 1 downto 0);
        data_out : out std_logic_vector(DATA_WIDTH_BITS - 1 downto 0)
    );
end rom_memory;

architecture memory of rom_memory is
    type rom_type is array (0 to 2 ** ADDR_WIDTH_BITS) of std_logic_vector(DATA_WIDTH_BITS - 1 downto 0);
    
    signal shifted_addr : std_logic_vector(ADDR_WIDTH_BITS - 1 downto 0);
--    TEST PROGRAM FOR SIMULATION
    signal rom_mem : rom_type := (
        0 => "00000000101000001000000010010011",
        1 => "00000001010000010110000100010011",
        2 => "00000000111100100100001000010011",
        3 => "00000000010100101000001010010011",
        4 => "00000000000000000000000000000000",
        5 => "00000000000100010000000110110011",
        6 => "01000000010100100000001100110011",
        7 => "00000000000000000000000000000000",
        8 => "00000000000100111000001110010011",
        9 => "00000000000100111000001110010011",
        10 => "00000000000100111000001110010011",
        11 => "00000000000100111000001110010011",
        12 => "00000000000100111000001110010011",
        13 => "00000000000000000000000000000000",
        14 => "00000000101001000000010000010011",
        15 => "00000000001001001000010010010011",
        16 => "01000000100001000000010000110011",
        17 => "00000000100101000000010000110011",
        18 => "11111111111101000100010000010011",
        19 => "00000000000000000000000000000000",
        20 => "00000000000000000000000000000000",
   
        -- Conditional Branching Tests
        21 => "00000000010101100000011000010011",       -- ADDI x12, x12, 5
        22 => "00000000000101101000011010010011",       -- ADDI x13, x13, 1
        23 => "11111110110101100101111011100011",       -- BGT x12, x13, -2
        
        -- Load Instruction Tests
        26 => "11110000000001110000011100010011",       -- ADDI x14, x14, X(FFFFFF00)
        --30 => "00000000000001111010100000000011",       -- LW x15, 0(x14) 
         
        -- Store Instruction Tests
        31 => "00000000111001110010000000100011",       -- SW x14, 0(x14)
         
        -- Load Instruction Forwarding Tests
        40 => "01111111111101111000011110010011",       -- ADDI x15, x15, 2047
        41 => "00000000000001111010100000000011",       -- LW x15, 0(x15)
        --41 => "00000000111101111010000000100011",       -- SW x15, 0(x15)
         
        -- Unconditional Branching Tests
        50 => "00000000000000000000000000000000",
        51 => "00000000000101010000010100010011",
        52 => "11111111110111111111010111101111",       -- JAL r?, -2
        others => (others => '0')
        );

--    signal rom_mem : rom_type := (
--        0 => "11110000000000001000000010010011",          -- ADDI x1, x1, X(FFFFFF00)
--        1 => "01111111111100100000001000010011",          -- ADDI x4, x4, 2048
        
--        -- INCREMENT VALUE
--        4 => "00000000000100010000000100010011",          -- ADDI x2, x2, 1
--        8 => "00000000001000001010000000100011",          -- SW x2, 0(x1)
        
--        -- WAIT LOOP INSTRUCTIONS
--        12 => "00000000000100011000000110010011",         -- ADDI x3, x3, 1
--        16 => "11111110010000011100100011100011",         -- BLT x3, x4, -16
--        20 => "00000000000000011111000110010011",         -- ANDI x3, x3, 0
--        24 => "11111011000111111111011111101111",         -- JAL x15, -80
--        others => (others => '0')
--    );

begin
    shifted_addr <= "00" & read_addr(7 downto 2);
    data_out <= rom_mem(to_integer(unsigned(shifted_addr)));
end memory;
