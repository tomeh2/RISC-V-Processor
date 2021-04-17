----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2021 07:32:47 PM
-- Design Name: 
-- Module Name: bus_controller_tb - Behavioral
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

entity bus_controller_tb is
--  Port ( );
end bus_controller_tb;

architecture Behavioral of bus_controller_tb is
    constant T : time := 20ns;

    -- CPU SIDE SIGNALS
    signal data_in, addr_in : std_logic_vector(31 downto 0);
    signal data_out : std_logic_vector(31 downto 0);
    signal ready : std_logic;
    signal r_w : std_logic;
    signal size_in : std_logic_vector(1 downto 0);                 -- Indicates the size of data (in bytes) to be transfered
    signal execute : std_logic;
    
    -- BUS SIDE SIGNALS
    signal data_bus : std_logic_vector(31 downto 0);
    signal addr_bus : std_logic_vector(31 downto 0);
    signal address_strobe : std_logic;
    signal size : std_logic_vector(1 downto 0);
    signal ack : std_logic;

    signal clk, reset : std_logic;
begin
    uut : entity work.bus_controller(rtl)
          port map(data_in => data_in,
                   addr_in => addr_in,
                   data_out => data_out,
                   ready => ready,
                   r_w => r_w,
                   size_in => size_in,
                   execute => execute,
                   data_bus => data_bus,
                   addr_bus => addr_bus,
                   address_strobe => address_strobe,
                   size => size,
                   ack => ack,
                   reset => reset,
                   clk => clk);
                   
    process
    begin
        clk <= '0';
        wait for T / 2;
        clk <= '1';
        wait for T / 2;
    end process;

    process
    begin
        data_in <= X"00000000";
        addr_in <= X"00000000";
        r_w <= '0';
        size_in <= "00";
        execute <= '0';
        
        ack <= '0';
        reset <= '0';
        
        data_bus <= (others => 'Z');
        -- Try writing to bus
        wait for T * 5;
        execute <= '1';
        data_in <= X"0F0F0F0F";
        addr_in <= X"F0F0F0F0";
        size_in <= "01";
        wait for T;
        execute <= '0';
        wait for T * 10;
        ack <= '1';
        wait for T;
        ack <= '0';
        
        -- Try reading from bus
        wait for T * 5;
        r_w <= '1';
        addr_in <= X"FFFF0000";
        size_in <= "11";
        data_bus <= X"AAAAAAAA";
        execute <= '1';
        wait for T;
        execute <= '0';
        wait for T * 10;
        ack <= '1';
        wait for T;
        ack <= '0';
    end process;
end Behavioral;
























