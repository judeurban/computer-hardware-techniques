library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

entity RS232Listener is
    port (

        referenceClock : in std_logic;
        baudRate : in integer := 9600;
        clockFrequency : in integer := 2e6;

        -- RS-232 Pins.
        -- There are more but these are the only necessary ones.
        pin2_ReceiveData    : in std_logic := '0';         -- (RXD)    data
        pin7_RequestToSend  : inout std_logic := '0';      -- (RTS)    control
        pin8_ClearToSend    : inout std_logic := '0';      -- (CTS)    control

        -- buffer to populate
        RxBuffer : out std_logic_vector(7 downto 0)
    );
end RS232Listener;
    
architecture RS232ListenerArch of RS232Listener is
        
    -- local constants
    constant START_TRANSMISSION_FLAG : std_logic := '1';
    constant END_TRANSMISSION_FLAG   : std_logic := '0';
    
    -- control signals
    signal samplingIndex : INTEGER := 0;
    signal cyclesSinceLastSample : INTEGER :=  0 ;
    signal parityBitCounter : INTEGER := 1;             -- two by default to include starting bits
    signal baudPeriodInClockCycles : integer := 208;    -- 2MHz clock / 9600 default baud rate ~= 208
    signal phaseShiftCompleted : std_logic := '0';      -- flag used to indicate if we've shifted baud sampling phase by 180deg.
    signal phaseShiftInProgress : std_logic := '0';      -- flag used to indicate if we've shifted baud sampling phase by 180deg.
    signal incomingBit : std_logic := '0';
    signal receivedParityBit : INTEGER := 0;

    -- local signal that allows read/write
    signal localIncomingBuffer : std_logic_vector(11 downto 0);

begin

    -- determine the true period based on the clock cycle and baud rate
    baudPeriodInClockCycles <= clockFrequency / baudRate;

    process(referenceClock)
    begin

        -- always control on a rising edge signal
        if rising_edge(referenceClock) then

            -- a device wants to send us a message
            -- or is sending us a message
            if pin7_RequestToSend = '1' then

                -- the CTS signal hasn't been raised
                -- initate a new transmission
                if pin8_ClearToSend = '0' then
                    
                    -- inform the sender that we're listening
                    pin8_ClearToSend <= '1';

                -- we've already raised a CTS flag
                -- listen for a rising edge on the start transmission bit
                else

                    -- we haven't received any bits yet
                    if phaseShiftCompleted = '0' then

                        -- we just received the first bit of data
                        -- we need to shift phase sampling by pi/2 to sample in the "middle" of the transmission
                        if rising_edge(pin2_ReceiveData) then
                            phaseShiftInProgress <= '1';
                            cyclesSinceLastSample <= 0;
                        end if;

                        -- check if we should exit the phase shift
                        if phaseShiftInProgress = '1' then

                            -- we've just seen another period of the clock cycle
                            cyclesSinceLastSample <= cyclesSinceLastSample + 1;

                            -- we just reached the halfway point of transmission
                            if cyclesSinceLastSample >= (baudPeriodInClockCycles / 2) then

                                cyclesSinceLastSample <= baudPeriodInClockCycles;
                                phaseShiftInProgress <= '0';
                                phaseShiftCompleted <= '1';

                            end if; -- reached halfway point of transmission

                        end if;  -- phase shift in process

                    -- phase shift has been completed. Sample the transmission
                    else

                        -- check for a valid transmission cycle
                        if (cyclesSinceLastSample >= baudPeriodInClockCycles) then

                            -- sample the value of the pin
                            localIncomingBuffer(samplingIndex) <= pin2_ReceiveData;
                            samplingIndex <= samplingIndex + 1;

                            if incomingBit = '1' then
                                parityBitCounter <= parityBitCounter + 1;
                            end if;

                            -- we've reached the end of transmission
                            if samplingIndex = 12 then

                                -- write the payload
                                -- not including the parity, starting, or ending bits
                                RxBuffer <= localIncomingBuffer(8 downto 1);

                                -- get the parity bit
                                receivedParityBit <= 0;
                                if localIncomingBuffer(9) = '1' then
                                    receivedParityBit <= 1;
                                end if;
                                
                                if (parityBitCounter MOD 2) /= receivedParityBit then
                                    -- TODO error hanlding of parity bit here
                                    report "Parity bit error detected"; -- Display an error message
                                end if;

                                -- return to idle state
                                samplingIndex <= 0;
                                cyclesSinceLastSample <= 0;
                                parityBitCounter <= 0;
                                phaseShiftCompleted <= '0';
                                phaseShiftInProgress <= '0';
                                localIncomingBuffer <= "000000000000";

                            end if;

                        end if; -- valid transmission period cycle
                            
                        cyclesSinceLastSample <= cyclesSinceLastSample + 1;

                    end if; -- phaseShiftCompleted = '0'

                end if; -- pin8_ClearToSend = '0'
                
            end if;

        end if;
    end process;


end architecture ;

