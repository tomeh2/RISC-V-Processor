----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2021 08:46:26 PM
-- Design Name: 
-- Module Name: numeric_display_interface - rtl
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

entity numeric_display_interface is
    port(
        -- Board connections
        segment_bits : out std_logic_vector(7 downto 0);
        anode_bits : out std_logic_vector(7 downto 0);
            
        -- CPU bus interface signals
        addr_bus, data_bus : in std_logic_vector(31 downto 0);
        ack : out std_logic;
        r_w, address_strobe : in std_logic;
            
        clk, reset : in std_logic
    );
end numeric_display_interface;

architecture rtl of numeric_display_interface is
    signal i_data_register : std_logic_vector(31 downto 0);
begin
    

end rtl;
