`timescale 1ns/1ns

module MUX_5
(
	input [4:0]DATA_IMEM1,
	input [4:0]DATA_IMEM2,
	input Regdst,
	output reg [4:0]DATA_OUT
);

always @*
begin
	if (Regdst)
	begin
		DATA_OUT = DATA_IMEM1;
	end
	else
	begin
		DATA_OUT = DATA_IMEM2;
	end
end

endmodule