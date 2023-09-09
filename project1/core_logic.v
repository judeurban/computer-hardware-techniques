module core_logic(
	bit_0,
	bit_1,
	bit_2,
	clock,
	two_input_AND,
	two_input_NAND,
	three_input_OR,
	two_input_NOR,
	one_bit_Full_Adder,
	two_by_one_MUX,
	two_input_XOR
);

// define I/O
input clock;                    // basically the callback to the core logic
input bit_0, bit_1, bit_2;      // inputs for the push buttons
output two_input_AND, two_input_NAND, three_input_OR, two_input_NOR, one_bit_Full_Adder, two_by_one_MUX, two_input_XOR;

// define I/O types
reg two_input_AND, two_input_NAND, three_input_OR, two_input_NOR, one_bit_Full_Adder, two_by_one_MUX, two_input_XOR;

always @(posedge clock)
begin
    // Assigning individual status for each led
    two_input_AND <= bit_0 & bit_1;      					// 2-input AND
    two_input_NAND <= ~(bit_0 & bit_1);   					// 2-input NAND
    three_input_OR <= (bit_0 | bit_1 | bit_2);  			// 3-input OR
    two_input_NOR <= ~(bit_0 | bit_1);   					// 2-input NOR
    one_bit_Full_Adder <= (bit_0 ^ bit_1) ^ bit_2; 			// 1-bit Full Adder
    two_by_one_MUX <= bit_2 ? bit_1 : bit_0;  				// 2:1 MUX
    two_input_XOR <= bit_0 ^ bit_1;      					// 2-input XOR
end

endmodule
