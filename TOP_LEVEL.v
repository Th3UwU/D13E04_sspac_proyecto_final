`timescale 1ns/1ns

module TOP_LEVEL
(
	input clk
);

// Cables
wire [31:0] mem_out;
wire [31:0] mem_wb_out1;
wire [31:0] mem_wb_out2;
wire [4:0] mem_wb_out3;
wire [31:0] mux_4_out;
wire [31:0] pc_in;
wire [31:0] pc_out;
wire [1:0] uc_wb;
wire [2:0] uc_m;
wire [4:0] uc_ex;
wire [31:0] instr_mem_out;
wire [31:0] adder_pc_out;
wire [31:0] if_id_out1, if_id_out2;
wire [31:0] shift_left_out;
wire [31:0] shift_left_adder_out;
wire [31:0] mux_alu_out;
wire [3:0]alu_s;
wire alu_zf;
wire [31:0] alu_result;
wire [4:0] mux_regdst_out;
wire [31:0] ex_mem_out1;
wire ex_mem_out2;
wire [31:0] ex_mem_out3;
wire [31:0] ex_mem_out4;
wire [4:0] ex_mem_out5;
wire [31:0] reg_read_data1, reg_read_data2;
wire [31:0] sign_extend_out;
wire [31:0]id_ex_out1;
wire [31:0]id_ex_out2;
wire [31:0]id_ex_out3;
wire [31:0]id_ex_out4;
wire [4:0]id_ex_out5;
wire [4:0]id_ex_out6;

wire [1:0] id_ex_wb;
wire [2:0] id_ex_m;
wire [4:0] id_ex_ex;

wire [1:0] ex_mem_wb;
wire [2:0] ex_mem_m;

wire [1:0] mem_wb_wb;

// Instancias
MUX_32 mux_pc
(
	.IN_1(ex_mem_out1),
	.IN_2(adder_pc_out),
	.S(ex_mem_m[0] & ex_mem_out2),
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

UNIDAD_CONTROL unidad_control
(
	.IN(if_id_out2[31:26]),
	.WB(uc_wb),
	.M(uc_m),
	.EX(uc_ex)
);

REGISTRO registro
(
	.READ_REGISTER1(if_id_out2[25:21]),
	.READ_REGISTER2(if_id_out2[20:16]),
	.WRITE_DATA(mux_4_out),
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

	.IN1(if_id_out1), // BUFFER IF/ID
	.IN2(reg_read_data1), // READ DATA 1
	.IN3(reg_read_data2), // READ DATA 2
	.IN4(sign_extend_out), // SIGN EXTEND
	.IN5(if_id_out2[20:16]), // INSTRUCCION
	.IN6(if_id_out2[15:11]), // INSTRUCCION

	.OUT1(id_ex_out1), // ADDER
	.OUT2(id_ex_out2), // ALU
	.OUT3(id_ex_out3), // MUX / EX/MEM
	.OUT4(id_ex_out4), // SHIFT LEFT / ALU CONTROL
	.OUT5(id_ex_out5), // MUX
	.OUT6(id_ex_out6),  // MUX

	.WB_IN(uc_wb),
	.M_IN(uc_m),
	.EX_IN(uc_ex),

	.WB_OUT(id_ex_wb),
	.M_OUT(id_ex_m),
	.EX_OUT(id_ex_ex)
);

SHIFT_LEFT shift_left
(
	.IN(id_ex_out4),
	.OUT(shift_left_out)
);

ADDER adder_shift_left
(
	.IN1(id_ex_out1),
	.IN2(shift_left_out),
	.OUT(shift_left_adder_out)
);

MUX_32 mux_alu
(
	.IN_1(id_ex_out4),
	.IN_2(id_ex_out3),
	.S(id_ex_ex[4]),
	.DATA_OUT(mux_alu_out)
);


ALU alu
(
	.Op1(id_ex_out2),
	.Op2(mux_alu_out),
	.Sel(alu_s),
	.ZF(alu_zf),
	.Out(alu_result)
);

ALU_CONTROL alu_control
(
	.Function(id_ex_out4[5:0]),
	.ALUOP(id_ex_ex[3:1]),
	.ALUS(alu_s)
);

MUX_5 mux_regdst
(
	.IN_1(id_ex_out6),
	.IN_2(id_ex_out5),
	.S(id_ex_ex[0]),
	.DATA_OUT(mux_regdst_out)
);

BUFFER_EX_MEM buffer_ex_mem
(
	.clk(clk),

	.IN1(shift_left_adder_out), // ADDER
	.IN2(alu_zf), // ZF
	.IN3(alu_result), // ALU RESULT
	.IN4(id_ex_out3), // ID/EX
	.IN5(mux_regdst_out), // MUX

	.OUT1(ex_mem_out1), // PC MUX
	.OUT2(ex_mem_out2), // BRANCH/PCSRC
	.OUT3(ex_mem_out3), // MEM ADRESS
	.OUT4(ex_mem_out4), // MEM WRITE DATA
	.OUT5(ex_mem_out5), // MEM/WB

	.WB_IN(id_ex_wb),
	.M_IN(id_ex_m),

	.WB_OUT(ex_mem_wb),
	.M_OUT(ex_mem_m)
);

MEM mem
(
	.MEM_WRITE(ex_mem_m[2]),
	.MEM_READ(ex_mem_m[1]),
	.WRITE_DATA(ex_mem_out4),
	.READ_DATA(mem_out),
	.ADRESS(ex_mem_out3)
);

BUFFER_MEM_WB buffer_mem_wb
(
	.clk(clk),

	.IN1(mem_out),
	.IN2(ex_mem_out3),
	.IN3(ex_mem_out5),

	.OUT1(mem_wb_out1),
	.OUT2(mem_wb_out2),
	.OUT3(mem_wb_out3),

	.WB_IN(ex_mem_wb),

	.WB_OUT(mem_wb_wb)
);

MUX_32 mux_4
(
	.IN_1(mem_wb_out1),
	.IN_2(mem_wb_out2),
	.S(mem_wb_wb[1]),
	.DATA_OUT(mux_4_out)
);

endmodule : TOP_LEVEL