-- Prints the number in the register onto the 7-segment display in hexadecimal format

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity numeric_display_interface is
    port(
        -- Board connections
        segment_bits : out std_logic_vector(7 downto 0);
        anode_bits : out std_logic_vector(7 downto 0);
            
        -- CPU bus interface signals
        addr_bus, data_bus : in std_logic_vector(31 downto 0);
        ack : out std_logic;
        r_w, address_strobe : in std_logic;
            
        clk, clk_disp, clk_ila, reset : in std_logic
    );
end numeric_display_interface;

architecture rtl of numeric_display_interface is
    COMPONENT numeric_display_ila

    PORT (
        clk : IN STD_LOGIC;
    
    
    
        probe0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
        probe1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        probe2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
    END COMPONENT  ;

    type state_type is (INACTIVE,
                READ_ACTIVE);
                
    type state_type_act_seg is (SEG_INACTIVE,
                                SEG_1,
                                SEG_2,
                                SEG_3,
                                SEG_4,
                                SEG_5,
                                SEG_6,
                                SEG_7,
                                SEG_8);

    -- Bus communication and data registers
    signal i_state, i_next : state_type;
    
    signal i_data_register : std_logic_vector(31 downto 0);
    signal i_data_register_write : std_logic;
    
    signal i_enable_read : std_logic;
    
    -- Seven segment time multiplex state machine and circuitry
    signal i_state_sseg, i_next_sseg : state_type_act_seg;
    
    signal decoder_bin_in : std_logic_vector(3 downto 0);
    
    signal i_clk_div_counter : std_logic_vector(9 downto 0);
    signal i_disp_start_counter : std_logic_vector(15 downto 0);
    
    signal i_disp_start : std_logic;
    signal i_disp_start_wait_rst : std_logic;
    signal i_disp_start_wait : std_logic;
    signal i_disp_en_rst : std_logic;
    signal i_disp_en : std_logic;
begin
    decoder : entity work.bin_to_hex_sseg_decoder(rtl)
              port map (binary_in => decoder_bin_in,
                        sseg_out => segment_bits);
              
    -- ========== DISPLAY CONTROL ==========
    i_disp_en_rst <= reset;
    i_disp_start_wait_rst <= (not i_disp_start_wait) or reset;
    
    with i_clk_div_counter select i_disp_en <=
        '1' when "1111111111",
        '0' when others;
        
    with i_disp_start_counter select i_disp_start <=
        '1' when X"1111",
        '0' when others;
    
    process(clk_disp)
    begin
        if (i_disp_en_rst = '1') then
            i_clk_div_counter <= (others => '0');
        elsif (rising_edge(clk_disp)) then
            i_clk_div_counter <= std_logic_vector(unsigned(i_clk_div_counter) + 1);
        end if;
    end process;
    
    process(clk_disp)
    begin
        if (i_disp_start_wait_rst = '1') then
            i_disp_start_counter <= (others => '0');
        elsif (rising_edge(clk_disp)) then
            i_disp_start_counter <= std_logic_vector(unsigned(i_disp_start_counter) + 1);
        end if;
    end process;
    
    process(clk_disp)
    begin
        if (rising_edge(clk_disp)) then
            if (reset = '1') then
                i_state_sseg <= SEG_1;
            else
                i_state_sseg <= i_next_sseg;
            end if; 
        end if;
    end process;
    
    process(all)
    begin
        if (i_state_sseg = SEG_INACTIVE) then
            if (i_disp_start = '1') then
                i_next_sseg <= SEG_1;
            else
                i_next_sseg <= SEG_INACTIVE;
            end if;
        elsif (i_state_sseg = SEG_1) then
            if (i_disp_en = '1') then
                i_next_sseg <= SEG_2;
            else
                i_next_sseg <= SEG_1;    
            end if;
        elsif (i_state_sseg = SEG_2) then
            if (i_disp_en = '1') then
                i_next_sseg <= SEG_3;
            else
                i_next_sseg <= SEG_2;
            end if;
        elsif (i_state_sseg = SEG_3) then
            if (i_disp_en = '1') then
                i_next_sseg <= SEG_4;
            else
                i_next_sseg <= SEG_3;
            end if;
        elsif (i_state_sseg = SEG_4) then
            if (i_disp_en = '1') then
                i_next_sseg <= SEG_5;
            else
                i_next_sseg <= SEG_4;
            end if;
        elsif (i_state_sseg = SEG_5) then
            if (i_disp_en = '1') then
                i_next_sseg <= SEG_6;
            else
                i_next_sseg <= SEG_5;
            end if;
        elsif (i_state_sseg = SEG_6) then
            if (i_disp_en = '1') then
                i_next_sseg <= SEG_7;
            else
                i_next_sseg <= SEG_6;
            end if;
        elsif (i_state_sseg = SEG_7) then
            if (i_disp_en = '1') then
                i_next_sseg <= SEG_8;
            else
                i_next_sseg <= SEG_7; 
            end if; 
        elsif (i_state_sseg = SEG_8) then
            if (i_disp_en = '1') then
                i_next_sseg <= SEG_INACTIVE;
            else
                i_next_sseg <= SEG_8;
            end if;
        end if;
    end process;
    
    -- Outputs
    process(all)
    begin
        if (i_state_sseg = SEG_INACTIVE) then
            i_disp_start_wait <= '1';
            
            decoder_bin_in <= (others => '0');
            anode_bits <= "11111111";
        elsif (i_state_sseg = SEG_1) then
            i_disp_start_wait <= '0';
        
            decoder_bin_in <= i_data_register(3 downto 0);
            anode_bits <= "11111110";
        elsif (i_state_sseg = SEG_2) then
            i_disp_start_wait <= '0';
        
            decoder_bin_in <= i_data_register(7 downto 4);
            anode_bits <= "11111101";
        elsif (i_state_sseg = SEG_3) then
            i_disp_start_wait <= '0';
        
            decoder_bin_in <= i_data_register(11 downto 8);
            anode_bits <= "11111011";
        elsif (i_state_sseg = SEG_4) then
            i_disp_start_wait <= '0';
        
            decoder_bin_in <= i_data_register(15 downto 12);
            anode_bits <= "11110111";
        elsif (i_state_sseg = SEG_5) then
            i_disp_start_wait <= '0';
            
            decoder_bin_in <= i_data_register(19 downto 16);
            anode_bits <= "11101111";
        elsif (i_state_sseg = SEG_6) then
            i_disp_start_wait <= '0';
        
            decoder_bin_in <= i_data_register(23 downto 20);
            anode_bits <= "11011111";
        elsif (i_state_sseg = SEG_7) then
            i_disp_start_wait <= '0';
        
            decoder_bin_in <= i_data_register(27 downto 24);
            anode_bits <= "10111111";
        elsif (i_state_sseg = SEG_8) then
            i_disp_start_wait <= '0';
        
            decoder_bin_in <= i_data_register(31 downto 28);
            anode_bits <= "01111111";
        end if;
    end process;
    
    -- ========== BUS CONTROL ==========          
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
        end if;
        
        if (rising_edge(clk)) then
            if (i_data_register_write = '1') then
                i_data_register <= data_bus;
            end if;
        end if;
    end process;

    -- Address decoder
    with addr_bus select i_enable_read <=
        '1' when X"FFFFFF20",
        '0' when others;
        
--    ila : numeric_display_ila
--    PORT MAP (
--        clk => clk_ila,
    
    
    
--        probe0 => i_data_register, 
--        probe1 => segment_bits,
--        probe2 => anode_bits
--    );

end rtl;
