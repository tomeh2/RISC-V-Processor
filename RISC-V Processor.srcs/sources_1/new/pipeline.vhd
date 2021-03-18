----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2021 10:55:59 PM
-- Design Name: 
-- Module Name: pipeline - rtl
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

-- Signal naming convention:
-- signal [First 3 letters of the module]_[Signal name]_[In / Out]

entity pipeline is
--  Port ( );
end pipeline;

architecture rtl of pipeline is
    -- DECODE STAGE SIGNALS
    signal dec_data_bus_in, dec_instr_bus_in : std_logic_vector(31 downto 0);
    signal dec_reg_data_1_out, dec_reg_data_2_out : std_logic_vector(31 downto 0);
    signal dec_alu_op_out : std_logic_vector(3 downto 0);
    
    -- GLOBAL CONTROL SIGNALS
    signal clk, reset : std_logic;
    
begin
    -- ================== STAGE INITIALIZATIONS ==================
    stage_decode : entity work.stage_decode(arch)
                   port map(data_bus => dec_data_bus_in,
                            instr_bus => dec_instr_bus_in,
                            reg_data_1 => dec_reg_data_1_out,
                            reg_data_2 => dec_reg_data_2_out,
                            alu_op => dec_alu_op_out,
                            clk => clk,
                            reset => reset);
    
    -- ============ PIPELINE REGISTER INITIALIZATIONS ============
    reg_de : entity work.register_var
             generic map(WIDTH_BITS => 68)
                      -- Datapath data signals
             port map(d(31 downto 0) => dec_reg_data_1_out,
                      d(63 downto 32) => dec_reg_data_2_out,
                      -- Datapath control signals
                      d(67 downto 64) => dec_alu_op_out,
                      -- Register control
                      clk => clk,
                      reset => reset,
                      en => '1');
    
end rtl;


















