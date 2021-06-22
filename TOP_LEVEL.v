`timescale 1ns/1ns

module TOP_LEVEL
(
	input clk
);

// Cables
wire [31:0] mux_branch_out;
wire [31:0] pc_in, pc_out;
wire [31:0] instr_mem_out;
wire [31:0] adder_pc_out;
wire [31:0] if_id_out1, if_id_out2;
wire [27:0] shift_left_jump_out;
wire [1:0] wb;
wire [3:0] m;
wire [4:0] ex;
wire [31:0] reg_read_data1, reg_read_data2;
wire [31:0] sign_extend_out;
wire [31:0] id_ex_out1, id_ex_out2, id_ex_out3, id_ex_out4, id_ex_out5;
wire [4:0] id_ex_out6, id_ex_out7;
wire[1:0] id_ex_wb;
wire[3:0] id_ex_m;
wire[4:0] id_ex_ex;
wire [31:0] shift_left_out;
wire [31:0] adder_shift_left_out;
wire [31:0] mux_alu_out;
wire [3:0] alu_s;
wire [31:0] alu_result;
wire alu_zf;
wire [4:0] mux_regdst_out;
wire [31:0] ex_mem_out1, ex_mem_out2, ex_mem_out4, ex_mem_out5;
wire ex_mem_out3;
wire [4:0] ex_mem_out6;
wire [1:0] ex_mem_wb;
wire [3:0] ex_mem_m;
wire [31:0] mem_out;
wire [31:0] mem_wb_out1, mem_wb_out2;
wire [4:0] mem_wb_out3;
wire [1:0] mem_wb_wb;
wire [31:0] mux_memtoreg_out;

// Instancias

MUX_32 mux_branch
(
	.IN_1(ex_mem_out2),
	.IN_2(adder_pc_out),
	.S(ex_mem_m[0] & ex_mem_out3),
	.DATA_OUT(mux_branch_out)
);

MUX_32 mux_jump
(
	.IN_1(ex_mem_out1),
	.IN_2(mux_branch_out),
	.S(ex_mem_m[3]),
	.DATA_OUT(pc_in)
);

PC pc
(
	.clk(clk),
	.IN(pc_in),
	.OUT(pc_out)
);

INSTR_MEM instr_mem
(
	.READ_ADRESS(pc_out),
	.INSTRUCTION(instr_mem_out)
);

ADDER adder_pc
(
	.IN1(pc_out),
	.IN2(32'd4),
	.OUT(adder_pc_out)
);

BUFFER_IF_ID buffer_if_id
(
	.clk(clk),

	.IN1(adder_pc_out),
	.IN2(instr_mem_out),

	.OUT1(if_id_out1),
	.OUT2(if_id_out2)
);

SHIFT_LEFT_JUMP shift_left_jump
(
	.IN(if_id_out2[25:0]),
	.OUT(shift_left_jump_out)
);

UNIDAD_CONTROL unidad_control
(
	.IN(if_id_out2),
	.WB(wb),
	.M(m),
	.EX(ex)
);

REGISTRO registro
(
	.READ_REGISTER1(if_id_out2[25:21]),
	.READ_REGISTER2(if_id_out2[20:16]),
	.WRITE_DATA(mux_memtoreg_out),
	.REG_WRITE(mem_wb_wb[0]),
	.WRITE_REGISTER(mem_wb_out3),

	.READ_1(reg_read_data1),
	.READ_2(reg_read_data2)
);

SIGN_EXTEND sign_extend
(
	.IN(if_id_out2[15:0]),
	.OUT(sign_extend_out)
);

BUFFER_ID_EX buffer_id_ex
(
	.clk(clk),

	.IN1({if_id_out1[31:28], shift_left_jump_out}),
	.IN2(if_id_out1),
	.IN3(reg_read_data1),
	.IN4(reg_read_data2),
	.IN5(sign_extend_out),
	.IN6(if_id_out2[20:16]),
	.IN7(if_id_out2[15:11]),

	.OUT1(id_ex_out1),
	.OUT2(id_ex_out2),
	.OUT3(id_ex_out3),
	.OUT4(id_ex_out4),
	.OUT5(id_ex_out5),
	.OUT6(id_ex_out6),
	.OUT7(id_ex_out7),

	.WB_IN(wb),
	.M_IN(m),
	.EX_IN(ex),

	.WB_OUT(id_ex_wb),
	.M_OUT(id_ex_m),
	.EX_OUT(id_ex_ex)
);

SHIFT_LEFT shift_left
(
	.IN(id_ex_out5),
	.OUT(shift_left_out)
);

ADDER adder_shift_left
(
	.IN1(id_ex_out2),
	.IN2(shift_left_out),
	.OUT(adder_shift_left_out)
);

MUX_32 mux_alu
(
	.IN_1(id_ex_out5),
	.IN_2(id_ex_out4),
	.S(id_ex_ex[4]),
	.DATA_OUT(mux_alu_out)
);

ALU_CONTROL alu_control
(
	.Function(id_ex_out5[5:0]),
	.ALUOP(id_ex_ex[3:1]),
	.ALUS(alu_s)
);

ALU alu
(
	.Op1(id_ex_out3),
	.Op2(mux_alu_out),
	.Sel(alu_s),
	.ZF(alu_zf),
	.Out(alu_result)
);

MUX_5 mux_regdst
(
	.IN_1(id_ex_out7),
	.IN_2(id_ex_out6),
	.S(id_ex_ex[0]),
	.DATA_OUT(mux_regdst_out)
);

BUFFER_EX_MEM buffer_ex_mem
(
	.clk(clk),

	.IN1(id_ex_out1),
	.IN2(adder_shift_left_out),
	.IN3(alu_zf),
	.IN4(alu_result),
	.IN5(id_ex_out4),
	.IN6(mux_regdst_out),

	.OUT1(ex_mem_out1),
	.OUT2(ex_mem_out2),
	.OUT3(ex_mem_out3),
	.OUT4(ex_mem_out4),
	.OUT5(ex_mem_out5),
	.OUT6(ex_mem_out6),

	.WB_IN(id_ex_wb),
	.M_IN(id_ex_m),

	.WB_OUT(ex_mem_wb),
	.M_OUT(ex_mem_m)
);

MEM mem
(
	.MEM_WRITE(ex_mem_m[2]),
	.MEM_READ(ex_mem_m[1]),
	.WRITE_DATA(ex_mem_out5),
	.READ_DATA(mem_out),
	.ADRESS(ex_mem_out4)
);

BUFFER_MEM_WB buffer_mem_wb
(
	.clk(clk),

	.IN1(mem_out),
	.IN2(ex_mem_out4),
	.IN3(ex_mem_out6),

	.OUT1(mem_wb_out1),
	.OUT2(mem_wb_out2),
	.OUT3(mem_wb_out3),

	.WB_IN(ex_mem_wb),

	.WB_OUT(mem_wb_wb)
);

MUX_32 mux_memtoreg
(
	.IN_1(mem_wb_out1),
	.IN_2(mem_wb_out2),
	.S(mem_wb_wb[1]),
	.DATA_OUT(mux_memtoreg_out)
);
endmodule : TOP_LEVEL
