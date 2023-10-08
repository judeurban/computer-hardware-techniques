library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- define the entity and ports (signals)
entity manual_segment_control is
    port(
        switch_logic : in std_logic_vector(7 downto 0);
        segment_status : out INTEGER
    );
end entity manual_segment_control;

architecture manual_segment_control_arch of manual_segment_control is
begin

    process(switch_logic)
    begin

        -- convert the bits to an integer
        segment_status <= to_integer(unsigned(switch_logic));

    end process;

end architecture;