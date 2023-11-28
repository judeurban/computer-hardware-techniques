library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

entity RS232Entity is

    port
    (
        referenceClock : in std_logic;
        shouldTransmit : in std_logic;                       -- a flag that initiates a transmission using 

        -- RS-232 Pins.
        -- There are more but these are the only necessary ones. Control and data.  
        RxTerminal : in std_logic;   -- (RXD)    data
        TxTerminal : out std_logic;  -- (RXD)    data
        RTSOut     : out std_logic;  -- (RTS)    control
        CTSOut     : out std_logic;  -- (CTS)    control
        RTSIn      : in std_logic;   -- (RTS)    control
        CTSIn      : in std_logic;   -- (CTS)    control

        -- from the switch array
        TxSet        : in std_logic;
        TxSetData    : in std_logic_vector(7 downto 0) := (others => '0');; 
        TxIsFull     : out std_logic := '0';

        -- to the displays and control switches
        RxGet        : in std_logic := '0';
        RxGetData    : out std_logic_vector(7 downto 0) := (others => '0');;
        RxIsFull     : out std_logic := '0'
    );

end RS232Entity;
    
architecture RS232Arch of RS232Entity is

    constant baudRate : integer := 2400;
    constant clockFrequency : integer := 2e6;
    signal baudPeriodCC : integer := 833;

    -- declare new components to use the logic entities
    component RS232Sender
        port(
            referenceClock : in std_logic;
            shouldTransmit : in std_logic;
            baudPeriodCC   : in integer;
            TxTerminal     : out std_logic;
            RTSOut         : out std_logic;
            CTSIn          : in std_logic;
            TxGet          : out std_logic;
            TxGetData      : in std_logic_vector(7 downto 0)
        );
    end component;

    component RS232Listener
        port(
            referenceClock : in std_logic;
            baudPeriodCC   : in integer;
            RxTerminal     : in std_logic;
            RTSIn          : in std_logic;
            CTSOut         : out std_logic;
            RxSet          : out std_logic;
            RxSetData      : out std_logic_vector(7 downto 0)
        );
    end component;

    component communicationBuffer
        port(
            set        : in std_logic;
            setData    : in std_logic_vector(7 downto 0); 
            get        : in std_logic;
            getData    : out std_logic_vector(7 downto 0);
            isFull     : out std_logic := '0'
        );
    end component;

    -- make the signals for the io buffers
    
    -- to set the output received buffer
    signal RxSet        : std_logic := '0';
    signal RxSetData    : std_logic_vector(7 downto 0); 

    -- signals used to extract the switch array
    signal TxGet        : std_logic := '0';
    signal TxGetData    : std_logic_vector(7 downto 0);

begin

    baudPeriodCC <= clockFrequency / baudRate;

    -- instantiate the sender
    sender : RS232Sender 
        port map(
        referenceClock => referenceClock,
        shouldTransmit => shouldTransmit,
        baudPeriodCC => baudPeriodCC,
        TxTerminal => TxTerminal,
        RTSOut => RTSOut,
        CTSIn => CTSIn,
        TxGet => TxGet,
        TxGetData => TxGetData
    );

    -- instantiate the receiver
    listener : RS232Listener
        port map(
        referenceClock => referenceClock, 
        baudPeriodCC => baudPeriodCC,
        RxTerminal => RxTerminal, 
        RTSIn => RTSIn, 
        CTSOut => CTSOut, 
        RxSet => RxSet,
        RxSetData => RxSetData
    );

    TxBuffer : communicationBuffer
    port map(
        set        => TxSet,
        setData    => TxSetData,
        get        => TxGet,
        getData    => TxGetData,
        isFull     => TxIsFull
    );

    RxBuffer : communicationBuffer
    port map(
        set        => RxSet,
        setData    => RxSetData,
        get        => RxGet,
        getData    => RxGetData,
        isFull     => RxIsFull
    );

end architecture ;

