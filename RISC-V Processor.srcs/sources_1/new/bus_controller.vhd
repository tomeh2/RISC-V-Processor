----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/13/2021 10:29:53 PM
-- Design Name: 
-- Module Name: bus_controller - rtl
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

entity bus_controller is
    port(
        -- CPU SIDE SIGNALS
        data_in, addr_in : in std_logic_vector(31 downto 0);
        data_out : out std_logic_vector(31 downto 0);
        ready : out std_logic;
        r_w : in std_logic;
        size_in : in std_logic_vector(1 downto 0);                 -- Indicates the size of data (in bytes) to be transfered
        execute : in std_logic;
        
        -- BUS SIDE SIGNALS
        data_bus : inout std_logic_vector(31 downto 0);
        addr_bus : out std_logic_vector(31 downto 0);
        r_w_bus : out std_logic;
        address_strobe : out std_logic;
        size : out std_logic_vector(1 downto 0);
        ack : in std_logic;
        
        -- CONTROL SIGNALS
        clk, reset : in std_logic
    );
end bus_controller;

architecture rtl of bus_controller is
    type state_type is (INACTIVE,
                        -- Read states
                        SR_SET_ADDR,
                        SR_SET_STROBE,
                        SR_WAIT_ACK,
                        SR_FINALIZE,
                        -- Write states
                        SW_SET_ADDR_DATA,
                        SW_SET_STROBE,
                        SW_WAIT_ACK,
                        SW_FINALIZE
                        );
                        
    signal i_state, i_next : state_type;
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
    process(ack, execute, r_w, clk)
    begin
        if (i_state = INACTIVE) then
            if (execute = '1') then
                if (r_w = '0') then
                    i_next <= SW_SET_ADDR_DATA;
                else
                    i_next <= SR_SET_ADDR;
                end if;
            else
                i_next <= INACTIVE;
            end if; 
            
        -- Reading from the bus
        elsif (i_state = SR_SET_ADDR) then
            i_next <= SR_SET_STROBE;
        elsif (i_state = SR_SET_STROBE) then
            i_next <= SR_WAIT_ACK;
        elsif (i_state = SR_WAIT_ACK) then
            if (ack = '0') then
                i_next <= SR_WAIT_ACK;
            else
                i_next <= SR_FINALIZE;
            end if;
        elsif (i_state = SR_FINALIZE) then
            i_next <= INACTIVE;
            
        -- Writing to the bus
        elsif (i_state = SW_SET_ADDR_DATA) then
            i_next <= SW_SET_STROBE;
        elsif (i_state = SW_SET_STROBE) then
            i_next <= SW_WAIT_ACK;
        elsif (i_state = SW_WAIT_ACK) then
            if (ack = '0') then
                i_next <= SW_WAIT_ACK;
            else
                i_next <= SW_FINALIZE;
            end if;
        elsif (i_state = SW_FINALIZE) then
            i_next <= INACTIVE;
        end if;
    end process;
    
    -- Outputs
    process(i_state)
    begin
        if (i_state = INACTIVE) then
            data_out <= (others => '0');
            ready <= '0';
            data_bus <= (others => 'Z');
            addr_bus <= (others => '0');
            r_w_bus <= '0';
            address_strobe <= '0';
            size <= "00";
            
        -- Reading from the bus
        elsif (i_state = SR_SET_ADDR) then
            data_out <= (others => '0');
            ready <= '0';
            data_bus <= (others => 'Z');
            addr_bus <= addr_in;
            r_w_bus <= r_w;
            address_strobe <= '0';
            size <= size_in;
        elsif (i_state = SR_SET_STROBE) then
            data_out <= (others => '0');
            ready <= '0';
            data_bus <= (others => 'Z');
            addr_bus <= addr_in;
            r_w_bus <= r_w;
            address_strobe <= '1';
            size <= size_in;
        elsif (i_state = SR_WAIT_ACK) then
            data_out <= (others => '0');
            ready <= '0';
            data_bus <= (others => 'Z');
            addr_bus <= addr_in;
            r_w_bus <= r_w;
            address_strobe <= '1';
            size <= size_in;
        elsif (i_state = SR_FINALIZE) then
            data_out <= data_bus;
            ready <= '1';
            addr_bus <= addr_in;
            r_w_bus <= r_w;
            address_strobe <= '1';
            size <= size_in;
        
        -- Writing to the bus
        elsif (i_state = SW_SET_ADDR_DATA) then
            data_out <= (others => '0');
            ready <= '0';
            data_bus <= data_in;
            addr_bus <= addr_in;
            r_w_bus <= r_w;
            address_strobe <= '0';
            size <= size_in;
        elsif (i_state = SW_SET_STROBE) then
            data_out <= (others => '0');
            ready <= '0';
            data_bus <= data_in;
            addr_bus <= addr_in;
            r_w_bus <= r_w;
            address_strobe <= '1';
            size <= size_in;
        elsif (i_state = SW_WAIT_ACK) then
            data_out <= (others => '0');
            ready <= '0';
            data_bus <= data_in;
            addr_bus <= addr_in;
            r_w_bus <= r_w;
            address_strobe <= '1';
            size <= size_in;
        elsif (i_state = SW_FINALIZE) then
            data_out <= (others => '0');
            ready <= '1';
            data_bus <= data_in;
            addr_bus <= addr_in;
            r_w_bus <= r_w;
            address_strobe <= '1';
            size <= size_in;
        else
            data_out <= (others => '0');
            ready <= '0';
            data_bus <= (others => 'Z');
            addr_bus <= (others => '0');
            r_w_bus <= '0';
            address_strobe <= '0';
            size <= "00";
        end if;
    end process;
end rtl;































