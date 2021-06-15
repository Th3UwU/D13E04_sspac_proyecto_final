`timescale 1ns/1ns

module PC
(
	input clk,
	input [31:0]IN,
	output reg [31:0]OUT
);

always @(posedge clk)
begin
	if(~(^IN === 1'bx)) // Si todo valor de 'IN' **NO** tiene una x / indefinido
	begin
		OUT <= IN;
	end
	else
	begin
		OUT <= 32'b0; // Si es indefinido entonces mandamos 0 por default
	end
end

endmodule