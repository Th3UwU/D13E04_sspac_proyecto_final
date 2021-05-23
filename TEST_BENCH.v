`timescale 1ns/1ns

// Creacion del modulo
module TEST_BENCH();

reg clk;

SINGLE_DATAPATH SP
(
	.clk(clk)
);

always
#100
clk = ~clk;

initial
begin
	clk <= 1;
	#1200
	$finish;
end


endmodule : TEST_BENCH