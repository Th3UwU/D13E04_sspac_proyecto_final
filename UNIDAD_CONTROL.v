`timescale 1ns/1ns

// Creacion del modulo
module UNIDAD_CONTROL
(
	input [5:0] IN,

	output reg [1:0] WB, // [0] = RegWrite, [1] = MemToReg
	output reg [2:0] M, // [0] = Branch, [1] = MemRead, [2] = MemWrite
	output reg [4:0] EX // [0] = RegDst, [3:1] = ALUOp, [4] = ALUSrc

	//output reg [2:0] ALU_OP
);

// Bloque always
always @*
begin
	case(IN)
		// Instruccion TIPO-R
		6'b000000:
		begin
			WB[0] = 1; // RegWrite
			WB[1] = 0; // MemToReg

			M[0] = 0; // Branch
			M[1] = 0; // MemRead
			M[2] = 0; // MemWrite

			EX[0] = 1; // RegDst
			EX[3:1] = 3'b010; // ALUOp
			EX[4] = 0; // ALUSrc
		end

		// Instruccion LW
		6'b100011:
		begin
			WB[0] = 1; // RegWrite
			WB[1] = 1; // MemToReg

			M[0] = 0; // Branch
			M[1] = 1; // MemRead
			M[2] = 0; // MemWrite

			EX[0] = 0; // RegDst
			EX[3:1] = 3'b000; // ALUOp
			EX[4] = 1; // ALUSrc
		end

		// Instruccion SW
		6'b101011:
		begin
			WB[0] = 0; // RegWrite
			WB[1] = 1'bx; // MemToReg

			M[0] = 0; // Branch
			M[1] = 0; // MemRead
			M[2] = 1; // MemWrite

			EX[0] = 1'bx; // RegDst
			EX[3:1] = 3'b000; // ALUOp
			EX[4] = 1; // ALUSrc
		end

		// Instruccion BEQ
		6'b000100:
		begin
			WB[0] = 0; // RegWrite
			WB[1] = 1'bx; // MemToReg

			M[0] = 1; // Branch
			M[1] = 0; // MemRead
			M[2] = 0; // MemWrite

			EX[0] = 1'bx; // RegDst
			EX[3:1] = 3'b001; // ALUOp
			EX[4] = 0; // ALUSrc
		end

		// Instrucciones TIPO-I

		// ADDI
		6'b001000:
		begin
			WB[0] = 1; // RegWrite
			WB[1] = 0; // MemToReg

			M[0] = 0; // Branch
			M[1] = 0; // MemRead
			M[2] = 0; // MemWrite

			EX[0] = 0; // RegDst
			EX[3:1] = 3'b000; // ALUOp - ADD
			EX[4] = 1; // ALUSrc
		end

		// SLTI
		6'b001010:
		begin
			WB[0] = 1; // RegWrite
			WB[1] = 0; // MemToReg

			M[0] = 0; // Branch
			M[1] = 0; // MemRead
			M[2] = 0; // MemWrite

			EX[0] = 0; // RegDst
			EX[3:1] = 3'b011; // ALUOp - SLT
			EX[4] = 1; // ALUSrc
		end

		// ANDI
		6'b001100:
		begin
			WB[0] = 1; // RegWrite
			WB[1] = 0; // MemToReg

			M[0] = 0; // Branch
			M[1] = 0; // MemRead
			M[2] = 0; // MemWrite

			EX[0] = 0; // RegDst
			EX[3:1] = 3'b100; // ALUOp - AND
			EX[4] = 1; // ALUSrc
		end

		// ORI
		6'b001101:
		begin
			WB[0] = 1; // RegWrite
			WB[1] = 0; // MemToReg

			M[0] = 0; // Branch
			M[1] = 0; // MemRead
			M[2] = 0; // MemWrite

			EX[0] = 0; // RegDst
			EX[3:1] = 3'b101; // ALUOp - OR
			EX[4] = 1; // ALUSrc
		end

	endcase // IN

	//ALU_OP <= EX[2:1];
end

endmodule : UNIDAD_CONTROL