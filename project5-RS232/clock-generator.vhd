library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ClockGenerator is
    port (
        clk_out : out std_logic := '0'
    );
end entity ClockGenerator;

architecture Behavioral of ClockGenerator is
    constant CLOCK_PERIOD : time := 500 ns; -- 2MHz clock period (500 ns)
begin
    process
    begin
        clk_out <= '0';
        wait for CLOCK_PERIOD / 2;
        clk_out <= '1';
        wait for CLOCK_PERIOD / 2;
    end process;
end architecture Behavioral;
