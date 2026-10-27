`timescale 1ns / 1ps
`include "GLOBAL.v"

module CTRL(
    input [5:0] opcode,
    input [5:0] funct,

    output reg RegWrite,
    output reg [1:0] MemtoReg,
    output reg MemRead,
    output reg MemWrite,
    output reg [1:0] RegDst,
    output reg ALUSrcA,
    output reg [1:0] ALUSrcB,
    output reg [3:0] ALUOp,
    output reg SignExtend,
    
    output reg BranchEq,
    output reg BranchNeq,
    output reg Jump,
    output reg JumpReg
);

    always @(*) begin
        RegWrite = 0; MemtoReg = 2'b00; MemRead = 0; MemWrite = 0;
        RegDst = 2'b00; ALUSrcA = 1; ALUSrcB = 2'b00; ALUOp = `ALU_ADDU;
        SignExtend = 0; BranchEq = 0; BranchNeq = 0; Jump = 0; JumpReg = 0;

        case(opcode)
            `OP_RTYPE: begin
                if (funct == `FUNCT_JR) begin
                    JumpReg = 1;
                end else begin
                    RegWrite = 1; RegDst = 2'b01;
                    case(funct)
                        `FUNCT_ADDU: ALUOp = `ALU_ADDU;
                        `FUNCT_SUBU: ALUOp = `ALU_SUBU;
                        `FUNCT_AND:  ALUOp = `ALU_AND;
                        `FUNCT_OR:   ALUOp = `ALU_OR;
                        `FUNCT_XOR:  ALUOp = `ALU_XOR;
                        `FUNCT_NOR:  ALUOp = `ALU_NOR;
                        `FUNCT_SLT:  ALUOp = `ALU_SLT;
                        `FUNCT_SLTU: ALUOp = `ALU_SLTU;
                        `FUNCT_SLL:  ALUOp = `ALU_SLL;
                        `FUNCT_SRL:  ALUOp = `ALU_SRL;
                        `FUNCT_SRA:  ALUOp = `ALU_SRA;
                        default:     ALUOp = `ALU_ADDU;
                    endcase
                end
            end
            `OP_LW: begin
                MemRead = 1; RegWrite = 1; MemtoReg = 2'b01; 
                ALUSrcB = 2'b10; SignExtend = 1; ALUOp = `ALU_ADDU; RegDst = 2'b00;
            end
            `OP_SW: begin
                MemWrite = 1; ALUSrcB = 2'b10; SignExtend = 1; ALUOp = `ALU_ADDU;
            end
            `OP_BEQ: begin
                BranchEq = 1; SignExtend = 1; ALUOp = `ALU_SUBU;
            end
            `OP_BNE: begin
                BranchNeq = 1; SignExtend = 1; ALUOp = `ALU_SUBU;
            end
            `OP_J: begin
                Jump = 1;
            end
            `OP_JAL: begin
                Jump = 1; RegWrite = 1; RegDst = 2'b10; MemtoReg = 2'b10;
            end
            `OP_ADDIU: begin 
                RegWrite = 1; RegDst = 2'b00; ALUSrcB = 2'b10; SignExtend = 1; ALUOp = `ALU_ADDU; 
            end
            `OP_ANDI: begin 
                RegWrite = 1; RegDst = 2'b00; ALUSrcB = 2'b10; SignExtend = 0; ALUOp = `ALU_AND; 
            end
            `OP_ORI: begin 
                RegWrite = 1; RegDst = 2'b00; ALUSrcB = 2'b10; SignExtend = 0; ALUOp = `ALU_OR; 
            end
            `OP_XORI: begin 
                RegWrite = 1; RegDst = 2'b00; ALUSrcB = 2'b10; SignExtend = 0; ALUOp = `ALU_XOR; 
            end
            `OP_LUI: begin 
                RegWrite = 1; RegDst = 2'b00; ALUSrcB = 2'b10; SignExtend = 0; ALUOp = `ALU_LUI; 
            end
            `OP_SLTI: begin 
                RegWrite = 1; RegDst = 2'b00; ALUSrcB = 2'b10; SignExtend = 1; ALUOp = `ALU_SLT; 
            end
            `OP_SLTIU: begin 
                RegWrite = 1; RegDst = 2'b00; ALUSrcB = 2'b10; SignExtend = 1; ALUOp = `ALU_SLTU; 
            end
            default: ;
        endcase
    end
endmodule