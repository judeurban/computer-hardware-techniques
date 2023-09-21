library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- define the entity and ports (signals)
entity proj2_entity is
    port(

        -- bit array inputs
        mode_selector, nibble_a, nibble_b : in std_logic_vector(3 downto 0);

        -- bit array outputs
        led_result : out std_logic_vector(3 downto 0);
        led_mode_indicator : out std_logic_vector(3 downto 0)

    );
end entity proj2_entity;

architecture proj2_arch of proj2_entity is 
begin

    -- update the status LEDs to display the mode of operation
    led_mode_indicator <= mode_selector;

    -- create the ALU instance and map all appropriate signals
    alu_instance : entity work.alu_logic(alu_logic_arch)
    port map(
        mode_selector => mode_selector,
        nibble_a => nibble_a,
        nibble_b => nibble_b,
        result => led_result
    );

end architecture;