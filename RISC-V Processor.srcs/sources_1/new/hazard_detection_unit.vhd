----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/22/2021 10:42:02 PM
-- Design Name: 
-- Module Name: hazard_detection_unit - rtl
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

-- Hazard detection signals are named depending on where (in what pipeline register) the needed data is located

entity hazard_detection_unit is
    port(
        -- Input control signals
        de_reg_src_addr_1, de_reg_src_addr_2 : in std_logic_vector(4 downto 0);
        em_reg_dest_addr, mw_reg_dest_addr : in std_logic_vector(4 downto 0);
        
        -- Output control signals
        em_hazard_src_1, em_hazard_src_2 : out std_logic;       -- "_src_1" and "_src_2" specify what source register caused the hazard to trigger
        mw_hazard_src_1, mw_hazard_src_2 : out std_logic
    );
end hazard_detection_unit;

architecture rtl of hazard_detection_unit is

begin
    process(all)
    begin
        if (de_reg_src_addr_1 = em_reg_dest_addr) then
            em_hazard_src_1 <= '1';
            em_hazard_src_2 <= '0';
            mw_hazard_src_1 <= '0';
            mw_hazard_src_2 <= '0';
        elsif (de_reg_src_addr_2 = em_reg_dest_addr) then
            em_hazard_src_1 <= '0';
            em_hazard_src_2 <= '1';
            mw_hazard_src_1 <= '0';
            mw_hazard_src_2 <= '0';
        elsif (de_reg_src_addr_1 = mw_reg_dest_addr) then
            em_hazard_src_1 <= '0';
            em_hazard_src_2 <= '0';
            mw_hazard_src_1 <= '1';
            mw_hazard_src_2 <= '0';
        elsif (de_reg_src_addr_2 = mw_reg_dest_addr) then
            em_hazard_src_1 <= '0';
            em_hazard_src_2 <= '0';
            mw_hazard_src_1 <= '0';
            mw_hazard_src_2 <= '1';
        else
            em_hazard_src_1 <= '0';
            em_hazard_src_2 <= '0';
            mw_hazard_src_1 <= '0';
            mw_hazard_src_2 <= '0';
        end if;
    end process;

end rtl;










