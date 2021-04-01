-- The CPU core consists of a pipeline, local caches (WIP) and allows
-- for the execution of one thread.


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity core is
    port(
        instr_addr_bus, data_addr_bus : out std_logic_vector(31 downto 0);      -- Address busses for reading memory locations (HARVARD ARCH.)
        instr_bus : in std_logic_vector(31 downto 0);                          
        data_bus : inout std_logic_vector(31 downto 0);                         -- Data bus for reading/writing memory or I/O devices
    
        clk, reset : in std_logic
        );
end core;

architecture rtl of core is

begin
    pipeline : entity work.pipeline(rtl)
               port map(instr_addr_bus => instr_addr_bus,
                        data_addr_bus => data_addr_bus,
                        instr_bus => instr_bus,
                        data_bus => data_bus,
                        clk => clk,
                        reset => reset);

    
end rtl;
