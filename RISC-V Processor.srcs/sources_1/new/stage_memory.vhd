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
        
        mem_data_fwd : in std_logic_vector(31 downto 0);
        mem_data_fwd_cntrl, mem_addr_fwd_cntrl : in std_logic;
        
        -- Input / Output control signals
        bus_cntrl_ready : in std_logic;
        size : out std_logic_vector(1 downto 0);
        r_w : out std_logic;
        execute : out std_logic;
        mem_busy : out std_logic;
        mem_wr_cntrl, mem_rd_cntrl : in std_logic
    );
end stage_memory;

-- IMPORTANT!!!!
-- MEMORY STAGE ALSO NEEDS FORWARDING FOR THE REGISTER DATA BUS!!!!!!

architecture arch of stage_memory is
    signal i_bus_cntrl_data_out : std_logic_vector(31 downto 0);
    signal i_mem_data_in : std_logic_vector(31 downto 0);
begin
    mux_sel_out : entity work.mux_2_1(rtl)
                  generic map(WIDTH_BITS => 32)
                  port map(in_0 => mem_addr_in,
                           in_1 => data_bus_in,
                           output => mem_data_out,
                           sel => mem_rd_cntrl);
                           
    mux_data_fwd : entity work.mux_2_1(rtl)
                   generic map(WIDTH_BITS => 32)
                   port map(in_0 => mem_data_in,
                            in_1 => mem_data_fwd,
                            output => i_mem_data_in,
                            sel => mem_data_fwd_cntrl);
                           
    -- Data signals to bus controller
    data_bus_out <= i_mem_data_in;
    addr_bus <= mem_addr_in;
    
    -- Control signals to bus controller                       
    mem_busy <= (not bus_cntrl_ready) and (mem_wr_cntrl or mem_rd_cntrl);
    execute <= mem_wr_cntrl or mem_rd_cntrl;
    size <= "00";
    r_w <= mem_rd_cntrl;
end arch;

















