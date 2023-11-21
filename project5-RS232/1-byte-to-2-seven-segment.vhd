library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- define the entity and ports (signals)
entity one_byte_to_seven_segment is
    port(
        segment_state : in INTEGER;
        lsn_seven_segment_counter : out INTEGER;
        msn_seven_segment_counter : out INTEGER
    );
end entity one_byte_to_seven_segment;

architecture one_byte_to_seven_segment_arch of one_byte_to_seven_segment is

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