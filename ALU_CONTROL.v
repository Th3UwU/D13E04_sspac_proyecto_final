`timescale 1ns/1ns

module ALU_CONTROL
(
	input [5:0]Function,
	input [2:0]ALUOP,
	output reg [3:0]ALUS
);
always @*
begin
	case(ALUOP)

		// TIPO-R
		3'b010:
		begin
			case(Function)
				6'b100000: // ADD
				begin
					ALUS <= 4'b0010;
				end

				6'b100010: // SUB
				begin
					ALUS <= 4'b0110;
				end

				6'b100101: // OR
				begin
					ALUS <= 4'b0001;
				end

				6'b100100: // AND
				begin
					ALUS <= 4'b0000;
				end

				6'b101010: // SLT
				begin
					ALUS <= 4'b0111;
				end

				6'b011000: // MULT
				begin
					ALUS <= 4'b0101;
				end

				6'b011010: // DIV
				begin
					ALUS <= 4'b0110;
				end

				6'b000000: // NOP
				begin
					ALUS <= 4'b0111;
				end

				default:
				begin
					ALUS <= 4'bx;
				end
			endcase 
		end

		// LW / SW
		3'b000:
		begin
			ALUS <= 4'b0010; // ADD
		end

		// BRANCH EQUAL
		3'b001:
		begin
			ALUS <= 4'b0110; // SUB
		end

		// SLTI
		3'b011:
		begin
			ALUS <= 4'b0111; // SLT
		end

		// ANDI
		3'b100:
		begin
			ALUS <= 4'b0000; // AND
		end

		// ORI
		3'b101:
		begin
			ALUS <= 4'b0001; // OR
		end

		default:
		begin
			ALUS <= 4'bx;
		end
	endcase
end

endmodule