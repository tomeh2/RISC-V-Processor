----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2021 10:48:20 PM
-- Design Name: 
-- Module Name: stage_memory - arch
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

entity stage_memory is
    port(
        -- Input / Output data signals
        addr_bus, data_bus_out : out std_logic_vector(31 downto 0);         -- Signals for the bus controller
        data_bus_in : in std_logic_vector(31 downto 0);
        
        mem_data_in, mem_addr_in : in std_logic_vector(31 downto 0);
        mem_data_out : out std_logic_vector(31 downto 0);
        
        -- Input / Output control signals
        bus_cntrl_ready : in std_logic;
        size : out std_logic_vector(1 downto 0);
        r_w : out std_logic;
        execute : out std_logic;
        mem_busy : out std_logic;
        sel_output : in std_logic                                       -- Selects the output between ALU and memory 
    );
end stage_memory;

architecture arch of stage_memory is
    signal i_bus_cntrl_data_out : std_logic_vector(31 downto 0);
begin
    mux_sel_out : entity work.mux_2_1(rtl)
                  generic map(WIDTH_BITS => 32)
                  port map(in_0 => mem_addr_in,
                           in_1 => X"00000000",
                           output => mem_data_out,
                           sel => sel_output);
                           
    mem_busy <= '0';
    execute <= '0';
end arch;

















