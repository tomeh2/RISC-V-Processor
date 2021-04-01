----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2021 08:48:38 PM
-- Design Name: 
-- Module Name: cpu - rtl
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

entity cpu is
    port(
        addr_bus : out std_logic_vector(31 downto 0);      -- Address busses for reading memory locations (HARVARD ARCH.)
                     
        data_bus : inout std_logic_vector(31 downto 0);                         -- Data bus for reading/writing memory or I/O devices
        
        clk_temp : in std_logic;
        
        reset : in std_logic
        
        
        );
end cpu;

architecture rtl of cpu is
    signal i_instr_addr_bus : std_logic_vector(31 downto 0);
    signal i_instr_bus : std_logic_vector(31 downto 0);
begin
        core : entity work.core(rtl)
               port map(instr_addr_bus => i_instr_addr_bus,
                        instr_bus => i_instr_bus,
                        data_bus => "00000000000000000000000000000000",
                        clk => clk_temp,
                        reset => reset);

        program_rom : entity work.rom_memory(memory)
                  port map(read_addr => i_instr_addr_bus(7 downto 0),
                           data_out => i_instr_bus);

end rtl;









