library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

entity RS232Entity is

    port
    (
        referenceClock : in std_logic;
        shouldTransmit : in std_logic;           -- a local flag that indicates transmission in progress

        -- RS-232 Pins.
        -- There are more but these are the only necessary ones. Control and data.  
        RxTerminal : in std_logic;   -- (RXD)    data
        TxTerminal : out std_logic;  -- (RXD)    data
        RTSOut     : out std_logic;  -- (RTS)    control
        CTSOut     : out std_logic;  -- (CTS)    control
        RTSIn      : in std_logic;   -- (RTS)    control
        CTSIn      : in std_logic;   -- (CTS)    control

        -- two buffers to support Rx and Tx
        TxBuffer : in  std_logic_vector(7 downto 0);      -- switch buffer
        RxBuffer : out std_logic_vector(7 downto 0)       -- sender buffer
    );

end RS232Entity;
    
architecture RS232Arch of RS232Entity is

    constant baudRate : integer := 2400;
    constant clockFrequency : integer := 2e6;
        
    -- declare new components to use the logic entities
    component RS232Sender
        port(
            referenceClock : in std_logic;
            shouldTransmit : in std_logic;
            baudRate : in integer;
            clockFrequency : in integer;
            TxTerminal : out std_logic;
            RTSOut     : out std_logic;
            CTSIn      : in std_logic; 
            TxBuffer : in std_logic_vector(7 downto 0)
        );
    end component;

    component RS232Listener
        port(
            referenceClock : in std_logic;
            baudRate : in integer;
            clockFrequency : in integer;
            RxTerminal : in std_logic;
            RTSIn      : in std_logic;
            CTSOut     : out std_logic;
            RxBuffer : out  std_logic_vector(7 downto 0)
        );
    end component;

begin

    -- instantiate the sender
    sender : RS232Sender 
        port map(
        referenceClock => referenceClock,
        shouldTransmit => shouldTransmit,
        baudRate => baudRate,
        clockFrequency => clockFrequency,
        TxTerminal => TxTerminal,
        RTSOut => RTSOut,
        CTSIn => CTSIn,
        TxBuffer => TxBuffer
    );

    -- instantiate the receiver
    listener : RS232Listener
        port map(
        referenceClock => referenceClock, 
        baudRate => baudRate,
        clockFrequency => clockFrequency,
        RxTerminal => RxTerminal, 
        RTSIn => RTSIn, 
        CTSOut => CTSOut, 
        RxBuffer => RxBuffer
    );

end architecture ;

