`timescale 1ns / 1ps

module CPU(
    input clk,
    input rst,
    output halt
);
    reg [31:0] PC;
    wire [31:0] IF_Inst;
    wire [31:0] PC_plus4 = PC + 4;
    wire [31:0] next_PC;
    wire PCWrite;

    MEM imem (
        .clk(clk), .rst(rst),
        .mem_addr(PC),
        .MemWrite(1'b0),
        .mem_write_data(32'b0),
        .mem_read_data(IF_Inst)
    );

    always @(posedge clk) begin
        if (rst) PC <= 32'd0;
        else if (PCWrite) PC <= next_PC;
    end

    reg [31:0] IF_ID_PC_plus4;
    reg [31:0] IF_ID_Inst;
    reg [31:0] IF_ID_Pred_PC;
    wire IF_ID_Write, IF_ID_Flush;
    
    wire Pred_Taken;
    wire [31:0] Pred_Target;
    
    always @(posedge clk) begin
        if (rst || IF_ID_Flush) begin
            IF_ID_PC_plus4 <= 32'd0;
            IF_ID_Inst <= 32'd0;
            IF_ID_Pred_PC <= 32'd0;
        end else if (IF_ID_Write) begin
            IF_ID_PC_plus4 <= PC_plus4;
            IF_ID_Inst <= IF_Inst;
            IF_ID_Pred_PC <= Pred_Taken ? Pred_Target : PC_plus4;
        end
    end

    wire [5:0] opcode = IF_ID_Inst[31:26];
    wire [4:0] rs     = IF_ID_Inst[25:21];
    wire [4:0] rt     = IF_ID_Inst[20:16];
    wire [4:0] rd     = IF_ID_Inst[15:11];
    wire [4:0] shamt  = IF_ID_Inst[10:6];
    wire [5:0] funct  = IF_ID_Inst[5:0];
    wire [15:0] imm16 = IF_ID_Inst[15:0];
    wire [25:0] jump_addr = IF_ID_Inst[25:0];

    wire CTRL_RegWrite, CTRL_MemRead, CTRL_MemWrite, CTRL_SignExtend, CTRL_ALUSrcA;
    wire CTRL_BranchEq, CTRL_BranchNeq, CTRL_Jump, CTRL_JumpReg;
    wire [1:0] CTRL_MemtoReg, CTRL_RegDst, CTRL_ALUSrcB;
    wire [3:0] CTRL_ALUOp;

    CTRL ctrl (
        .opcode(opcode), .funct(funct),
        .RegWrite(CTRL_RegWrite), .MemtoReg(CTRL_MemtoReg), .MemRead(CTRL_MemRead),
        .MemWrite(CTRL_MemWrite), .RegDst(CTRL_RegDst), .ALUSrcA(CTRL_ALUSrcA),
        .ALUSrcB(CTRL_ALUSrcB), .ALUOp(CTRL_ALUOp), .SignExtend(CTRL_SignExtend),
        .BranchEq(CTRL_BranchEq), .BranchNeq(CTRL_BranchNeq), .Jump(CTRL_Jump), .JumpReg(CTRL_JumpReg)
    );

    wire [31:0] rd_data1, rd_data2;
    wire MEM_WB_RegWrite;
    wire [4:0] MEM_WB_DestReg;
    wire [31:0] MEM_WB_WriteData;
    
    reg EX_MEM_RegWrite;
    reg [4:0] EX_MEM_DestReg;
    reg [31:0] EX_MEM_ALUResult;

    RF rf (
        .clk(clk), .rst(rst),
        .rd_addr1(rs), .rd_addr2(rt),
        .rd_data1(rd_data1), .rd_data2(rd_data2),
        .RegWrite(MEM_WB_RegWrite),
        .wr_addr(MEM_WB_DestReg),
        .wr_data(MEM_WB_WriteData)
    );

    wire [31:0] SignExtImm = CTRL_SignExtend ? {{16{imm16[15]}}, imm16} : {16'd0, imm16};
    
    wire [31:0] ID_rs_data = (rs == 0) ? 32'd0 :
                             (EX_MEM_RegWrite && EX_MEM_DestReg == rs) ? EX_MEM_ALUResult : rd_data1;
    wire [31:0] ID_rt_data = (rt == 0) ? 32'd0 :
                             (EX_MEM_RegWrite && EX_MEM_DestReg == rt) ? EX_MEM_ALUResult : rd_data2;

    wire IsEqual = (ID_rs_data == ID_rt_data);
    wire BranchTaken = (CTRL_BranchEq & IsEqual) | (CTRL_BranchNeq & ~IsEqual);

    wire [31:0] BranchTarget = IF_ID_PC_plus4 + (SignExtImm << 2);
    wire [31:0] JumpTarget = {IF_ID_PC_plus4[31:28], jump_addr, 2'b00};

    wire [31:0] Actual_Next_PC = CTRL_JumpReg ? ID_rs_data :
                                 CTRL_Jump ? JumpTarget :
                                 BranchTaken ? BranchTarget : IF_ID_PC_plus4;

    wire ID_IsBranchOrJump = CTRL_BranchEq || CTRL_BranchNeq || CTRL_Jump || CTRL_JumpReg;
    wire ID_Mispredict = ID_IsBranchOrJump && (Actual_Next_PC != IF_ID_Pred_PC) && (IF_ID_Inst != 32'b0);

    assign next_PC = ID_Mispredict ? Actual_Next_PC :
                     Pred_Taken ? Pred_Target : PC_plus4;

    wire BP_Update_En = (CTRL_BranchEq || CTRL_BranchNeq || CTRL_Jump) && (IF_ID_Inst != 32'b0);
    BP bp_unit(
        .clk(clk), .rst(rst),
        .PC(PC),
        .Pred_Taken(Pred_Taken), .Pred_Target(Pred_Target),
        .Update_En(BP_Update_En),
        .Update_PC(IF_ID_PC_plus4 - 4),
        .Update_Target(CTRL_Jump ? JumpTarget : BranchTarget),
        .Update_Taken(CTRL_Jump ? 1'b1 : BranchTaken),
        .Update_IsBranch(CTRL_BranchEq || CTRL_BranchNeq),
        .Update_IsJump(CTRL_Jump)
    );

    wire ID_EX_Flush;
    reg ID_EX_RegWrite, ID_EX_MemRead, ID_EX_MemWrite, ID_EX_ALUSrcA;
    reg [1:0] ID_EX_MemtoReg, ID_EX_RegDst, ID_EX_ALUSrcB;
    reg [3:0] ID_EX_ALUOp;
    reg [31:0] ID_EX_PC_plus4, ID_EX_ReadData1, ID_EX_ReadData2, ID_EX_SignExtImm;
    reg [4:0] ID_EX_rs, ID_EX_rt, ID_EX_rd, ID_EX_shamt;

    always @(posedge clk) begin
        if (rst || ID_EX_Flush) begin
            ID_EX_RegWrite <= 0; ID_EX_MemRead <= 0; ID_EX_MemWrite <= 0;
            ID_EX_MemtoReg <= 0; ID_EX_RegDst <= 0; ID_EX_ALUSrcA <= 0; ID_EX_ALUSrcB <= 0;
            ID_EX_ALUOp <= 0; ID_EX_PC_plus4 <= 0; ID_EX_ReadData1 <= 0; ID_EX_ReadData2 <= 0;
            ID_EX_SignExtImm <= 0; ID_EX_rs <= 0; ID_EX_rt <= 0; ID_EX_rd <= 0; ID_EX_shamt <= 0;
        end else begin
            ID_EX_RegWrite <= CTRL_RegWrite; ID_EX_MemtoReg <= CTRL_MemtoReg;
            ID_EX_MemRead <= CTRL_MemRead; ID_EX_MemWrite <= CTRL_MemWrite;
            ID_EX_RegDst <= CTRL_RegDst; ID_EX_ALUSrcA <= CTRL_ALUSrcA;
            ID_EX_ALUSrcB <= CTRL_ALUSrcB; ID_EX_ALUOp <= CTRL_ALUOp;
            ID_EX_PC_plus4 <= IF_ID_PC_plus4;
            ID_EX_ReadData1 <= rd_data1; ID_EX_ReadData2 <= rd_data2;
            ID_EX_SignExtImm <= SignExtImm; ID_EX_rs <= rs; ID_EX_rt <= rt;
            ID_EX_rd <= rd; ID_EX_shamt <= shamt;
        end
    end

    wire [1:0] ForwardA = (EX_MEM_RegWrite && EX_MEM_DestReg != 0 && EX_MEM_DestReg == ID_EX_rs) ? 2'b10 :
                          (MEM_WB_RegWrite && MEM_WB_DestReg != 0 && MEM_WB_DestReg == ID_EX_rs) ? 2'b01 : 2'b00;

    wire [1:0] ForwardB = (EX_MEM_RegWrite && EX_MEM_DestReg != 0 && EX_MEM_DestReg == ID_EX_rt) ? 2'b10 :
                          (MEM_WB_RegWrite && MEM_WB_DestReg != 0 && MEM_WB_DestReg == ID_EX_rt) ? 2'b01 : 2'b00;

    wire [31:0] forwardA_data = (ForwardA == 2'b10) ? EX_MEM_ALUResult :
                                (ForwardA == 2'b01) ? MEM_WB_WriteData : ID_EX_ReadData1;

    wire [31:0] forwardB_data = (ForwardB == 2'b10) ? EX_MEM_ALUResult :
                                (ForwardB == 2'b01) ? MEM_WB_WriteData : ID_EX_ReadData2;

    wire [31:0] ALU_operand1 = ID_EX_ALUSrcA ? forwardA_data : ID_EX_PC_plus4;
    wire [31:0] ALU_operand2 = (ID_EX_ALUSrcB == 2'b00) ? forwardB_data :
                               (ID_EX_ALUSrcB == 2'b10) ? ID_EX_SignExtImm : 32'd0;

    wire [31:0] alu_result;
    
    ALU alu (
        .operand1(ALU_operand1),
        .operand2(ALU_operand2),
        .shamt(ID_EX_shamt),
        .funct(ID_EX_ALUOp),
        .alu_result(alu_result)
    );

    wire [4:0] EX_DestReg = (ID_EX_RegDst == 2'b00) ? ID_EX_rt :
                            (ID_EX_RegDst == 2'b01) ? ID_EX_rd : 5'd31;

    reg EX_MEM_MemRead, EX_MEM_MemWrite;
    reg [1:0] EX_MEM_MemtoReg;
    reg [31:0] EX_MEM_WriteData, EX_MEM_PC_plus4;

    always @(posedge clk) begin
        if (rst) begin
            EX_MEM_RegWrite <= 0; EX_MEM_MemRead <= 0; EX_MEM_MemWrite <= 0;
            EX_MEM_MemtoReg <= 0; EX_MEM_ALUResult <= 0; EX_MEM_WriteData <= 0;
            EX_MEM_PC_plus4 <= 0; EX_MEM_DestReg <= 0;
        end else begin
            EX_MEM_RegWrite <= ID_EX_RegWrite; EX_MEM_MemtoReg <= ID_EX_MemtoReg;
            EX_MEM_MemRead  <= ID_EX_MemRead; EX_MEM_MemWrite <= ID_EX_MemWrite;
            EX_MEM_ALUResult <= alu_result;
            EX_MEM_WriteData <= forwardB_data;
            EX_MEM_PC_plus4 <= ID_EX_PC_plus4;
            EX_MEM_DestReg  <= EX_DestReg;
        end
    end

    wire [31:0] dmem_read_data;
    MEM mem (
        .clk(clk), .rst(rst),
        .mem_addr(EX_MEM_ALUResult),
        .MemWrite(EX_MEM_MemWrite),
        .mem_write_data(EX_MEM_WriteData),
        .mem_read_data(dmem_read_data)
    );

    reg MEM_WB_MemRead;
    reg [1:0] MEM_WB_MemtoReg;
    reg [31:0] MEM_WB_ALUResult, MEM_WB_MemData, MEM_WB_PC_plus4;
    reg [4:0] mem_wb_dest_reg_internal;

    always @(posedge clk) begin
        if (rst) begin
            MEM_WB_MemRead <= 0; MEM_WB_MemtoReg <= 0; MEM_WB_ALUResult <= 0;
            MEM_WB_MemData <= 0; MEM_WB_PC_plus4 <= 0; mem_wb_dest_reg_internal <= 0;
        end else begin
            MEM_WB_MemtoReg <= EX_MEM_MemtoReg;
            MEM_WB_ALUResult <= EX_MEM_ALUResult;
            MEM_WB_MemData <= dmem_read_data;
            MEM_WB_PC_plus4 <= EX_MEM_PC_plus4;
            mem_wb_dest_reg_internal <= EX_MEM_DestReg;
        end
    end
    
    reg MEM_WB_RegWrite_reg;
    always @(posedge clk) begin
        if(rst) MEM_WB_RegWrite_reg <= 0;
        else MEM_WB_RegWrite_reg <= EX_MEM_RegWrite;
    end

    assign MEM_WB_RegWrite = MEM_WB_RegWrite_reg;
    assign MEM_WB_DestReg = mem_wb_dest_reg_internal;

    assign MEM_WB_WriteData = (MEM_WB_MemtoReg == 2'b00) ? MEM_WB_ALUResult :
                              (MEM_WB_MemtoReg == 2'b01) ? MEM_WB_MemData : MEM_WB_PC_plus4;

    HAZARD hazard_unit (
        .IF_ID_rs(rs),
        .IF_ID_rt(rt),
        .ID_EX_MemRead(ID_EX_MemRead),
        .ID_EX_RegWrite(ID_EX_RegWrite),
        .ID_EX_rd(EX_DestReg),
        .EX_MEM_MemRead(EX_MEM_MemRead),
        .EX_MEM_rd(EX_MEM_DestReg),
        .CTRL_BranchEq(CTRL_BranchEq),
        .CTRL_BranchNeq(CTRL_BranchNeq),
        .CTRL_JumpReg(CTRL_JumpReg),
        .ID_Mispredict(ID_Mispredict),
        .PCWrite(PCWrite),
        .IF_ID_Write(IF_ID_Write),
        .IF_ID_Flush(IF_ID_Flush),
        .ID_EX_Flush(ID_EX_Flush)
    );

    reg [4:0] halt_pipe;
    always @(posedge clk) begin
        if (rst) begin
            halt_pipe <= 5'b0;
        end else if (IF_ID_Write) begin 
            halt_pipe <= {halt_pipe[3:0], (IF_Inst == 32'b0 || IF_Inst == 32'hFFFFFFFF)};
        end
    end
    
    assign halt = halt_pipe[4];
endmodule