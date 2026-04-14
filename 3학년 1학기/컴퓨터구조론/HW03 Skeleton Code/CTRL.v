`timescale 1ns / 1ps
`include "GLOBAL.v"

module CTRL(
	// input opcode and funct
	input [5:0] opcode,
	input [5:0] funct,

	// output various ports
	output reg RegDst,
	output reg Jump,
	output reg Branch,
	output reg JR,
	output reg MemRead,
	output reg MemtoReg,
	output reg MemWrite,
	output reg ALUSrc,
	output reg SignExtend,
	output reg RegWrite,
	output reg [3:0] ALUOp,
	output reg SavePC
    );

	always @(*) begin
		RegDst = 0;
		Jump = 0;
		Branch = 0;
		JR = 0;
		MemRead = 0;
		MemtoReg = 0;
		MemWrite = 0;
		ALUSrc = 0;
		SignExtend = 0;
		RegWrite = 0;
		ALUOp = 4'b0000;
		SavePC = 0;
		case(opcode)
			`OP_RTYPE: begin
				if(funct == `FUNCT_JR) begin
					JR = 1;
				end else begin
					RegDst = 1;
					RegWrite = 1;
					case(funct)
						`FUNCT_ADDU: ALUOp = `ALU_ADDU;
						`FUNCT_SUBU: ALUOp = `ALU_SUBU;
						`FUNCT_AND : ALUOp = `ALU_AND;
						`FUNCT_OR  : ALUOp = `ALU_OR;
						`FUNCT_XOR : ALUOp = `ALU_XOR;
						`FUNCT_NOR : ALUOp = `ALU_NOR;
						`FUNCT_SLT : ALUOp = `ALU_SLT;
						`FUNCT_SLTU: ALUOp = `ALU_SLTU;
						`FUNCT_SLL : ALUOp = `ALU_SLL;
						`FUNCT_SRL : ALUOp = `ALU_SRL;
						`FUNCT_SRA : ALUOp = `ALU_SRA;
					endcase
				end
			end
			`OP_ADDIU: begin
				ALUSrc = 1;
				SignExtend = 1;
				RegWrite = 1;
				ALUOp = `ALU_ADDU;
			end
			`OP_ANDI: begin
				ALUSrc = 1;
				SignExtend = 1;
				RegWrite = 1;
				ALUOp = `ALU_AND;
			end
			`OP_LUI: begin
				ALUSrc = 1;
				SignExtend = 0;
				RegWrite = 1;
				ALUOp = `ALU_LUI;
			end
			`OP_ORI: begin
				ALUSrc = 1;
				SignExtend = 0;
				RegWrite = 1;
				ALUOp = `ALU_OR;
			end
			`OP_SLTI: begin
				ALUSrc = 1;
				SignExtend = 1;
				RegWrite = 1;
				ALUOp = `ALU_SLT;
			end
			`OP_SLTIU: begin
				ALUSrc = 1;
				SignExtend = 1;
				RegWrite = 1;
				ALUOp = `ALU_SLTU;
			end
			`OP_XORI: begin
				ALUSrc = 1;
				SignExtend = 0;
				RegWrite = 1;
				ALUOp = `ALU_XOR;
			end
			`OP_BEQ: begin
				Branch = 1;
				ALUOp = `ALU_EQ;
			end
			`OP_BNE: begin
				Branch = 1;
				ALUOp = `ALU_NEQ;
			end
			`OP_J: begin
				Jump = 1;
			end
			`OP_JAL: begin
				Jump = 1;
				RegWrite = 1;
				SavePC = 1; // 현재 PC 값을 저장하여 나중에 레지스터에 쓸 수 있도록 함
			end
			`OP_LW: begin
				MemRead = 1;
				MemtoReg = 1;
				ALUSrc = 1;
				SignExtend = 1;
				RegWrite = 1;
				ALUOp = `ALU_ADDU;
			end
			`OP_SW: begin
				MemWrite = 1;
				ALUSrc = 1;
				SignExtend = 1;
				ALUOp = `ALU_ADDU;
			end
			default: begin
			end
		endcase
	end
endmodule
