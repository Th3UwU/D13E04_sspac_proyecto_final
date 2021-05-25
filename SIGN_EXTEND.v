`timescale 1ns/1ns

module SIGN_EXTEND
(
	input [15:0]IN,
	output reg [31:0]OUT
);

always @*
begin
	/*
	// Si es unsigned
	if (IN[15] == 1'b0)
	begin
		OUT <= {16'b0000000000000000, IN};
	end
	// Si es decimal
	else
	begin
		OUT <= {16'b1111111111111111, IN};
	end
	*/

	OUT <= {{16{IN[15]}}, IN};
end


endmodule : SIGN_EXTEND
