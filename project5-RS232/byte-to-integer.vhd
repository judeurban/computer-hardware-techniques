library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- define the entity and ports (signals)
entity byte_to_integer is
    port(
        switch_logic : in std_logic_vector(7 downto 0);
        segment_status : out INTEGER
    );
end entity byte_to_integer;

architecture byte_to_integer_arch of byte_to_integer is
begin

    process(switch_logic)
    begin

        -- convert the bits to an integer
        segment_status <= to_integer(unsigned(switch_logic));

    end process;

end architecture;