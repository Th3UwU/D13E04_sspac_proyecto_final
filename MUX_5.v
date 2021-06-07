`timescale 1ns/1ns

module MUX_5
(
	input [4:0]IN_1,
	input [4:0]IN_2,
	input S,
	output reg [4:0]DATA_OUT
);

always @*
begin
	if (S)
	begin
		DATA_OUT = IN_1;
	end
	else
	begin
		DATA_OUT = IN_2;
	end
end

endmodule : MUX_5