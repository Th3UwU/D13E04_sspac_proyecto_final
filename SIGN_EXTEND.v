`timescale 1ns/1ns

module SIGN_EXTEND
(
	input [15:0]IN,
	output reg [31:0]OUT
);

always @*
begin
	OUT <= {{16{IN[15]}}, IN};
end

endmodule : SIGN_EXTEND