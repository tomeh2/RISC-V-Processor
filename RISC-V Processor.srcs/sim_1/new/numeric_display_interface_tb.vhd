----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/12/2021 10:29:12 PM
-- Design Name: 
-- Module Name: numeric_display_interface_tb - Behavioral
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

entity numeric_display_interface_tb is
--  Port ( );
end numeric_display_interface_tb;

architecture Behavioral of numeric_display_interface_tb is
    signal data_bus, addr_bus : std_logic_vector(31 downto 0);
    signal ack, r_w, address_strobe, clk, clk_disp, reset : std_logic;
    
    constant T : time := 20ns;
begin
    uut : entity work.numeric_display_interface(rtl)
          port map(data_bus => data_bus,
                   addr_bus => addr_bus,
                   ack => ack,
                   r_w => r_w,
                   address_strobe => address_strobe,
                   clk_ila => '0',
                   clk => clk,
                   clk_disp => clk_disp,
                   reset => reset);
                   
    reset <= '1', '0' after T;
                   
    process
    begin
        clk <= '0';
        clk_disp <= '0';
        wait for T / 2;
        clk <= '1';
        clk_disp <= '1';
        wait for T / 2;
    end process;
    
    process
    begin
        wait for T * 10;
        addr_bus <= X"FFFFFF20";
        data_bus <= X"F0F0F0F0";
        address_strobe <= '1';
        r_w <= '0';
        wait for T * 5;
        address_strobe <= '0';
    end process;

end Behavioral;
















