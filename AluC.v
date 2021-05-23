`timescale 1ns/1ns

module ALUC
(
	input [5:0]Function,
	input [1:0]ALUOP,
	output reg [3:0]ALUS
);
always @*
begin
	case(ALUOP)
		2'b10: 
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
					ALUS <= 4'b101;
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
					ALUS <= 3'bx;
				end
			endcase 
		end

		default:
		begin
			ALUS <= 3'bx;
		end
	endcase 
end

endmodule 