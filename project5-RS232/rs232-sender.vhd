library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;


entity RS232Sender is
    port (

        -- control signals
        referenceClock : in std_logic;
        shouldTransmit : in std_logic;           -- a local flag that indicates transmission in progress
        baudRate : in integer := 9600;
        clockFrequency : in integer := 2e6;

        -- RS-232 Pins.
        -- There are more but these are the only necessary ones.
        TxTerminal : out std_logic;  -- (TXD)    data
        RTSOut     : out std_logic;  -- (RTS)    control
        CTSIn      : in std_logic;   -- (CTS)    control

        -- buffer to transmit
        TxBuffer : in std_logic_vector(7 downto 0)         -- switch buffer
    );
end RS232Sender;

architecture RS232SenderArch of RS232Sender is
        
    -- local constants
    constant START_TRANSMISSION_FLAG : std_logic := '1';
    constant END_TRANSMISSION_FLAG   : std_logic := '0';
    
    -- control signals
    signal transmissionIndex           : INTEGER := 0;
    signal cyclesSinceLastTransmission : INTEGER :=  0;
    signal baudPeriodInClockCycles     : integer := 208;          -- 2MHz clock / 9600 default baud rate ~= 208
    signal parityBitCounter            : INTEGER := 1;            -- two by default to include starting bits
    signal bitToTransmit               : std_logic := '0';
    signal transmissionInProgress        : std_logic := '0';

begin

    -- determine the true period based on the clock cycle and baud rate
    -- baudPeriodInClockCycles <= clockFrequency / baudRate;

    process(referenceClock)
    begin

        if rising_edge(referenceClock) then

            -- no active transmission yet
            if transmissionInProgress = '0' then

                -- a user just raised a flag to transmit data
                if shouldTransmit = '1' then

                    -- ask the receiver if they're ready
                    RTSOut <= '0';
                    
                end if; -- shouldTransmit = '1'

                -- CTS is high, receiver is listening
                if CTSIn = '0' then

                    transmissionInProgress <= '1';

                    -- highjack the cycles so that we immediately send the first bit when CTS goes high
                    cyclesSinceLastTransmission <= baudPeriodInClockCycles;
                    transmissionIndex <= 0;

                end if; 

            end if; -- no transmission in progress

            if transmissionInProgress = '1' then

                -- ensure a valid transmission period
                if cyclesSinceLastTransmission >= baudPeriodInClockCycles then
                    
                    -- we just transmitted a bit
                    cyclesSinceLastTransmission <= 0;
                    
                    -- set the transmission line based on the transmission index
                    case( transmissionIndex ) is
                    
                        -- frame key:
                        -- 1 thru 8 is "payload"
                        -- 9 is parity
                        -- 10, 11 is ending bits

                        -- starting bit
                        when 0 =>
                            TxTerminal <= START_TRANSMISSION_FLAG;
                            if START_TRANSMISSION_FLAG = '1' then
                                parityBitCounter <= parityBitCounter + 1;
                            end if;

                            -- lower the request flag
                            -- doing this now prevents infinite loops from the sender thinking
                            -- we're trying to send more messages after this
                            RTSOut <= '1';

                        -- parity bit
                        when 9 =>

                            -- toggle the appropriate parity bit
                            if (parityBitCounter MOD 2) = 0 then
                                TxTerminal <= '0';
                            else
                                TxTerminal <= '1';
                            end if;

                        -- first ending bit
                        when 10 =>
                        
                            TxTerminal <= END_TRANSMISSION_FLAG;

                            -- send the final transmission (this happens to be idle state)
                            TxTerminal <= END_TRANSMISSION_FLAG;
    
                            -- reset all signals to idle state
                            cyclesSinceLastTransmission <= 0;
                            transmissionIndex <= 0;
                            parityBitCounter <= 0;
                            transmissionInProgress <= '0';
    
                            report "ending transmission";

                        -- second ending bit
                        -- when 11 =>
                        
                        -- transmit the payload
                        when others =>

                            -- -1 to account for the starting bit
                            bitToTransmit <= TxBuffer(transmissionIndex - 1);
                            TxTerminal <= TxBuffer(transmissionIndex - 1);

                            -- for parity detection
                            if bitToTransmit = '1' then
                                parityBitCounter <= parityBitCounter + 1;
                            end if;

                    end case; -- transmissionIndex

                    transmissionIndex <= transmissionIndex + 1;

                else

                    -- keep track of the clock cycles
                    cyclesSinceLastTransmission <= cyclesSinceLastTransmission + 1;
                    
                end if; -- cyclesSinceLastTransmission >= baudPeriodInClockCycles, valid transmission cycle

            end if; -- transmission in progress


        end if; -- rising edge

    end process; -- referenceClock


end architecture ;

