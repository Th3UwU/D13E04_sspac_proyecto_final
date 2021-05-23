`timescale 1ns/1ns

module SINGLE_DATAPATH
(
	input clk
);

// Cables
wire [31:0] pc_in, pc_out; // PC, ENTRADA-SALIDA
wire [31:0] instruction_out; // SALIDA DE LA INSTRUCCION

wire [4:0]mux_5_out; // SALIDA MUX 5 BITS
// Cables unidad de control
wire reg_dst, branch, mem_read, mem_to_reg, mem_to_write, alu_src, reg_write;
wire [1:0] alu_op;
wire [31:0] mux_mem_out;
wire [31:0] out_read1, out_read2; // Cables salida banco registro
wire [31:0] sign_extend_out; // Salid del sign extend
wire [3:0] alu_s_out; // Selector de la alu
wire [31:0] mux_alu_out; // SALIDA DEL MUX A LA ALU
wire zf_out; // SALIDA BANDERA 0
wire [31:0] alu_result_out; // Salida de la alu
wire [31:0] read_data_out;
wire [31:0]adder_pc_out;
wire [31:0] shift_left_out;
wire [31:0] adder_shift_left_out;
//wire [31:0] mux_pc_out;


// Instancias
PC pc
(
	.clk(clk),
	.IN(pc_in),
	.OUT(pc_out)
);

INSTR_MEM instr_mem
(
	.READ_ADRESS(pc_out),
	.INSTRUCTION(instruction_out)
);

MUX_5 mux_5
(
	.DATA_IMEM1(instruction_out[15:11]),
	.DATA_IMEM2(instruction_out[20:16]),
	.Regdst(reg_dst),
	.DATA_OUT(mux_5_out)
);


UNIDAD_CONTROL unidad_control
(
    .IN(instruction_out[31:26]),
    .MEM_TO_REG(mem_to_reg),
    .REG_WRITE(reg_write),
	.MEM_TO_WRITE(mem_to_write),
    .RegDst(reg_dst),
	.Branch(branch),
	.MemRead(mem_read),
	.AluSrc(alu_src),
	.ALU_OP(alu_op)
);

REGISTRO registro
(
	.READ_REGISTER1(instruction_out[25:21]),
	.READ_REGISTER2(instruction_out[20:16]),
	.WRITE_DATA(mux_mem_out),
	.REG_WRITE(reg_write),
	.WRITE_REGISTER(mux_5_out),

	.READ_1(out_read1),
	.READ_2(out_read2)
);

SIGN_EXTEND sign_extend
(
	.IN(instruction_out[15:0]),
	.OUT(sign_extend_out)
);

ALUC alu_control
(
	.Function(instruction_out[5:0]),
	.ALUOP(alu_op),
	.ALUS(alu_s_out)
);

MUX mux_alu
(
	.IN_1(sign_extend_out),
	.IN_2(out_read2),
	.S(alu_src),
	.DATA_OUT(mux_alu_out)
);

ALU alu
(
	.Op1(out_read1),
	.Op2(mux_alu_out),
	.Sel(alu_s_out),
	.ZF(zf_out),
	.Out(alu_result_out)
);

MEM mem
(
	.MEM_WRITE(mem_to_write),
	.WRITE_DATA(out_read2),
	.READ_DATA(read_data_out),
	.ADRESS(alu_result_out)
);

MUX mux_mem
(
	.IN_1(read_data_out),
	.IN_2(alu_result_out),
	.S(mem_to_reg),
	.DATA_OUT(mux_mem_out)
);

ADDER adder_pc
(
	.IN1(pc_out),
	.IN2(32'd4),
	.OUT(adder_pc_out)
);

SHIFT_LEFT shift_left
(
	.IN(sign_extend_out),
	.OUT(shift_left_out)
);

ADDER adder_shift_left
(
	.IN1(adder_pc_out),
	.IN2(shift_left_out),
	.OUT(adder_shift_left_out)
);

MUX mux_shift
(
	.IN_1(adder_shift_left_out),
	.IN_2(adder_pc_out),
	.S(branch & zf_out),
	.DATA_OUT(pc_in)
);

endmodule