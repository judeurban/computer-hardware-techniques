library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;


entity RS232Sender is
    port (

        -- control signals
        referenceClock : in std_logic;
        shouldTransmit : inout std_logic := '0';           -- a local flag that indicates transmission in progress
        baudRate : in integer := 9600;
        clockFrequency : in integer := 2e6;

        -- RS-232 Pins.
        -- There are more but these are the only necessary ones.
        pin3_TransmitData   : out std_logic := '0';        -- (TXD)    data
        pin7_RequestToSend  : inout std_logic := '0';      -- (RTS)    control
        pin8_ClearToSend    : inout std_logic := '0';      -- (CTS)    control

        -- buffer to transmit
        TxBuffer : in std_logic_vector(7 downto 0)         -- switch buffer
    );
end RS232Sender;

architecture RS232SenderArch of RS232Sender is
        
    -- local constants
    constant START_TRANSMISSION_FLAG : std_logic := '1';
    constant END_TRANSMISSION_FLAG   : std_logic := '0';
    
    -- control signals
    signal transmissionIndex : INTEGER := 0;
    signal cyclesSinceLastTransmission : INTEGER :=  0 ;
    signal parityBitCounter : INTEGER := 1;                              -- two by default to include starting bits
    signal bitToTransmit : std_logic := '0';
    signal baudPeriodInClockCycles : integer := 208;               -- 2MHz clock / 9600 default baud rate ~= 208

begin

    -- determine the true period based on the clock cycle and baud rate
    baudPeriodInClockCycles <= clockFrequency / baudRate;

    process(referenceClock)
    begin

        -- always control on a rising edge signal
        if rising_edge(referenceClock) then
                            
            -- transmit if the user raised the flag via the push
            -- or we are sending a message
            if shouldTransmit = '1' then

                -- no message is currently being transmitted
                if pin7_RequestToSend = '0' then

                    -- ask the receiver if they're ready
                    pin7_RequestToSend <= '1';
                    pin8_ClearToSend <= '1';

                -- a message is currently being transmitted
                else

                    -- the receiver is listening 
                    if pin8_ClearToSend = '1' then

                        -- ensure a valid transmission period
                        if cyclesSinceLastTransmission >= baudPeriodInClockCycles then

                            -- set the transmission line based on the transmission index
                            case( transmissionIndex ) is
                            
                                -- frame key:
                                -- 1 thru 8 is "payload"
                                -- 9 is parity
                                -- 10, 11 is ending bits

                                -- starting bit
                                when 0 =>
                                    pin3_TransmitData <= START_TRANSMISSION_FLAG;
                                    if START_TRANSMISSION_FLAG = '1' then
                                        parityBitCounter <= parityBitCounter + 1;
                                    end if;

                                -- parity bit
                                when 9 =>

                                    -- toggle the appropriate parity bit
                                    if (parityBitCounter MOD 2) = 0 then
                                        pin3_TransmitData <= '0';
                                    else
                                        pin3_TransmitData <= '1';
                                    end if;

                                -- first ending bit
                                when 10 =>
                                    pin3_TransmitData <= END_TRANSMISSION_FLAG;

                                -- second ending bit
                                when 11 =>

                                    -- send the final transmission (this happens to be idle state)
                                    pin3_TransmitData <= END_TRANSMISSION_FLAG;

                                    -- reset all signals to idle state
                                    pin7_RequestToSend <= '0';
                                    cyclesSinceLastTransmission <= 0;
                                    transmissionIndex <= 0;
                                    parityBitCounter <= 0;
                                    shouldTransmit <= '0';
                                
                                -- transmit the payload
                                when others =>

                                    bitToTransmit <= TxBuffer(transmissionIndex);
                                    pin3_TransmitData <= bitToTransmit;

                                    -- for parity detection
                                    if bitToTransmit = '1' then
                                        parityBitCounter <= parityBitCounter + 1;
                                    end if;

                            end case; -- transmissionIndex

                            -- keep track of the clock cycles
                            cyclesSinceLastTransmission <= cyclesSinceLastTransmission + 1;

                        end if; -- cyclesSinceLastTransmission >= baudPeriodInClockCycles

                    end if; -- pin8_ClearToSend = '1'

                end if; -- pin8_ClearToSend = '0'
                
            end if; -- shouldTransmit = '1'

            -- Check the status or transition of RTS
            -- idea: use flag signals to wait on signals until 
            -- wait on expected_result, result_tb; wait for 1ns;


        end if;
    end process;


end architecture ;

