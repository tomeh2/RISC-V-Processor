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
        CLK100MHZ : std_logic
    );
end io_wrapper;

architecture wrapper of io_wrapper is

begin
    cpu : entity work.cpu(rtl)
          port map(data_bus => x"00000000",
                   clk_temp => CLK100MHZ,
                   reset => '0');

end wrapper;
