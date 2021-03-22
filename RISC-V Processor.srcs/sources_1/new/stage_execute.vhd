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
        alu_imm_data_bus : in std_logic_vector(11 downto 0);
        alu_res_bus : out std_logic_vector(31 downto 0);
        
        -- Input / Output control signals
        alu_op : in std_logic_vector(3 downto 0);
        sel_immediate : in std_logic                                -- Selects whether the input to the ALU comes from the register or immediate value
    );
end stage_execute;

architecture arch of stage_execute is
    signal i_sign_ext_out : std_logic_vector(31 downto 0);
    signal i_alu_op_2 : std_logic_vector(31 downto 0);
begin
    alu : entity work.alu(rtl)
          port map(op_1 => reg_data_bus_1,
                   op_2 => i_alu_op_2,
                   alu_op => alu_op,
                   res => alu_res_bus);
                   
    sign_extender : entity work.sign_extender(rtl)
                    generic map(EXTENDED_SIZE_BITS => 32,
                                IMMEDIATE_SIZE_BITS => 12)
                    port map(immediate_in => alu_imm_data_bus,
                             extended_out => i_sign_ext_out);
    
    -- This mux selects whether the second operant to the ALU comes from the register of an immediate value
    mux_alu_op_2 : entity work.mux_2_1(rtl)
                   generic map(WIDTH_BITS => 32)
                   port map(in_0 => reg_data_bus_2,
                            in_1 => i_sign_ext_out,
                            output => i_alu_op_2,
                            sel => sel_immediate);
end arch;














