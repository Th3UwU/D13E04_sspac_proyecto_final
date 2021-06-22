`timescale 1ns/1ns

// Creacion del modulo
module TEST_BENCH();

reg clk;

TOP_LEVEL top_level
(
	.clk(clk)
);

always
#100 // CADA CICLO = 200ns
clk = ~clk;

initial
begin
	clk <= 1;
	#783400 // = 0.0007834 segundos
	$stop;
end


endmodule : TEST_BENCH