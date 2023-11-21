library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

entity RS232Entity is
    port (

        referenceClock : in std_logic;
        shouldTransmit : inout std_logic := '0';           -- a local flag that indicates transmission in progress
        baudRate : in integer := 9600;
        clockFrequency : in integer := 2e6;

        -- RS-232 Pins.
        -- There are more but these are the only necessary ones.
        pin2_ReceiveData    : in std_logic := '0';        -- (RXD)    data
        pin3_TransmitData   : out std_logic := '0';       -- (TXD)    data
        pin5_SignalGround   : in std_logic := '0';        -- (GND)    -
        pin7_RequestToSend  : inout std_logic := '0';     -- (RTS)    control
        pin8_ClearToSend    : inout std_logic := '0';     -- (CTS)    control

        -- two buffers to support Rx and Tx
        TxBuffer : in  std_logic_vector(7 downto 0);      -- switch buffer
        RxBuffer : out std_logic_vector(7 downto 0)       -- sender buffer

    );
end RS232Entity;
    
architecture RS232Arch of RS232Entity is
        
    -- local constants
    constant START_TRANSMISSION_FLAG : std_logic := '1';
    constant END_TRANSMISSION_FLAG   : std_logic := '0';

    -- declare new components to use the logic entities
    component RS232Sender
        port(
            referenceClock : in std_logic;
            shouldTransmit : inout std_logic := '0';
            baudRate : in integer := 9600;
            clockFrequency : in integer := 2e6;
            pin3_TransmitData   : out std_logic := '0';
            pin7_RequestToSend  : inout std_logic := '0';
            pin8_ClearToSend    : inout std_logic := '0';
            TxBuffer : in std_logic_vector(7 downto 0)
        );
    end component;

    component RS232Listener
        port(
            referenceClock : in std_logic;
            baudRate : in integer := 9600;
            clockFrequency : in integer := 2e6;
            pin2_ReceiveData    : in std_logic := '0';
            pin7_RequestToSend  : inout std_logic := '0';
            pin8_ClearToSend    : inout std_logic := '0';
            RxBuffer : out  std_logic_vector(7 downto 0)
        );
    end component;

begin

    -- instantiate the sender
    sender : RS232Sender port map(
        referenceClock => referenceClock,
        shouldTransmit => shouldTransmit,
        baudRate => baudRate,
        clockFrequency => clockFrequency,
        pin3_TransmitData => pin3_TransmitData,
        pin7_RequestToSend => pin7_RequestToSend,
        pin8_ClearToSend => pin8_ClearToSend,
        TxBuffer => TxBuffer
    );

    -- instantiate the receiver
    listener : RS232Listener port map(
        referenceClock => referenceClock, 
        baudRate => baudRate,
        clockFrequency => clockFrequency,
        pin2_ReceiveData => pin2_ReceiveData, 
        pin7_RequestToSend => pin7_RequestToSend, 
        pin8_ClearToSend => pin8_ClearToSend, 
        RxBuffer => RxBuffer
    );

    -- idea for test bench:
    -- signals for Rx/Tx
    -- it's naturally just one wire in real life, so 
    -- signal A_to_B std_logic
    -- signal B_to_A std_logic
    -- then just map them accordingly

end architecture ;

