----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/15/2021 09:11:01 PM
-- Design Name: 
-- Module Name: register_file - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--
-- The register file contains 32 registers with I/O required
-- by the RV32I specification
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity register_file is
    generic(
        REG_SIZE_BITS : integer := 32                                                   -- Number of bits in the registers (XLEN)
    );
    port(
        -- Address busses
        rd_addr_1, rd_addr_2 : in std_logic_vector(4 downto 0);                         -- Register selection address (read)
        wr_addr : in std_logic_vector(4 downto 0);                                      -- Register selection address (write)
        
        -- Data busses
        wr_data : in std_logic_vector(REG_SIZE_BITS - 1 downto 0);                      -- Data input port
        rd_data_1, rd_data_2 : out std_logic_vector(REG_SIZE_BITS - 1 downto 0);        -- Data output ports
        
        -- Control busses
        reset : in std_logic;                                                           -- Sets all registers to 0 when high (synchronous)
        clk : in std_logic;                                                             -- Clock signal input
        clk_debug : in std_logic;
        wr_en : in std_logic                                                            -- Write enable
    );
end register_file;

architecture rtl of register_file is
    COMPONENT registers_ila

    PORT (
        clk : IN STD_LOGIC;
    
    
    
        probe0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
        probe1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
        probe2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
        probe3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
        probe4 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
        probe5 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
        probe6 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        probe7 : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT  ;

    type reg_file_type is array (31 downto 0) of std_logic_vector(REG_SIZE_BITS - 1 downto 0);
    
    signal reg_file : reg_file_type;
begin
    process(all)
    begin
        -- Read from registers
        rd_data_1 <= reg_file(to_integer(unsigned(rd_addr_1)));
        rd_data_2 <= reg_file(to_integer(unsigned(rd_addr_2)));
        
        if (falling_edge(clk)) then
            -- Write to register
            if (reset = '1') then
                reg_file <= (others => (others => '0'));
            else
                if (wr_en = '1' and wr_addr /= "00000") then
                    reg_file(to_integer(unsigned(wr_addr))) <= wr_data;
                end if;
            end if;
        end if;
    end process;
    
    regs_0_to_7 : registers_ila
    PORT MAP (
        clk => clk_debug,
    
        probe0 => reg_file(0), 
        probe1 => reg_file(1), 
        probe2 => reg_file(2), 
        probe3 => reg_file(3), 
        probe4 => reg_file(4), 
        probe5 => reg_file(5), 
        probe6 => reg_file(6),
        probe7 => reg_file(7)
    );
    
end rtl;














