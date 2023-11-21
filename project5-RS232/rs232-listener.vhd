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
        RxTerminal : in std_logic;  -- (RXD)    data
        RTSIn      : in std_logic;   -- (RTS)    control
        CTSOut     : out std_logic;  -- (CTS)    control

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
    signal cyclesSinceLastSample : INTEGER :=  0;
    signal parityBitCounter : INTEGER := 1;             -- two by default to include starting bits
    signal baudPeriodInClockCycles : integer := 208;    -- 2MHz clock / 9600 default baud rate ~= 208
    signal phaseShiftCompleted : std_logic;             -- flag used to indicate if we've shifted baud sampling phase by 180deg.
    signal phaseShiftInProgress : std_logic;            -- flag used to indicate if we've shifted baud sampling phase by 180deg.
    signal incomingBit : std_logic;
    signal receivedParityBit : INTEGER := 0;
    signal transmissionInProgress : std_logic := '0';

    -- local signal that allows read/write
    signal localIncomingBuffer : std_logic_vector(20 downto 0);

    signal halfBaudPeriod : integer; 

begin

    -- determine the true period based on the clock cycle and baud rate
    baudPeriodInClockCycles <= clockFrequency / baudRate;
    halfBaudPeriod <= baudPeriodInClockCycles / 2;

    process(referenceClock)
    begin

        -- always control on a rising edge signal
        if rising_edge(referenceClock) then

            -- the sender wants to send us a message
            -- initiate a new communicate
            if transmissionInProgress = '0' AND RTSIn = '1' then

                CTSOut <= '1';
                transmissionInProgress <= '1';
                report "indicating to the sender that we're listenting";

                phaseShiftCompleted <= '0';

            end if;

            -- we're listening to an active transmisison
            if transmissionInProgress = '1' then

                if phaseShiftCompleted = '0' then

                    -- we just received the first bit of data
                    -- we need to shift phase sampling by pi/2 to sample in the "middle" of the transmission
                    if rising_edge(RxTerminal) OR RxTerminal = '1' then
                        phaseShiftInProgress <= '1';
                        cyclesSinceLastSample <= 0;
                        report "phase shift IP";
                    end if;

                    -- check if we should exit the phase shift
                    if phaseShiftInProgress = '1' then

                        -- we've just seen another period of the clock cycle
                        cyclesSinceLastSample <= cyclesSinceLastSample + 1;

                        -- we just reached the halfway point of transmission
                        if cyclesSinceLastSample >= halfBaudPeriod then

                            report "phase shift completed";
                            report integer'image(halfBaudPeriod);

                            -- highjack the period to immediately read next clock cycle
                            cyclesSinceLastSample <= baudPeriodInClockCycles;
                            phaseShiftInProgress <= '0';
                            phaseShiftCompleted <= '1';

                            -- clear the initiation flag
                            CTSOut <= '0';

                        end if; -- reached halfway point of transmission

                    end if; -- phase shift in progress

                -- phase shift has been completed
                elsif phaseShiftCompleted = '1' then

                    cyclesSinceLastSample <= cyclesSinceLastSample + 1;

                    -- check for a valid sampling cycle
                    if (cyclesSinceLastSample >= baudPeriodInClockCycles) then

                        report "sampling at "; report integer'image(cyclesSinceLastSample);
                        
                        -- we're about to sample a bit
                        cyclesSinceLastSample <= 0;

                        -- sample the voltage of the pin
                        localIncomingBuffer(samplingIndex) <= RxTerminal;
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
                            localIncomingBuffer <= (others => '0');
                            transmissionInProgress <= '0';

                        end if; -- reached end of the sampling index

                    end if; -- valid transmission period cycle
                        
                end if; -- phase shift completed

            end if; -- receiver is listening

        end if; -- rising edge clock cycle

    end process;

end architecture ;

