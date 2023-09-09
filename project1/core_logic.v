module core_logic(push_button, clock, led);
input push_button, clock;
output led;
reg led;
reg [31:0]cnt;

always@(posedge clock)
begin

	led <= push_button;

end

endmodule