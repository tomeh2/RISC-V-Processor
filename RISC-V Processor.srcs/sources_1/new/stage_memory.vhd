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
        data_bus_in : in std_logic_vector(31 downto 0);
        data_bus_out : out std_logic_vector(31 downto 0)
        
        -- Input / Output control signals
    );
end stage_memory;

architecture arch of stage_memory is

begin
    data_bus_out <= data_bus_in;            -- Temporary until memory controller gets implemented (allows ALU operations on registers for testing)

end arch;
