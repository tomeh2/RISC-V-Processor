----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2021 10:41:40 PM
-- Design Name: 
-- Module Name: address_generation_unit_tb - Behavioral
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

entity address_generation_unit_tb is
--  Port ( );
end address_generation_unit_tb;

architecture Behavioral of address_generation_unit_tb is
    constant T : time := 20ns;

    signal pc_value, pc_dest_addr : std_logic_vector(31 downto 0);
    signal imm_field_data : std_logic_vector(19 downto 0);
    signal prog_flow_cntrl : std_logic_vector(1 downto 0);
begin
    uut : entity work.address_generation_unit(rtl)
          port map(pc_value => pc_value,
                   imm_field_data => imm_field_data,
                   pc_dest_addr => pc_dest_addr,
                   prog_flow_cntrl => prog_flow_cntrl);
                   
    process
    begin
        pc_value <= x"00000000";
        imm_field_data <= x"00000";
        prog_flow_cntrl <= "00";
        wait for T;
        pc_value <= x"00000004";
        wait for T;
        pc_value <= x"00000008";
        wait for T;
        pc_value <= x"0000000C";
        wait for T;
        pc_value <= x"00000010";
        wait for T;
        pc_value <= pc_dest_addr;
        prog_flow_cntrl <= "01";
        imm_field_data <= "00000000010000000000";
        
        wait for T * 5;
    end process;

end Behavioral;
