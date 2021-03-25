----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2021 08:29:21 PM
-- Design Name: 
-- Module Name: forwarding_unit - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- Detects and resolves RAW hazards by generating proper forwarding signals
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

entity forwarding_unit is
    port(
        -- Input control signals
        de_reg_src_addr_1, de_reg_src_addr_2 : in std_logic_vector(4 downto 0);
        de_reg_1_used, de_reg_2_used : in std_logic;
        em_reg_dest_used, mw_reg_dest_used : in std_logic;
        em_reg_dest_addr, mw_reg_dest_addr : in std_logic_vector(4 downto 0);
        
        -- Output control signals
        em_hazard_src_1, em_hazard_src_2 : out std_logic;       -- "_src_1" and "_src_2" specify what source register caused the hazard to trigger
        mw_hazard_src_1, mw_hazard_src_2 : out std_logic
    );
end forwarding_unit;

architecture rtl of forwarding_unit is

begin
    process(all)
    begin
        em_hazard_src_1 <= '0';
        em_hazard_src_2 <= '0';
        mw_hazard_src_1 <= '0';
        mw_hazard_src_2 <= '0';
    
        if (de_reg_src_addr_1 = em_reg_dest_addr and em_reg_dest_addr /= "00000" and de_reg_1_used = '1' and em_reg_dest_used = '1') then
            em_hazard_src_1 <= '1';
            mw_hazard_src_1 <= '0';
        elsif (de_reg_src_addr_2 = em_reg_dest_addr and em_reg_dest_addr /= "00000" and de_reg_2_used = '1' and em_reg_dest_used = '1') then
            em_hazard_src_1 <= '0';
            mw_hazard_src_1 <= '0';
        else
            em_hazard_src_1 <= '0';
            mw_hazard_src_1 <= '0';
        end if;
            
        if (de_reg_src_addr_1 = mw_reg_dest_addr and mw_reg_dest_addr /= "00000" and de_reg_1_used = '1' and mw_reg_dest_used = '1') then
            em_hazard_src_2 <= '0';
            mw_hazard_src_2 <= '0';
        elsif (de_reg_src_addr_2 = mw_reg_dest_addr and mw_reg_dest_addr /= "00000" and de_reg_2_used = '1' and mw_reg_dest_used = '1') then
            em_hazard_src_2 <= '0';
            mw_hazard_src_2 <= '1';
        else
            em_hazard_src_2 <= '0';
            mw_hazard_src_2 <= '0';
        end if;
    end process;

end rtl;
