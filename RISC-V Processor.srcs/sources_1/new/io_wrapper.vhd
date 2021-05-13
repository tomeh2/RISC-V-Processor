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
    
        BUTTON_CENTER : in std_logic;
        BUTTON_LEFT : in std_logic;
        BUTTON_RIGHT : in std_logic;
        BUTTON_TOP : in std_logic;
        BUTTON_DOWN : in std_logic;
        
        AN : out std_logic_vector(7 downto 0);
        CA : out std_logic;
        CB : out std_logic;
        CC : out std_logic;
        CD : out std_logic;
        CE : out std_logic;
        CF : out std_logic;
        CG : out std_logic;
        DP : out std_logic;
    
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
      clk_out3          : out    std_logic;
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
        probe8 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        probe9 : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT  ;
    
    
    signal i_data_bus_button_dev : std_logic_vector(31 downto 0);

    signal i_data_bus_in, i_data_bus_out, i_addr_bus : std_logic_vector(31 downto 0);
    signal i_r_w_bus, i_ack_bus, i_address_strobe : std_logic;
    signal i_size_bus : std_logic_vector(1 downto 0);
    signal i_cpu_clk, i_clk_temp, i_clk_sseg : std_logic;
    
    signal i_led : std_logic_vector(15 downto 0);
    
    signal i_ack_led, i_ack_pb, i_ack_num_disp : std_logic;
    
    signal test : std_logic_vector(31 downto 0);
begin
    cpu : entity work.cpu(rtl)
          port map(data_bus_in => i_data_bus_in,
                   data_bus_out => i_data_bus_out,
                   addr_bus => i_addr_bus,
                   ack_bus => i_ack_bus,
                   r_w_bus => i_r_w_bus,
                   address_strobe => i_address_strobe,
                   size_bus => i_size_bus,
                   clk_temp => i_cpu_clk,
                   CLK100MHZ => i_clk_temp,
                   reset => SW(0));
                   
    led_device : entity work.led_interface(rtl)
                 port map(data_bus => i_data_bus_out,
                          addr_bus => i_addr_bus,
                          led_out => i_led,
                          r_w => i_r_w_bus,
                          ack => i_ack_led,
                          address_strobe => i_address_strobe,
                          clk => i_cpu_clk,
                          reset => SW(0));
                          
    numeric_display_interface : entity work.numeric_display_interface(rtl)
                                port map(data_bus => i_data_bus_out,
                                         addr_bus => i_addr_bus,
                                         r_w => i_r_w_bus,
                                         ack => i_ack_num_disp,
                                         address_strobe => i_address_strobe,
                                         clk => i_cpu_clk,
                                         clk_disp => i_clk_sseg,
                                         clk_ila => i_clk_temp,
                                         reset => SW(0),
                                         segment_bits(0) => DP,
                                         segment_bits(1) => CG,
                                         segment_bits(2) => CF,
                                         segment_bits(3) => CE,
                                         segment_bits(4) => CD,
                                         segment_bits(5) => CC,
                                         segment_bits(6) => CB,
                                         segment_bits(7) => CA,
                                         anode_bits => AN);
                          
    push_button_device : entity work.push_button_interface(rtl)
                         port map(data_bus => i_data_bus_button_dev,
                                  addr_bus => i_addr_bus,
                                  buttons(4) => BUTTON_CENTER,
                                  buttons(3) => BUTTON_TOP,
                                  buttons(2) => BUTTON_DOWN,
                                  buttons(1) => BUTTON_LEFT,
                                  buttons(0) => BUTTON_RIGHT,
                                  r_w => i_r_w_bus,
                                  ack => i_ack_pb,
                                  address_strobe => i_address_strobe,
                                  clk => i_cpu_clk,
                                  clk_ila => i_clk_temp,
                                  reset => SW(0));
                                  
    input_dev_sel : entity work.mux_4_1(rtl)
                    generic map(WIDTH_BITS => 32)
                    port map(in_0 => i_data_bus_button_dev,
                             in_1 => X"00000000",
                             in_2 => X"00000000",
                             in_3 => X"00000000",
                             output => i_data_bus_in,
                             sel => "00");
                          
    i_ack_bus <= i_ack_led or i_ack_pb or i_ack_num_disp;
                          
    cpu_main_clk : clk_wiz_0
                   port map ( 
                       -- Clock out ports  
                       clk_out1 => i_cpu_clk,    
                       clk_out2 => i_clk_temp,      
                       clk_out3 => i_clk_sseg,
                       -- Clock in ports
                       clk_in1 => CLK100MHZ);

    bus_probes : ila_2
    PORT MAP (
        clk => i_clk_temp,
    
    
    
        probe0 => i_data_bus_in,
        probe1 => i_addr_bus, 
        probe2(0) => i_r_w_bus, 
        probe3(0) => i_ack_bus, 
        probe4(0) => i_address_strobe, 
        probe5 => i_size_bus, 
        probe6(0) => i_cpu_clk,
        probe7(0) => i_clk_temp,
        probe8 => i_led,
        probe9 => i_data_bus_out
    );

    LED <= i_led;

end wrapper;













