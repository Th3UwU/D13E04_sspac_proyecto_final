`timescale 1ns/1ns

module SHIFT_LEFT_JUMP
(
	input [25:0]IN,
	output reg [27:0]OUT
);

// assign OUT = {2'b0, (IN << 2)};
always @*
begin
	OUT = {2'b0, IN};
	OUT = OUT << 2;
end

endmodule : SHIFT_LEFT_JUMP
// CORREGIR