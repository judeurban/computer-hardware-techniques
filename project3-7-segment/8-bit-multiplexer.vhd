library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- define the entity and ports (signals)
entity eight_bit_multiplexer_entity is
    port(

        bit0, bit1, bit2, bit3, bit4, bit5, bit6, bit7 : in std_logic;
        vector : out std_logic_vector(7 downto 0)
        
    );
end entity eight_bit_multiplexer_entity;

architecture multiplexer_arch of eight_bit_multiplexer_entity is 
begin

    -- use concatination to build the vector
    vector <= bit7 & bit6 & bit5 & bit4 & bit3 & bit2 & bit1 & bit0;

end architecture;