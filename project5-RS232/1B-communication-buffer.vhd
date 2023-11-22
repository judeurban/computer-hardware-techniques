library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- define the entity and ports (signals)
entity communicationBuffer is
    port(

        -- setter logic
        set : in std_logic;
        setData : in std_logic_vector(7 downto 0); 

        -- getter logic
        get : in std_logic;
        outputData : out std_logic_vector(7 downto 0);

        -- status
        isFull : out std_logic := '0'
    );
end entity communicationBuffer;

architecture communicationBuffer_arch of communicationBuffer is

    -- local buffer data
    signal bufferData : std_logic_vector(7 downto 0);

begin

    -- getter, setter logic
    process(set, get)
    begin

        -- setter function is "called"
        if set = '1' then

            bufferData <= setData;
            isFull <= '1';

        end if;

        -- getter function is "called"
        if get = '1' then

            outputData <= bufferData;
            isFull <= '0';

        end if;

    end process;

end architecture;