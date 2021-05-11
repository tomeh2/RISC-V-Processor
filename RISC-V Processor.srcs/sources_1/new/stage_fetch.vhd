----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2021 10:46:29 PM
-- Design Name: 
-- Module Name: stage_fetch - arch
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity stage_fetch is
    port(
        CLK100MHZ : in std_logic;
    
        instr_addr_bus : out std_logic_vector(31 downto 0); -- Instruction and data address busses
        pc_out : out std_logic_vector(31 downto 0);         -- Contents of the program counter
    
        pc_overwrite_value : in std_logic_vector(31 downto 0);
        pc_overwrite_en : in std_logic;
        pc_count_en : in std_logic;
    
        clk, reset : in std_logic
    );
end stage_fetch;

architecture arch of stage_fetch is
    -- ========== DEBUGGING ==========
    COMPONENT ila_0

    PORT (
        clk : IN STD_LOGIC;
    
    
    
        probe0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        probe1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        probe2 : IN STD_LOGIC_VECTOR(0 DOWNTO 0)
    );
    END COMPONENT  ;
    
    constant PC_WIDTH_BITS : integer := 32;

    signal i_pc_out, i_pc_in : std_logic_vector(PC_WIDTH_BITS - 1 downto 0);
    
    signal temp_clk : std_logic_vector(0 downto 0); 
begin
    program_counter : entity work.register_var(arch)
                      generic map(WIDTH_BITS => PC_WIDTH_BITS)
                      port map(q => i_pc_out,
                               d => i_pc_in,
                               clk => clk,
                               reset => reset,
                               en => '1');
    
    -- Next instruction address logic  
    process(all)
    begin
        if (pc_overwrite_en = '1') then
            i_pc_in <= pc_overwrite_value;
        elsif (pc_count_en = '1') then
            i_pc_in <= std_logic_vector(unsigned(i_pc_out) + 4);
        else
            i_pc_in <= i_pc_out;
        end if;
--        if (pc_count_en = '1') then
--            if (pc_overwrite_en = '1') then
--                i_pc_in <= pc_overwrite_value;
--            else
--                i_pc_in <= std_logic_vector(unsigned(i_pc_out) + 4);
--            end if;
--        else
--            i_pc_in <= i_pc_out;
--        end if;
    end process;
    
    -- Instrcution address bus setting
    instr_addr_bus <= i_pc_out;
    pc_out <= i_pc_out;
    
    temp_clk(0) <= clk;
    
    pc_debug : ila_0
PORT MAP (
	clk => CLK100MHZ,



	probe0 => i_pc_out,
	probe1 => i_pc_in,
	probe2 => temp_clk
);

end arch;







