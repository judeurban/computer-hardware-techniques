library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity RS232Logic is
  port (

    REF_CLK : in std_logic := '0';

    -- RS-232 Pins
    pin1_Data_Carrier_Detect      : in std_logic := '0';          -- (DCD)    status
    pin2_Receive_Data             : in std_logic := '0';          -- (RXD)    data
    pin3_Transmit_Data            : out std_logic := '0';         -- (TXD)    data
    pin4_Data_Terminal_Ready      : inout std_logic := '0';       -- (DTR)    control
    pin5_Signal_Ground            : inout std_logic := '0';       -- (GND)    -
    pin6_Data_Set_Ready           : inout std_logic := '0';       -- (DSR)    control
    pin7_Request_To_Send          : inout std_logic := '0';       -- (RTS)    control
    pin8_Clear_To_Send            : inout std_logic := '0';       -- (CTS)    control
    pin9_Ring_Indicator           : in std_logic := '0'           -- (RI)     status

  );
end RS232Logic ; 

architecture arch of RS232Logic is

    -- local constants
    constant START_TRANSMISSION_FLAG : std_logic := '1';
    constant END_TRANSMISSION_FLAG   : std_logic := '0';

begin

    process(REF_CLK)
    begin
        if rising_edge(REF_CLK) then
            -- Check the status or transition of RTS

            if RTS = '1' then
                -- RTS is asserted, do some logic
            else
                -- RTS is not asserted, do some other logic or nothing
            end if;
            
        end if;
    end process;


end architecture ;

