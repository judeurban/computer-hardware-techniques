library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

entity RS232Listener is
    port (
        referenceClock : in std_logic;
        baudPeriodCC   : in integer;

        -- RS-232 Pins.
        -- There are more but these are the only necessary ones.
        RxTerminal : in std_logic;  -- (RXD)    data
        RTSIn      : in std_logic;   -- (RTS)    control
        CTSOut     : out std_logic;  -- (CTS)    control

        RxSet       : out std_logic;
        RxSetData   : out std_logic_vector(7 downto 0)
    );
end RS232Listener;
    
architecture RS232ListenerArch of RS232Listener is
        
    -- local constants
    constant TRANSMISSION_LENGTH     : integer   := 12;
    constant PARITY_BIT_INDEX        : integer   := 9;
    
    -- local signal that allows read/write
    signal localIncomingBuffer : std_logic_vector(20 downto 0);

    -- control signals
    signal samplingIndex         : integer := 0;
    signal cyclesSinceLastSample : integer :=  0;
    signal halfBaudPeriod        : integer;
    signal parityBitCounter      : integer := 1;         -- two by default to include starting bits
    signal receivedParityBit     : integer := 0;
    signal samplingInProgress    : std_logic := '0';
    signal phaseShiftInProgress  : std_logic;            -- flag used to indicate if we're actively shifting baud sampling phase by 180deg.
    signal phaseShiftCompleted   : std_logic;            -- flag used to indicate if we've shifted baud sampling phase by 180deg.

begin

    -- determine the true period based on the clock cycle and baud rate
    halfBaudPeriod <= baudPeriodCC / 2;

    process(referenceClock)
    begin

        -- always control on a rising edge signal
        if rising_edge(referenceClock) then

            -- the sender wants to send us a message
            -- initiate a new communicattion to inform them that we're listening
            if samplingInProgress = '0' AND RTSIn = '0' then

                CTSOut <= '0';
                samplingInProgress <= '1';
                report "indicating to the sender that we're listenting";

                -- toggle the listener buffer
                RxSet <= '1';

                phaseShiftCompleted <= '0';

            end if;

            -- we're listening to an active transmisison
            if samplingInProgress = '1' then

                if phaseShiftCompleted = '0' then

                    -- we just received the first bit of data
                    -- we need to shift phase sampling by pi/2 to sample in the "middle" of the transmission
                    if RxTerminal = '1' then
                        phaseShiftInProgress <= '1';
                        cyclesSinceLastSample <= 0;
                    end if;

                    -- check if we should exit the phase shift
                    if phaseShiftInProgress = '1' then

                        -- we've just seen another period of the clock cycle
                        cyclesSinceLastSample <= cyclesSinceLastSample + 1;

                        -- we just reached the halfway point of transmission
                        if cyclesSinceLastSample >= halfBaudPeriod then

                            -- highjack the period to immediately read next clock cycle
                            cyclesSinceLastSample <= baudPeriodCC;
                            phaseShiftInProgress <= '0';
                            phaseShiftCompleted <= '1';

                            -- clear the initiation flag
                            CTSOut <= '1';

                        end if; -- reached halfway point of transmission

                    end if; -- phase shift in progress

                -- phase shift has been completed
                elsif phaseShiftCompleted = '1' then

                    cyclesSinceLastSample <= cyclesSinceLastSample + 1;

                    -- check for a valid sampling cycle
                    if (cyclesSinceLastSample >= baudPeriodCC) then

                        -- we're about to sample a bit
                        cyclesSinceLastSample <= 0;

                        -- sample the voltage of the pin
                        localIncomingBuffer(samplingIndex) <= RxTerminal;
                        samplingIndex <= samplingIndex + 1;

                        if RxTerminal = '1' then
                            parityBitCounter <= parityBitCounter + 1;
                        end if;

                        -- we've reached the end of transmission
                        if samplingIndex = TRANSMISSION_LENGTH then

                            -- get the parity bit
                            receivedParityBit <= 0;                     -- by default
                            if localIncomingBuffer(PARITY_BIT_INDEX) = '1' then
                                receivedParityBit <= 1;
                            end if;
                            
                            -- valid transmission, write to the Rx buffer
                            if (parityBitCounter MOD 2) = receivedParityBit then
                                
                                -- write the payload
                                -- not including the parity, starting, or ending bits
                                RxSetData <= localIncomingBuffer(8 downto 1);
                            
                            end if;

                            -- return to idle state
                            samplingIndex <= 0;
                            cyclesSinceLastSample <= 0;
                            parityBitCounter <= 0;
                            phaseShiftCompleted <= '0';
                            phaseShiftInProgress <= '0';
                            localIncomingBuffer <= (others => '0');
                            samplingInProgress <= '0';
                            RxSet <= '0';

                        end if; -- reached end of the sampling index

                    end if; -- valid transmission period cycle
                        
                end if; -- phase shift completed

            end if; -- receiver is listening

        end if; -- rising edge clock cycle

    end process;

end architecture ;

