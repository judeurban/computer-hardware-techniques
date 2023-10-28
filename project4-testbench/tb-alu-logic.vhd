library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_logic_tb is
    end entity;

architecture alu_logic_tb_arch of alu_logic_tb is

    -- constant mode type declaration
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

    -- static signals
    constant nibble_a_tb: std_logic_vector := "1010";
    constant nibble_b_tb: std_logic_vector := "1100";
    
    -- dynamic signals
    signal result_tb : std_logic_vector(3 downto 0);
    signal expected_result : std_logic_vector(3 downto 0);
    signal error_detection : std_logic_vector(3 downto 0);
    signal mode_selector_tb : std_logic_vector(3 downto 0);

    -- declare a new component to use the alu logic entity
    component alu_logic
        port(
            -- bit array signals
            mode_selector, nibble_a, nibble_b : in std_logic_vector(3 downto 0);
            result : out std_logic_vector(3 downto 0)
        );
    end component;

begin

    -- instantiate the alu-logic entity and map to internal signals
    inst_alu_logic : alu_logic port map(
        mode_selector => mode_selector_tb,
        nibble_a => nibble_a_tb,
        nibble_b => nibble_b_tb,
        result => result_tb
    );

    alu_process : process
    begin

        -- test structure
        -- 1. Update the mode selector signal.
        -- 2. Update the expected result signal.
        -- 3. Wait on expected_result and result_tb. Wait for 1ns for the write to complete (increases tolerance).
        -- 4. Perform error detection.
        -- 5. Wait for 50 ns to see the waveform.

        -- test: NOT_A
        mode_selector_tb <= NOT_A;
        expected_result <= "0101";
        wait on expected_result, result_tb; wait for 1ns;
        error_detection <= expected_result xor result_tb;
        wait for 50 ns;

        -- test: NOT_A_OR_NOT_B
        mode_selector_tb <= NOT_A_OR_NOT_B;
        expected_result <= "0111";
        wait on expected_result, result_tb; wait for 1ns;
        error_detection <= expected_result xor result_tb;
        wait for 50 ns;

        -- test: NOT_A_AND_B
        mode_selector_tb <= NOT_A_AND_B;
        expected_result <= "0100";
        wait on expected_result, result_tb; wait for 1ns;
        error_detection <= expected_result xor result_tb;
        wait for 50 ns;

        -- test: LOGIC_0
        mode_selector_tb <= LOGIC_0;
        expected_result <= "0000";
        wait on expected_result, result_tb; wait for 1ns;
        error_detection <= expected_result xor result_tb;
        wait for 50 ns;

        -- test: NOT_AB
        mode_selector_tb <= NOT_AB;
        expected_result <= "0111";
        wait on expected_result, result_tb; wait for 1ns;
        error_detection <= expected_result xor result_tb;
        wait for 50 ns;

        -- test: NOT_B
        mode_selector_tb <= NOT_B;
        expected_result <= "0011";
        wait on expected_result, result_tb; wait for 1ns;
        error_detection <= expected_result xor result_tb;
        wait for 50 ns;

        -- test: A_XOR_B
        mode_selector_tb <= A_XOR_B;
        expected_result <= "0110";
        wait on expected_result, result_tb; wait for 1ns;
        error_detection <= expected_result xor result_tb;
        wait for 50 ns;

        -- test: A_AND_NOT_B
        mode_selector_tb <= A_AND_NOT_B;
        expected_result <= "0010";
        wait on expected_result, result_tb; wait for 1ns;
        error_detection <= expected_result xor result_tb;
        wait for 50 ns;

        -- test: NOT_A_OR_B
        mode_selector_tb <= NOT_A_OR_B;
        expected_result <= "1101";
        wait on expected_result, result_tb; wait for 1ns;
        error_detection <= expected_result xor result_tb;
        wait for 50 ns;

        -- test: NOT_A_XOR_NOT_B
        mode_selector_tb <= NOT_A_XOR_NOT_B;
        expected_result <= "0110";
        wait on expected_result, result_tb; wait for 1ns;
        error_detection <= expected_result xor result_tb;
        wait for 50 ns;

        -- test: B
        mode_selector_tb <= B;
        expected_result <= "1100";
        wait on expected_result, result_tb; wait for 1ns;
        error_detection <= expected_result xor result_tb;
        wait for 50 ns;

        -- test: A_AND_B
        mode_selector_tb <= A_AND_B;
        expected_result <= "1000";
        wait on expected_result, result_tb; wait for 1ns;
        error_detection <= expected_result xor result_tb;
        wait for 50 ns;

        -- test: LOGIC_1
        mode_selector_tb <= LOGIC_1;
        expected_result <= "1111";
        wait on expected_result, result_tb; wait for 1ns;
        error_detection <= expected_result xor result_tb;
        wait for 50 ns;

        -- test: A_OR_NOT_B
        mode_selector_tb <= A_OR_NOT_B;
        expected_result <= "1011";
        wait on expected_result, result_tb; wait for 1ns;
        error_detection <= expected_result xor result_tb;
        wait for 50 ns;

        -- test: A_OR_B
        mode_selector_tb <= A_OR_B;
        expected_result <= "1110";
        wait on expected_result, result_tb; wait for 1ns;
        error_detection <= expected_result xor result_tb;
        wait for 50 ns;

        -- test: A
        mode_selector_tb <= A;
        expected_result <= "1010";
        wait on expected_result, result_tb; wait for 1ns;
        error_detection <= expected_result xor result_tb;
        wait for 50 ns;

    end process;

end alu_logic_tb_arch ; -- alu_logic_tb_arch