module counter(rst, clk, led);
input rst, clk;
output led;
reg led;
reg [31:0]cnt;

// this script toggles the LED at 4Hz

always@(posedge clk or negedge rst)
begin

	// if reset pin is high
	if(rst == 0)
	begin
		cnt <= 0;
		led <= 0;
	end

	// reset pin is low, don't reset
	else
	begin
	
		// if count is greater than five hundred thousand, increment
		if(cnt < 500000)
		begin
			cnt <= cnt + 1;
		end
		// reset
		else
		begin
			cnt <= 0;
			led <= ~led;
		end
	end
end

endmodule
