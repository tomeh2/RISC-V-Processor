-- The CPU core consists of a pipeline, local caches (WIP) and allows
-- for the execution of one thread.


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity core is
    port(
        CLK100MHZ : in std_logic;
    
        instr_addr_bus, addr_bus : out std_logic_vector(31 downto 0);      -- Address busses for reading memory locations (HARVARD ARCH.)
        instr_bus : in std_logic_vector(31 downto 0);                          
        data_bus_out : out std_logic_vector(31 downto 0);                           -- Data bus for reading/writing memory or I/O devices
        data_bus_in : in std_logic_vector(31 downto 0);
        size_bus : out std_logic_vector(1 downto 0);
        bus_cntrl_ready : in std_logic;
        r_w : out std_logic;
        execute : out std_logic;
    
        clk, reset : in std_logic
        );
end core;

architecture rtl of core is

begin
    pipeline : entity work.pipeline(rtl)
               port map(instr_addr_bus => instr_addr_bus,
                        addr_bus => addr_bus,
                        instr_bus => instr_bus,
                        data_bus_out => data_bus_out,
                        data_bus_in => data_bus_in,
                        size_bus => size_bus,
                        bus_cntrl_ready => bus_cntrl_ready,
                        r_w => r_w,
                        execute => execute,
                        clk => clk,
                        CLK100MHZ => CLK100MHZ,
                        reset => reset);

    
end rtl;
