----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2021 10:37:46 PM
-- Design Name: 
-- Module Name: stage_execute - arch
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

entity stage_execute is
    port(
        -- Input / Output data signals
        reg_data_bus_1, reg_data_bus_2 : in std_logic_vector(31 downto 0);
        alu_res_bus : out std_logic_vector(31 downto 0);
        
        -- Input / Output control signals
        alu_op : in std_logic_vector(3 downto 0)
    );
end stage_execute;

architecture arch of stage_execute is

begin
    alu : entity work.alu(rtl)
          port map(op_1 => reg_data_bus_1,
                   op_2 => reg_data_bus_2,
                   alu_op => alu_op,
                   res => alu_res_bus);

end arch;
