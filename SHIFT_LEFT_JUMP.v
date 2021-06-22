`timescale 1ns/1ns

module SHIFT_LEFT_JUMP
(
	input [25:0]IN,
	output reg [27:0]OUT
);

assign OUT = {IN, 2'b0};

endmodule : SHIFT_LEFT_JUMP