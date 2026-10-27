`timescale 1ns / 1ps
`include "GLOBAL.v"

module CTRL(
    input clk,
    input rst,
    input [5:0] opcode,
    input [5:0] funct,

    output reg PCWrite,
    output reg PCWriteCond,
    output reg PCWriteCondNeq,
    output reg IorD,
    output reg MemRead,
    output reg MemWrite,
    output reg IRWrite,
    output reg [1:0] MemtoReg,
    output reg [1:0] RegDst,
    output reg RegWrite,
    output reg ALUSrcA,
    output reg [1:0] ALUSrcB,
    output reg [3:0] ALUOp,
    output reg [1:0] PCSource,
    output reg SignExtend
);

    localparam
        IF  = 3'd0,
        ID  = 3'd1,
        EX  = 3'd2,
        MEM = 3'd3,
        WB  = 3'd4;

    reg [2:0] state, next_state;

    always @(posedge clk) begin
        if (rst) state <= IF;
        else state <= next_state;
    end

    always @(*) begin
        case(state)
            IF: next_state = ID;
            ID: next_state = EX;
            EX: begin
                case(opcode)
                    `OP_LW, `OP_SW: next_state = MEM;
                    `OP_BEQ, `OP_BNE, `OP_J, `OP_JAL: next_state = IF;
                    `OP_RTYPE: next_state = (funct == `FUNCT_JR) ? IF : WB;
                    default: next_state = WB;
                endcase
            end
            MEM: begin
                if (opcode == `OP_LW) next_state = WB;
                else next_state = IF;
            end
            WB: next_state = IF;
            default: next_state = IF;
        endcase
    end

    always @(*) begin
        PCWrite = 0; PCWriteCond = 0; PCWriteCondNeq = 0;
        IorD = 0; MemRead = 0; MemWrite = 0; IRWrite = 0;
        MemtoReg = 2'b00; RegDst = 2'b00; RegWrite = 0;
        ALUSrcA = 0; ALUSrcB = 2'b00; ALUOp = `ALU_ADDU; PCSource = 2'b00;
        SignExtend = 0;

        case(state)
            IF: begin
                MemRead = 1; IRWrite = 1; ALUSrcA = 0; ALUSrcB = 2'b01;
                PCWrite = 1; PCSource = 2'b00; IorD = 0;
            end
            
            ID: begin
                ALUSrcA = 0; ALUSrcB = 2'b11;
                SignExtend = 1;
            end
            
            EX: begin
                ALUSrcA = 1;
                case(opcode)
                    `OP_RTYPE: begin
                        if (funct == `FUNCT_JR) begin
                            PCWrite = 1; PCSource = 2'b11;
                        end else begin
                            ALUSrcB = 2'b00;
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
                    `OP_LW, `OP_SW: begin
                        ALUSrcB = 2'b10; ALUOp = `ALU_ADDU; SignExtend = 1;
                    end
                    `OP_BEQ: begin
                        ALUSrcB = 2'b00; ALUOp = `ALU_SUBU; SignExtend = 1;
                        PCWriteCond = 1; PCSource = 2'b01;
                    end
                    `OP_BNE: begin
                        ALUSrcB = 2'b00; ALUOp = `ALU_SUBU; SignExtend = 1;
                        PCWriteCondNeq = 1; PCSource = 2'b01;
                    end
                    `OP_J: begin
                        PCWrite = 1; PCSource = 2'b10;
                    end
                    `OP_JAL: begin
                        PCWrite = 1; PCSource = 2'b10;
                        RegDst = 2'b10; MemtoReg = 2'b10; RegWrite = 1;
                    end
                    `OP_ADDIU: begin ALUSrcB = 2'b10; ALUOp = `ALU_ADDU; SignExtend = 1; end
                    `OP_ANDI:  begin ALUSrcB = 2'b10; ALUOp = `ALU_AND; SignExtend = 0; end
                    `OP_ORI:   begin ALUSrcB = 2'b10; ALUOp = `ALU_OR; SignExtend = 0; end
                    `OP_XORI:  begin ALUSrcB = 2'b10; ALUOp = `ALU_XOR; SignExtend = 0; end
                    `OP_LUI:   begin ALUSrcB = 2'b10; ALUOp = `ALU_LUI; SignExtend = 0; end
                    `OP_SLTI:  begin ALUSrcB = 2'b10; ALUOp = `ALU_SLT; SignExtend = 1; end
                    `OP_SLTIU: begin ALUSrcB = 2'b10; ALUOp = `ALU_SLTU; SignExtend = 1; end
                    default:   begin ALUSrcA = 0; ALUSrcB = 2'b00; end
                endcase
            end
            
            MEM: begin
                if (opcode == `OP_LW) begin
                    IorD = 1; MemRead = 1;
                end else if (opcode == `OP_SW) begin
                    IorD = 1; MemWrite = 1;
                end
            end
            
            WB: begin
                RegWrite = 1;
                case(opcode)
                    `OP_RTYPE: begin
                        RegDst = 2'b01; MemtoReg = 2'b00;
                    end
                    `OP_LW: begin
                        RegDst = 2'b00; MemtoReg = 2'b01;
                    end
                    default: begin
                        RegDst = 2'b00; MemtoReg = 2'b00;
                    end
                endcase
            end
        endcase
    end
endmodule