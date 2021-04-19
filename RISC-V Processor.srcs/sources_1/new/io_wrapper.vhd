----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2021 07:37:24 PM
-- Design Name: 
-- Module Name: io_wrapper - wrapper
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

entity io_wrapper is
    port(
        LED : out std_logic_vector(15 downto 0);
        SW : in std_logic_vector(15 downto 0);
    
        CLK100MHZ : in std_logic
    );
end io_wrapper;

architecture wrapper of io_wrapper is
    signal i_temp : std_logic_vector(31 downto 0);
    
    signal i_data_bus, i_addr_bus : std_logic_vector(31 downto 0);
    signal i_r_w_bus, i_ack_bus, i_address_strobe : std_logic;
    signal i_size_bus : std_logic_vector(1 downto 0);
begin
    cpu : entity work.cpu(rtl)
          port map(data_bus => i_data_bus,
                   addr_bus => i_addr_bus,
                   ack_bus => i_ack_bus,
                   r_w_bus => i_r_w_bus,
                   address_strobe => i_address_strobe,
                   size_bus => i_size_bus,
                   clk_temp => CLK100MHZ,
                   reset => SW(0));
                   
    led_device : entity work.led_interface(rtl)
                 port map(data_bus => i_data_bus,
                          addr_bus => i_addr_bus,
                          r_w => i_r_w_bus,
                          ack => i_ack_bus,
                          address_strobe => i_address_strobe,
                          clk => CLK100MHZ,
                          reset => SW(0));

    LED <= i_temp(15 downto 0);

end wrapper;













