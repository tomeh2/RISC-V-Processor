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
        26 => "00000100000001110000011100010011",       -- ADDI x14, x14, 64
        27 => "00000000000001111010100000000011",       -- LW x15, 0(x14) 
         
        -- Unconditional Branching Tests
        30 => "00000000000000000000000000000000",
        31 => "00000000000101010000010100010011",
        32 => "11111111110111111111010111101111",       -- JAL r?, -2
        others => (others => '0')
        );
begin
    shifted_addr <= "00" & read_addr(7 downto 2);
    data_out <= rom_mem(to_integer(unsigned(shifted_addr)));
end memory;
