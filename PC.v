`timescale 1ns/1ns

module PC
(
	input clk,
	input [31:0]IN,
	output reg [31:0]OUT
);

initial begin
	OUT = 32'b11111111111111111111111111111100;
end

always @(posedge clk)
begin
	OUT <= IN;
end

endmodule