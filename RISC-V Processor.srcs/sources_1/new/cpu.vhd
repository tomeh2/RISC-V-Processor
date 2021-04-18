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
        data_bus : inout std_logic_vector(31 downto 0);    -- Data bus for reading/writing memory or I/O devices
        address_strobe : out std_logic;
        r_w_bus : out std_logic;
        size_bus : out std_logic_vector(1 downto 0);
        ack_bus : in std_logic;
        
        clk_temp : in std_logic;
        
        reset : in std_logic
        
        
        );
end cpu;

architecture rtl of cpu is
    signal i_instr_addr_bus : std_logic_vector(31 downto 0);
    signal i_instr_bus : std_logic_vector(31 downto 0);
    
    signal i_addr_bus, i_data_bus_out, i_data_bus_in : std_logic_vector(31 downto 0);
    signal i_bus_cntrl_ready : std_logic;
    signal i_size_bus : std_logic_vector(1 downto 0);
    signal i_r_w : std_logic;
    signal i_execute : std_logic;
begin
            -- BUS CONTROLLER ENTITY
    bus_controller : entity work.bus_controller(rtl)
                     port map(data_in => i_data_bus_out,
                              addr_in => i_addr_bus,
                              data_out => i_data_bus_in,
                              ready => i_bus_cntrl_ready,
                              r_w => i_r_w,
                              size_in => i_size_bus,
                              execute => i_execute,
                              
                              -- Output bus side
                              data_bus => data_bus,
                              addr_bus => addr_bus,
                              r_w_bus => r_w_bus,
                              address_strobe => address_strobe,
                              size => size_bus,
                              ack => ack_bus,
                              
                              clk => clk_temp,
                              reset => reset);

    core : entity work.core(rtl)
           port map(instr_addr_bus => i_instr_addr_bus,
                    instr_bus => i_instr_bus,
                    addr_bus => i_addr_bus,
                    data_bus_out => i_data_bus_out,
                    data_bus_in => i_data_bus_in,
                    size_bus => i_size_bus,
                    bus_cntrl_ready => i_bus_cntrl_ready,
                    r_w => i_r_w,
                    execute => i_execute,
                    clk => clk_temp,
                    reset => reset);

    program_rom : entity work.rom_memory(memory)
              port map(read_addr => i_instr_addr_bus(7 downto 0),
                       data_out => i_instr_bus);

end rtl;









