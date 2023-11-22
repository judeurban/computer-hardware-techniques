library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_segment_decoder is
    port (
        seven_segment_counter : in INTEGER;
        segment_output : out std_logic_vector(6 downto 0) -- 7-bit output for seven-segment display
    );
end entity seven_segment_decoder;

architecture seven_segment_decoder_arch of seven_segment_decoder is
begin

    process(seven_segment_counter)
    begin

        -- logic for the 7seg display
        case seven_segment_counter is 
            when 0 =>
                segment_output <= "1000000";    -- 0
            when 1 =>
                segment_output <= "1111001";    -- 1
            when 2 =>
                segment_output <= "0100100";    -- 2
            when 3 =>
                segment_output <= "0110000";    -- 3
            when 4 =>
                segment_output <= "0011001";    -- 4
            when 5 =>
                segment_output <= "0010010";    -- 5
            when 6 =>
                segment_output <= "0000010";    -- 6
            when 7 =>
                segment_output <= "1111000";    -- 7
            when 8 =>
                segment_output <= "0000000";    -- 8
            when 9 =>
                segment_output <= "0010000";    -- 9
            when 10 =>
                segment_output <= "0001000";    -- a
            when 11 =>
                segment_output <= "0000011";    -- b
            when 12 =>
                segment_output <= "1000110";    -- c
            when 13 =>
                segment_output <= "0100001";    -- d
            when 14 =>
                segment_output <= "0000110";    -- e
            when 15 =>
                segment_output <= "0001110";    -- f
            when others =>
                segment_output <= "0111111";    -- null
        end case;

    end process;
            
end seven_segment_decoder_arch;
