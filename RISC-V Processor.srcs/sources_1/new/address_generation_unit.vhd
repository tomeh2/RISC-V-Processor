----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2021 09:05:37 PM
-- Design Name: 
-- Module Name: address_generation_unit - rtl
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
use IEEE.NUMERIC_STD.ALL;

entity address_generation_unit is
    port(
        -- Data
        pc_value : in std_logic_vector(31 downto 0);
        imm_field_data : in std_logic_vector(19 downto 0);
        
        pc_dest_addr : out std_logic_vector(31 downto 0);
        -- Control
        prog_flow_cntrl : in std_logic_vector(1 downto 0)
    );
end address_generation_unit;

architecture rtl of address_generation_unit is
    signal i_gen_offset_unc_0_unex : std_logic_vector(20 downto 0);
    signal i_gen_offset_unc_1_unex : std_logic_vector(11 downto 0);
    signal i_gen_offset_cnd_unex : std_logic_vector(12 downto 0);
    signal i_gen_offset_unc_0, i_gen_offset_unc_1, i_gen_offset_cnd : std_logic_vector(31 downto 0);
    signal i_gen_offset : std_logic_vector(31 downto 0);
begin
    mux_offset_gen : entity work.mux_4_1(rtl)
                     generic map(WIDTH_BITS => 32)
                     port map(in_0 => x"00000000",
                              in_1 => i_gen_offset_unc_0,
                              in_2 => i_gen_offset_unc_1,
                              in_3 => i_gen_offset_cnd,
                              output => i_gen_offset,
                              sel => prog_flow_cntrl);
                              
    sign_ext_unc_0 : entity work.sign_extender(rtl)
                     generic map(EXTENDED_SIZE_BITS => 32,
                                 IMMEDIATE_SIZE_BITS => 21)
                     port map(immediate_in => i_gen_offset_unc_0_unex,
                              extended_out => i_gen_offset_unc_0);
                              
    sign_ext_unc_1 : entity work.sign_extender(rtl)
                     generic map(EXTENDED_SIZE_BITS => 32,
                                 IMMEDIATE_SIZE_BITS => 12)
                     port map(immediate_in => i_gen_offset_unc_1_unex,
                              extended_out => i_gen_offset_unc_1);
                              
    sign_ext_cnd : entity work.sign_extender(rtl)
                     generic map(EXTENDED_SIZE_BITS => 32,
                                 IMMEDIATE_SIZE_BITS => 13)
                     port map(immediate_in => i_gen_offset_cnd_unex,
                              extended_out => i_gen_offset_cnd);

    -- Destination address generator
    pc_dest_addr <= std_logic_vector(signed(pc_value) + signed(i_gen_offset));

    -- Offset immediate generator
    i_gen_offset_unc_0_unex <= imm_field_data(19) &
                          imm_field_data(7 downto 0) &
                          imm_field_data(8) &
                          imm_field_data(18 downto 9) &
                          "0";
                          
    i_gen_offset_unc_1_unex <= imm_field_data(11 downto 0);
    
    i_gen_offset_cnd_unex <= imm_field_data(11) &
                             imm_field_data(0) &
                             imm_field_data(10 downto 5) &
                             imm_field_data(4 downto 1) &
                             "0";
                             
    -- Address calculation
    pc_dest_addr <= std_logic_vector(signed(pc_value) + signed(i_gen_offset));
end rtl;






