library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- define the entity and ports (signals)
entity statusLED is
    port(
        ReferenceClock2MHz : in std_logic;
        ledToggle : inout std_logic
    );
end entity statusLED;

architecture statusLED_arch of statusLED is

    signal internalCounter : integer := 0;
    constant maxCount : integer := 2e6;

begin

    process(ReferenceClock2MHz)
    begin

        if rising_edge(ReferenceClock2MHz) then

            internalCounter <= internalCounter + 1;

            if internalCounter >= maxCount then
                internalCounter <= 0;
                ledToggle <= NOT ledToggle;
            end if;

        end if;

    end process;

end architecture;