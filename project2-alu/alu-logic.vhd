library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- define the entity and ports (signals)
entity alu_logic is
    port(
        -- bit array signals
        mode_selector, nibble_a, nibble_b : in std_logic_vector(3 downto 0);
        result : out std_logic_vector(3 downto 0)

    );
end entity alu_logic;

architecture alu_logic_arch of alu_logic is
    constant NOT_A:             std_logic_vector    :=  "0000";
    constant NOT_A_OR_NOT_B:    std_logic_vector    :=  "0001";
    constant NOT_A_AND_B:       std_logic_vector    :=  "0010";
    constant LOGIC_0:           std_logic_vector    :=  "0011";
    constant NOT_AB:            std_logic_vector    :=  "0100";
    constant NOT_B:             std_logic_vector    :=  "0101";
    constant A_XOR_B:           std_logic_vector    :=  "0110";
    constant A_AND_NOT_B:       std_logic_vector    :=  "0111";
    constant NOT_A_OR_B:        std_logic_vector    :=  "1000";
    constant NOT_A_XOR_NOT_B:   std_logic_vector    :=  "1001";
    constant B:                 std_logic_vector    :=  "1010";
    constant A_AND_B:           std_logic_vector    :=  "1011";
    constant LOGIC_1:           std_logic_vector    :=  "1100";
    constant A_OR_NOT_B:        std_logic_vector    :=  "1101";
    constant A_OR_B:            std_logic_vector    :=  "1110";
    constant A:                 std_logic_vector    :=  "1111";
begin
    
    process (mode_selector)
    begin

        -- switch on the mode selector
        case mode_selector is
            when NOT_A =>
                result <= not nibble_a;
            when NOT_A_OR_NOT_B =>
                result <= not nibble_a or not nibble_b;
            when NOT_A_AND_B =>
                result <= not nibble_a and nibble_b;
            when LOGIC_0 =>
                result <= "0000"; -- Constant logic 0
            when NOT_AB =>
                result <= not (nibble_a and nibble_b);
            when NOT_B =>
                result <= not nibble_b;
            when A_XOR_B =>
                result <= nibble_a xor nibble_b;
            when A_AND_NOT_B =>
                result <= nibble_a and not nibble_b;
            when NOT_A_OR_B =>
                result <= not nibble_a or nibble_b;
            when NOT_A_XOR_NOT_B =>
                result <= (not nibble_a) xor (not nibble_b);
            when B =>
                result <= nibble_b;
            when A_AND_B =>
                result <= nibble_a and nibble_b;
            when LOGIC_1 =>
                result <= "1111"; -- Constant logic 1
            when A_OR_NOT_B =>
                result <= nibble_a or not nibble_b;
            when A_OR_B =>
                result <= nibble_a or nibble_b;
            when A =>
                result <= nibble_a;
            when others =>
                result <= "0000"; -- Just default case
        end case;

    end process;
    
end architecture;

