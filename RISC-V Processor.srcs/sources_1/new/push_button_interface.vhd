----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2021 09:13:07 PM
-- Design Name: 
-- Module Name: push_button_interface - rtl
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

entity push_button_interface is
    port(
        -- Board connections
        buttons : in std_logic_vector(4 downto 0);
            
        -- CPU bus interface signals
        addr_bus : in std_logic_vector(31 downto 0);
        data_bus : inout std_logic_vector(31 downto 0);
        ack : out std_logic;
        r_w, address_strobe : in std_logic;
            
        clk, clk_ila, reset : in std_logic
    );
end push_button_interface;

architecture rtl of push_button_interface is
    COMPONENT button_device_ila

    PORT (
        clk : IN STD_LOGIC;
    
    
        probe0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        probe1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0)
    );
    END COMPONENT  ;

    type state_type is (INACTIVE,
                        WRITE_ACTIVE);
    
    signal i_data_register : std_logic_vector(7 downto 0);
    signal i_enable_read : std_logic;
    signal i_enable_data_reg_wr : std_logic;
    
    signal i_next, i_state : state_type;
begin
    -- State register
    process(clk)
    begin
        if (rising_edge(clk)) then
            if (reset = '1') then
                i_state <= INACTIVE;
            else
                i_state <= i_next;
            end if;
        end if;
    end process;
    
    -- Next-state logic
    process(all)
    begin
        if (i_state = INACTIVE) then
            if (address_strobe = '1') then
                if (i_enable_read = '1' and r_w = '1') then
                    i_next <= WRITE_ACTIVE;
                else
                    i_next <= INACTIVE;
                end if;
            end if;
        elsif (i_state = WRITE_ACTIVE) then
            if (address_strobe = '1') then
                i_next <= WRITE_ACTIVE;
            else
                i_next <= INACTIVE;
            end if;
        end if;
    end process;
    
    -- SM Outputs
    process(all)
    begin
        if (i_state = INACTIVE) then
            ack <= '0';
            data_bus <= (others => '0');
        elsif (i_state = WRITE_ACTIVE) then
            ack <= '1';
            data_bus <= X"000000" & i_data_register;
        end if;
    end process;
    
    -- Update bus interface data register
    process(clk)
    begin
        if (rising_edge(clk)) then
            if (i_enable_read = '0') then
                i_data_register <= "000" & buttons;
            end if;
        end if;
    end process;
    
    
    
    i_enable_data_reg_wr <= not address_strobe;
    
    with addr_bus select i_enable_read <=
        '1' when X"FFFFFF10",
        '0' when others;

    bdi : button_device_ila
    PORT MAP (
        clk => clk_ila,
    
    
    
        probe0 => i_data_register,
        probe1(0) => i_enable_read
    );

end rtl;
