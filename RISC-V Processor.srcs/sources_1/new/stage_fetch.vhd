----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2021 10:46:29 PM
-- Design Name: 
-- Module Name: stage_fetch - arch
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity stage_fetch is
    port(
        instr_bus : out std_logic_vector(31 downto 0);
    
        clk, reset : in std_logic
    );
end stage_fetch;

architecture arch of stage_fetch is
    constant PC_WIDTH_BITS : integer := 8;

    signal i_pc_out, i_pc_in : std_logic_vector(PC_WIDTH_BITS - 1 downto 0);
begin
    program_counter : entity work.register_var(arch)
                      generic map(WIDTH_BITS => PC_WIDTH_BITS)
                      port map(q => i_pc_in,
                               d => i_pc_out,
                               clk => clk,
                               reset => reset,
                               en => '1');
                               
    program_rom : entity work.rom_memory(memory)
                  port map(read_addr => i_pc_out,
                           data_out => instr_bus);
    
    -- Next instruction address logic                    
    i_pc_in <= std_logic_vector(unsigned(i_pc_out) + 4);

end arch;
