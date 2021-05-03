----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2021 07:37:24 PM
-- Design Name: 
-- Module Name: io_wrapper - wrapper
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

entity io_wrapper is
    port(
        LED : out std_logic_vector(15 downto 0);
        SW : in std_logic_vector(15 downto 0);
    
        CLK100MHZ : in std_logic
    );
end io_wrapper;

architecture wrapper of io_wrapper is
    component clk_wiz_0
    port
     (-- Clock in ports
      -- Clock out ports
      clk_out1          : out    std_logic;
      clk_out2          : out    std_logic;
      -- Status and control signals
      clk_in1           : in     std_logic
     );
    end component;
    
    COMPONENT ila_2
    PORT (
        clk : IN STD_LOGIC;
    
    
    
        probe0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
        probe1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
        probe2 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
        probe3 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
        probe4 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
        probe5 : IN STD_LOGIC_VECTOR(1 DOWNTO 0); 
        probe6 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe7 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe8 : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
    END COMPONENT  ;
    
    

    signal i_data_bus, i_addr_bus : std_logic_vector(31 downto 0);
    signal i_r_w_bus, i_ack_bus, i_address_strobe : std_logic;
    signal i_size_bus : std_logic_vector(1 downto 0);
    signal i_cpu_clk, i_clk_temp : std_logic;
    
    signal i_led : std_logic_vector(15 downto 0);
begin
    cpu : entity work.cpu(rtl)
          port map(data_bus => i_data_bus,
                   addr_bus => i_addr_bus,
                   ack_bus => i_ack_bus,
                   r_w_bus => i_r_w_bus,
                   address_strobe => i_address_strobe,
                   size_bus => i_size_bus,
                   clk_temp => i_cpu_clk,
                   CLK100MHZ => i_clk_temp,
                   reset => SW(0));
                   
    led_device : entity work.led_interface(rtl)
                 port map(data_bus => i_data_bus,
                          addr_bus => i_addr_bus,
                          led_out => i_led,
                          r_w => i_r_w_bus,
                          ack => i_ack_bus,
                          address_strobe => i_address_strobe,
                          clk => i_cpu_clk,
                          reset => SW(0));
                          
    cpu_main_clk : clk_wiz_0
                   port map ( 
                       -- Clock out ports  
                       clk_out1 => i_cpu_clk,    
                       clk_out2 => i_clk_temp,      
                       -- Clock in ports
                       clk_in1 => CLK100MHZ);

    bus_probes : ila_2
    PORT MAP (
        clk => i_clk_temp,
    
    
    
        probe0 => i_data_bus, 
        probe1 => i_addr_bus, 
        probe2(0) => i_r_w_bus, 
        probe3(0) => i_ack_bus, 
        probe4(0) => i_address_strobe, 
        probe5 => i_size_bus, 
        probe6(0) => i_cpu_clk,
        probe7(0) => i_clk_temp,
        probe8 => i_led
    );

    LED <= i_led;

end wrapper;













