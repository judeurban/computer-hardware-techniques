library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- define the entity and ports (signals)
entity demultiplexer_entity is
    port(

        vector : in std_logic_vector(7 downto 0);
        bit0, bit1, bit2, bit3, bit4, bit5, bit6 : out std_logic
        
    );
end entity demultiplexer_entity;

architecture demultiplexer_arch of demultiplexer_entity is 
begin

    bit6 <= vector(6);
    bit5 <= vector(5);
    bit4 <= vector(4);
    bit3 <= vector(3);
    bit2 <= vector(2);
    bit1 <= vector(1);
    bit0 <= vector(0);

end architecture;