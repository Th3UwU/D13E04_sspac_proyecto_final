`timescale 1ns/1ns 

module ALU(
	input [31:0]Op1,Op2,
	input [3:0]Sel,
	output reg ZF,
	output reg[31:0]Out

);     
always @* begin         
	case (Sel)  
		4'b0000: Out <= Op1 & Op2; //And
		4'b0001: Out <= Op1 | Op2; //Or
		4'b0010: Out <= Op1 + Op2; //Add
		4'b0110: Out <= Op1 - Op2; //Sub
		4'b0111: Out <= (Op1 < Op2) ? 1 : 0; //SLT
		4'b0101: Out <= Op1 * Op2; //Mul
		4'b0110: Out <= Op1 / Op2; //Div
		4'b0111: Out <= 32'd0;
		default: Out <= 32'b0; 

	endcase      

	if (Out == 32'b0) // Si el resultado de la operacion es 0, activaremos la bandera cero
	begin
		ZF <= 1;
	end
	else
	begin
		ZF <= 0;
	end
end

endmodule
