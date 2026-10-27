`timescale 1ns / 1ps

module HAZARD(
    input [4:0] IF_ID_rs,
    input [4:0] IF_ID_rt,
    
    input ID_EX_MemRead,
    input ID_EX_RegWrite,
    input [4:0] ID_EX_rd,
    
    input EX_MEM_MemRead,
    input [4:0] EX_MEM_rd,
    
    input CTRL_BranchEq,
    input CTRL_BranchNeq,
    input CTRL_JumpReg,
    
    input ID_Mispredict,

    output reg PCWrite,     
    output reg IF_ID_Write, 
    output reg IF_ID_Flush, 
    output reg ID_EX_Flush  
);

    always @(*) begin
        PCWrite = 1; IF_ID_Write = 1; IF_ID_Flush = 0; ID_EX_Flush = 0;
        if (ID_EX_MemRead && ID_EX_rd != 0 && (ID_EX_rd == IF_ID_rs || ID_EX_rd == IF_ID_rt)) begin
            PCWrite = 0;
            IF_ID_Write = 0;
            ID_EX_Flush = 1;
        end 
        else if (CTRL_BranchEq || CTRL_BranchNeq || CTRL_JumpReg) begin
            if (ID_EX_RegWrite && ID_EX_rd != 0 && (ID_EX_rd == IF_ID_rs || ID_EX_rd == IF_ID_rt)) begin
                PCWrite = 0; IF_ID_Write = 0; ID_EX_Flush = 1;
            end
            else if (EX_MEM_MemRead && EX_MEM_rd != 0 && (EX_MEM_rd == IF_ID_rs || EX_MEM_rd == IF_ID_rt)) begin
                PCWrite = 0; IF_ID_Write = 0; ID_EX_Flush = 1;
            end
            else if (ID_Mispredict) begin
                IF_ID_Flush = 1;
            end
        end
        else if (ID_Mispredict) begin
            IF_ID_Flush = 1;
        end
    end
endmodule