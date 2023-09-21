library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- define the entity and ports (signals)
entity bit_to_std_logic_vector_converter_entity is
    port(

        -- bit signals (input)
        bit0 : in std_logic;
        bit1 : in std_logic;
        bit2 : in std_logic;
        bit3 : in std_logic;

        -- bit array signals (output)
        vector : out std_logic_vector(3 downto 0)

    );
end entity bit_to_std_logic_vector_converter_entity;

architecture bit_to_std_logic_vector_converter_arch of bit_to_std_logic_vector_converter_entity is 
begin

    -- use concatination to build the vector
    vector <= bit3 & bit2 & bit1 & bit0;

end architecture;