library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- define the entity and ports (signals)
entity int_to_7_segment_pair is
    port(
        segment_state : in INTEGER;
        lsn_seven_segment_counter : out INTEGER;
        msn_seven_segment_counter : out INTEGER
    );
end entity int_to_7_segment_pair;

architecture int_to_7_segment_pair_arch of int_to_7_segment_pair is

    signal modulo_result : INTEGER := 0;

begin

    process(segment_state)
    begin

        -- update the 7 segment signal for most/least significant nibble
        modulo_result <= segment_state MOD 16;
        lsn_seven_segment_counter <= modulo_result;
        msn_seven_segment_counter <= (segment_state - modulo_result) / 16;

    end process;

end architecture;