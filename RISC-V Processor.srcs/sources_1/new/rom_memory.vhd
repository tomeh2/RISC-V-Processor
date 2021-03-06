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
--    signal rom_mem : rom_type := (
--        0 => "00000000101000001000000010010011",
--        1 => "00000001010000010110000100010011",
--        2 => "00000000111100100100001000010011",
--        3 => "00000000010100101000001010010011",
--        4 => "00000000000000000000000000000000",
--        5 => "00000000000100010000000110110011",
--        6 => "01000000010100100000001100110011",
--        7 => "00000000000000000000000000000000",
--        8 => "00000000000100111000001110010011",
--        9 => "00000000000100111000001110010011",
--        10 => "00000000000100111000001110010011",
--        11 => "00000000000100111000001110010011",
--        12 => "00000000000100111000001110010011",
--        13 => "00000000000000000000000000000000",
--        14 => "00000000101001000000010000010011",
--        15 => "00000000001001001000010010010011",
--        16 => "01000000100001000000010000110011",
--        17 => "00000000100101000000010000110011",
--        18 => "11111111111101000100010000010011",
--        19 => "00000000000000000000000000000000",
--        20 => "00000000000000000000000000000000",
   
--        -- Conditional Branching Tests
--        21 => "00000000010101100000011000010011",       -- ADDI x12, x12, 5
--        22 => "00000000000101101000011010010011",       -- ADDI x13, x13, 1
--        23 => "11111110110101100101111011100011",       -- BGT x12, x13, -2
        
--        -- Load Instruction Tests
--        26 => "11110000000001110000011100010011",       -- ADDI x14, x14, X(FFFFFF00)
--        --30 => "00000000000001111010100000000011",       -- LW x15, 0(x14) 
         
--        -- Store Instruction Tests
--        --31 => "00000000111001110010000000100011",       -- SW x14, 0(x14)
        
--        -- LUI Instruction Tests
--        34 => "11111111111111111111100010110111",       -- LUI x17, X(FFFFF)
--        35 => "00000000000000001111100100010111",       -- AUIPC x18, X(0000F)
         
--        -- Load Instruction Forwarding Tests
--        40 => "01111111111101111000011110010011",       -- ADDI x15, x15, 2047
--        --41 => "00000000000001111010100000000011",       -- LW x15, 0(x15)
--        --41 => "00000000111101111010000000100011",       -- SW x15, 0(x15)
         
--        42 => "11111111111111111111101000110111",       -- LUI x20, X(FFFFF)
--        43 => "11111111111111111111101010110111",       -- LUI x21, X(FFFFF)
--        44 => "00000000011110100001101000010011",       -- SLLI x20, x20, 7
--        45 => "00000000011110101101101010010011",
        
--        50 => "11111111111111111111101010110111",       -- LUI x21, X(FFFFF)
--        51 => "00000000000010101010101100000011",       -- LW x22, 0(x21)
--        52 => "00000000000110110000101100010011",       -- ADDI x22, x22, 1
         
--        -- Unconditional Branching Tests
--        60 => "00000000000000000000000000000000",
--        61 => "00000000000101010000010100010011",
--        62 => "11111111110111111111010111101111",       -- JAL r?, -2
--        others => (others => '0')
--        );

--    Simple counter with output on LEDs
--    signal rom_mem : rom_type := (
--        0 => "11110010000000001000000010010011",          -- ADDI x1, x1, X(FFFFFF20)
--        1 => "00000000000000010000001000110111",          -- LUI x4, X(00080)
        
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

--    LEDs react to button pushing
--    signal rom_mem : rom_type := (
--        0 => "11110010000000011000000110010011",            -- ADDI x3, X(F20)      LED Address / display address
--        1 => "11110001000000100000001000010011",            -- ADDI x4, X(F10)      Button Address
--        2 => "00000000000000010000000010110111",            -- LUI x1, X(00010) 
--        3 => "00000000000000010111000100010011",            -- ANDI x2, x2, 0
--        4 => "00000000000100010000000100010011",            -- ADDI x2, x2, 1       Wait loop
--        5 => "11111110000100010100111011100011",            -- BLT x2, x1, -4       
--        --5 => X"00000000",
--        6 => "00000000000000100010001010000011",            -- LB x5, x4(0)         Load button values 
        
--        10 => "00000001000000101111001010010011",           -- ANDI x5, x5, X(010)
--        11 => "11111110010100110000011011100011",           -- BEQ x5, x6, -20
--        -- MOV Pseudoinstruction
--        12 => "00000000000000110111001100010011",           -- ANDI x6, x6, 0
--        13 => "00000000011000101110001100110011",           -- OR x6, x5, x6  
        
--        14 => "00000000000100111000001110010011",           -- ADDI x7, x7, 1
--        15 => "00000000011100011010000000100011",           -- SW x7, x3(0)         Display pushed buttons on LEDs
--        16 => "11111101100111111111111111101111",           -- JAL x31, -40
--        others => (others => '0')
--    );

    signal rom_mem : rom_type := (
        
        others => (others => '0')
    );

begin
    shifted_addr <= "00" & read_addr(7 downto 2);
    data_out <= rom_mem(to_integer(unsigned(shifted_addr)));
end memory;
