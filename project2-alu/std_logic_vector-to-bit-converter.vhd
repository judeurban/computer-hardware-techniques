library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- define the entity and ports (signals)
entity std_logic_to_bit_vector_converter_entity is
    port(

        -- bit array signals (input)
        vector : in std_logic_vector(3 downto 0);

        -- bit signals (input)
        bit0 : out std_logic;
        bit1 : out std_logic;
        bit2 : out std_logic;
        bit3 : out std_logic

    );
end entity std_logic_to_bit_vector_converter_entity;

architecture std_logic_to_bit_vector_converter_arch of std_logic_to_bit_vector_converter_entity is 
begin

    -- strip the vector of its components
    -- and assign it to each bit
    bit3 <= vector(3);
    bit2 <= vector(2);
    bit1 <= vector(1);
    bit0 <= vector(0);

end architecture;