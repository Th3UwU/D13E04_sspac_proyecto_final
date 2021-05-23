`timescale 1ns/1ns

module SHIFT_LEFT
(
	input [31:0]IN,
	output [31:0]OUT
);

assign OUT = IN << 2;

endmodule : SHIFT_LEFT