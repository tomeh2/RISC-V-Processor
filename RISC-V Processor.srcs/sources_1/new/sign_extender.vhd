----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/22/2021 08:31:25 PM
-- Design Name: 
-- Module Name: sign_extender - rtl
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

entity sign_extender is
    generic(
        EXTENDED_SIZE_BITS : integer;
        IMMEDIATE_SIZE_BITS : integer
    );
    port(
        immediate_in : in std_logic_vector(IMMEDIATE_SIZE_BITS - 1 downto 0);
        extended_out : out std_logic_vector(EXTENDED_SIZE_BITS - 1 downto 0)
    );
end sign_extender;

architecture rtl of sign_extender is

begin
    GEN_EXTENDER:
    for i in 0 to EXTENDED_SIZE_BITS - IMMEDIATE_SIZE_BITS generate
        extended_out((EXTENDED_SIZE_BITS - 1) - i) <= immediate_in(IMMEDIATE_SIZE_BITS - 1);
    end generate GEN_EXTENDER;
    
    extended_out((IMMEDIATE_SIZE_BITS - 2) downto 0) <= immediate_in((IMMEDIATE_SIZE_BITS - 2) downto 0);
end rtl;














