----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/15/2021 09:36:25 PM
-- Design Name: 
-- Module Name: register_file_tb - Behavioral
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

entity register_file_tb is
--  Port ( );
end register_file_tb;

architecture Behavioral of register_file_tb is
    constant REG_SIZE_BITS_TEST : integer := 32;
    constant T : time := 20ns;

    signal read_addr_1, read_addr_2 : std_logic_vector(4 downto 0);                     
    signal write_addr : std_logic_vector(4 downto 0);                              
        
        -- Data busses
    signal wr_data : std_logic_vector(REG_SIZE_BITS_TEST - 1 downto 0);                      
    signal rd_data_1, rd_data_2 : std_logic_vector(REG_SIZE_BITS_TEST - 1 downto 0);       
        
        -- Control busses
    signal reset : std_logic;                                                           
    signal clk : std_logic;                                                             
    signal wr_en : std_logic;                                                           
begin
    uut : entity work.register_file(rtl)
          generic map(REG_SIZE_BITS => REG_SIZE_BITS_TEST)
          port map(rd_addr_1 => read_addr_1,
                   rd_addr_2 => read_addr_2,
                   wr_addr => write_addr,
                   wr_data => wr_data,
                   rd_data_1 => rd_data_1,
                   rd_data_2 => rd_data_2,
                   reset => reset,
                   clk => clk,
                   wr_en => wr_en);

    process
    begin
        clk <= '0';
        wait for T / 2;
        clk <= '1';
        wait for T / 2;
    end process;
    
    process
    begin
        reset <= '1';
        read_addr_1 <= "00000";
        read_addr_2 <= "00000";
        wait until falling_edge(clk);
        reset <= '0';
        wr_data <= X"FFFFFFFF";
        wr_en <= '1';
        write_addr <= "00000";
        wait until rising_edge(clk);
        wr_data <= X"FFFFFFFF";
        wr_en <= '1';
        write_addr <= "00001";
        wait until rising_edge(clk);
        wr_data <= X"F0F0F0F0";
        wr_en <= '1';
        write_addr <= "11111";
        wait until rising_edge(clk);
        wr_data <= X"ABCDEF00";
        wr_en <= '1';
        write_addr <= "00011";
        wait until rising_edge(clk);
        wr_data <= X"00000000";
        wr_en <= '1';
        write_addr <= "00011";
        wait until rising_edge(clk);
        wr_en <= '0';
        read_addr_1 <= "00000";
        read_addr_2 <= "00001";
        wait until rising_edge(clk);
        wr_en <= '0';
        read_addr_1 <= "11111";
        read_addr_2 <= "00011";
        wait until rising_edge(clk);
    end process;

end Behavioral;











