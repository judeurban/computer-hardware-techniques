library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RS232Testbench is
end entity;

architecture RS232TestbenchArch of RS232Testbench is

    -- GLOBAL SIGNALS
    -----------------

    signal referenceClock : std_logic := '0';
    signal baudRate : integer := 9600;
    signal clockFrequency : integer := 2e6;
    signal clockIndex : integer := 0;

    -- LOCAL SIGNALS
    ----------------

    -- TX/RX Lines
    signal data_participantA_to_participantB : std_logic := '0';
    signal data_participantB_to_participantA : std_logic := '0';

    -- RTS/CTS terminal endpoints

    -- RTS/CTS Control
    signal RTS_participantA_to_participantB : std_logic := '0';
    signal RTS_participantB_to_participantA : std_logic := '0';
    signal CTS_participantA_to_participantB : std_logic := '0';
    signal CTS_participantB_to_participantA : std_logic := '0';

    -- a local flag that indicates transmission in progress
    signal participantA_shouldTransmit : std_logic := '0';
    signal participantB_shouldTransmit : std_logic := '0';

    -- make the local buffers for participants
    signal participantA_TxBuffer : std_logic_vector(7 downto 0) := "00000000";
    signal participantA_RxBuffer : std_logic_vector(7 downto 0) := "00000000";
    signal participantB_TxBuffer : std_logic_vector(7 downto 0) := "00000000";
    signal participantB_RxBuffer : std_logic_vector(7 downto 0) := "00000000";

    -- COMPONENT DECLARATION
    ------------------------

    -- create a 2MHz clock generator component
    component ClockGenerator
        port (
            clk_out : out std_logic := '0'
        );
    end component;

    -- declare a new component to use the RS232 Entity
    component RS232Entity
        port(
            referenceClock : in std_logic;
            shouldTransmit : in std_logic;
            RxTerminal : in std_logic;
            TxTerminal : out std_logic;
            RTSOut     : out std_logic;
            CTSOut     : out std_logic;
            RTSIn      : in std_logic;
            CTSIn      : in std_logic;
            TxBuffer : in  std_logic_vector(7 downto 0);
            RxBuffer : out std_logic_vector(7 downto 0)
        );
    end component;

begin

    -- instantiate the 2MHz clock and map it to our local signal
    CLock_2MHZ : ClockGenerator
        port map(
        clk_out => referenceClock
    );

    -- instantiate participant A
    participantA : RS232Entity
    port map(
        referenceClock     => referenceClock,
        shouldTransmit     => participantA_shouldTransmit,
        RxTerminal         => data_participantB_to_participantA,
        TxTerminal         => data_participantA_to_participantB,
        RTSOut             => RTS_participantA_to_participantB,
        CTSOut             => CTS_participantA_to_participantB,
        RTSIn              => RTS_participantB_to_participantA,
        CTSIn              => CTS_participantB_to_participantA,
        TxBuffer           => participantA_TxBuffer,
        RxBuffer           => participantA_RxBuffer
    );

    -- instantiate participant B
    participantB : RS232Entity
    port map(
        referenceClock     => referenceClock,
        shouldTransmit     => participantB_shouldTransmit,
        RxTerminal         => data_participantA_to_participantB,
        TxTerminal         => data_participantB_to_participantA,
        RTSOut             => RTS_participantB_to_participantA,
        CTSOut             => CTS_participantB_to_participantA,
        RTSIn              => RTS_participantA_to_participantB,
        CTSIn              => CTS_participantA_to_participantB,
        TxBuffer           => participantB_TxBuffer,
        RxBuffer           => participantB_RxBuffer
    );

    process(referenceClock)
    begin
        if rising_edge(referenceClock) then
            clockIndex <= clockIndex + 1;
        end if;
    end process;

    RS232Process : process
    begin

        -- Then set it to transmit
        participantA_TxBuffer <= "01100001";  -- ascii for 'a'

        -- drive the port for some time
        participantA_shouldTransmit <= '1';
        wait for 1000 ns;  -- Wait for transmission to occur

        -- disable future transmission
        participantA_shouldTransmit <= '0';

        wait on participantB_RxBuffer;
        
        -- switch to high impedence mode to read the signal
        participantA_shouldTransmit <= 'Z';
        
        -- More logic or wait statements as needed
    end process;

end RS232TestbenchArch ; -- RS232TestbenchArch