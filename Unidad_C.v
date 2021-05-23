`timescale 1ns/1ns

// Creacion del modulo
module UNIDAD_CONTROL
(
    input [5:0]IN,
    output reg MEM_TO_REG,
    output reg REG_WRITE,
    output reg MEM_TO_WRITE,
    output reg RegDst,
	output reg Branch,
	output reg MemRead,
	output reg AluSrc,
    output reg [1:0]ALU_OP // Es de 2 bits como indica la tabla del libro (pag. 283 del pdf)
);

// Bloque always
always @*
begin
    case(IN)
        6'd0:
        begin
            MEM_TO_REG = 0;
            REG_WRITE = 1;
            MEM_TO_WRITE = 0;
            RegDst = 1;
            Branch = 0;
            MemRead = 0;
            AluSrc = 0;
            ALU_OP = 2'b10; // <-- basado en la tabla del libro
        end

        default:
        begin
            MEM_TO_REG = 1'bx;
            REG_WRITE = 1'bx;
            MEM_TO_WRITE = 1'bx;
            RegDst = 1'bx;
            Branch = 1'bx;
            MemRead = 1'bx;
            AluSrc = 1'bx;
            ALU_OP = 2'bx;
        end
    endcase // IN
end

endmodule : UNIDAD_CONTROL