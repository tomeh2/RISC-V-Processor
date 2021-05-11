----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2021 09:07:57 PM
-- Design Name: 
-- Module Name: led_interface - rtl
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

entity led_interface is
    port(
        -- Board connections
        led_out : out std_logic_vector(15 downto 0);
        
        -- CPU bus interface signals
        addr_bus : in std_logic_vector(31 downto 0);
        data_bus : inout std_logic_vector(31 downto 0);
        ack : out std_logic;
        r_w, address_strobe : in std_logic;
        
        clk, reset : in std_logic
    );
end led_interface;

architecture rtl of led_interface is
    type state_type is (INACTIVE,
                        READ_ACTIVE);

    signal i_state, i_next : state_type;
    
    signal i_data_register : std_logic_vector(31 downto 0);
    signal i_data_register_write : std_logic;
    
    signal i_enable_read : std_logic;
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
    process(clk, i_enable_read, address_strobe)
    begin
        if (i_state = INACTIVE) then
            if (address_strobe = '1') then
                if (i_enable_read = '1' and r_w = '0') then
                    i_next <= READ_ACTIVE;
                else
                    i_next <= INACTIVE;
                end if;
            else
                i_next <= INACTIVE;
            end if;
        elsif (i_state = READ_ACTIVE) then
            if (address_strobe = '1') then
                i_next <= READ_ACTIVE;                 -- TESTING (ORIG: i_next <= READ_ACTIVE)
            else
                i_next <= INACTIVE;
            end if;
        end if;
    end process;
    
    -- SM Outputs
    process(i_state)
    begin
        if (i_state = INACTIVE) then
            ack <= '0';
            i_data_register_write <= '0';
        else
            ack <= '1';
            i_data_register_write <= '1';
        end if;
    end process;
    
    process(all)
    begin
        if (reset = '1') then
            i_data_register <= X"00000000";
        elsif (i_data_register_write = '1') then
            i_data_register <= data_bus;
        end if;
    end process;

    -- Address decoder
    with addr_bus select i_enable_read <=
        '1' when X"FFFFFF00",
        '0' when others;
        
    -- LED signal generation
    led_out <= i_data_register(15 downto 0);
end rtl;







