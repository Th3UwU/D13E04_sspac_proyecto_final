`timescale 1ns/1ns

module ADDER
(
	input [31:0]IN1,
	input [31:0]IN2,
	output [31:0]OUT
);

assign OUT = IN1 + IN2;

endmodule : ADDER