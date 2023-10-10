library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- define the entity and ports (signals)
entity timer_segment_control is
    port(

        reset, clk : in std_logic;
        status_led : out std_logic;
        segment_state : out INTEGER
        
    );
end entity timer_segment_control;

architecture timer_segment_control_arch of timer_segment_control is

    -- build the internal counter (goes up to 2MHz value)
    signal internal_count : INTEGER range 0 to 1_999_999 := 0;
    signal internal_seven_seg_counter : INTEGER range 0 to 255 := 0;
    signal internal_status_led : std_logic := '0';

begin

    process(clk, reset)
    begin
        
        -- only consider on rising edge clock cycles
        if rising_edge(clk) then
            
            -- Increment the counter
            internal_count <= internal_count + 1;
            
            -- only run once per second
            if internal_count >= 1_999_999 then

                internal_count <= 0;                                            -- reset the internal counter
                internal_seven_seg_counter <= internal_seven_seg_counter + 1;   -- increment the 7seg counter
                internal_status_led <= not internal_status_led;                 -- toggle the status LED

                -- saturate the 7seg counter to 255
                if internal_seven_seg_counter >= 255 then
                    internal_seven_seg_counter <= 0;
                    end if;

                -- update the external signals
                status_led <= internal_status_led;                     -- toggle the status LED
                segment_state <= internal_seven_seg_counter;           -- update the state of the 7 seg 

                end if;
            
        end if;
        
        -- Reset the counter
        if reset = '0' then
            status_led <= '0';
            internal_count <= 0;
            internal_seven_seg_counter <= 0;
            end if;

    end process;

end architecture;