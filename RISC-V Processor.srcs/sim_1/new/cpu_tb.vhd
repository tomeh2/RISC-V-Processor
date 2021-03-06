----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2021 09:11:00 PM
-- Design Name: 
-- Module Name: cpu_tb - Behavioral
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

entity cpu_tb is
end cpu_tb;

architecture Behavioral of cpu_tb is
    constant T : time := 20ns;

    signal addr_bus, data_bus_in, data_bus_out : std_logic_vector(31 downto 0);
    signal clk, reset, ack_bus, r_w_bus, as, ack_bus_tb, ack_bus_led : std_logic;
    signal sw_test_reg : std_logic_vector(31 downto 0);
    
    signal led : std_logic_vector(15 downto 0);
begin
    uut : entity work.cpu(rtl)
          port map(addr_bus => addr_bus,
                   data_bus_in => data_bus_in,
                   data_bus_out => data_bus_out,
                   clk_temp => clk,
                   CLK100MHZ => '0',
                   address_strobe => as,
                   r_w_bus => r_w_bus,
                   ack_bus => ack_bus,
                   reset => reset);
                   
--    uut_led : entity work.led_interface(rtl)
--              port map(addr_bus => addr_bus,
--                       data_bus => data_bus,
--                       led_out => led,
--                       address_strobe => as,
--                       r_w => r_w_bus,
--                       ack => ack_bus_led,
--                       clk => clk,
--                       reset => reset);
                   
    reset <= '1', '0' after T * 2;
                   
    process
    begin
        clk <= '0';
        wait for T / 2;
        clk <= '1';
        wait for T / 2;
    end process;
    
    process
    begin
        addr_bus <= (others => 'Z');
        ack_bus_tb <= '0';
        
        wait until addr_bus = X"FFFFF000";
        data_bus_in <= X"0000FFFF";
        ack_bus_tb <= '1';
        wait for T * 3;
        ack_bus_tb <= '0';
        wait for T;
        wait for T * 20;
        ack_bus_tb <= '1';
        wait for T * 3;
        ack_bus_tb <= '0';
    end process;
    
    ack_bus <= ack_bus_tb or '0';

end Behavioral;















