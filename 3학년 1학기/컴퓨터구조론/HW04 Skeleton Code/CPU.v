`timescale 1ns / 1ps

module CPU(
    input       clk,
    input       rst,
    output      halt
);
    
    wire [31:0] PC_next;
    wire [31:0] mem_addr;
    wire [31:0] mem_read_data;
    wire [31:0] mem_write_data;
    
    wire [31:0] operand1, operand2, alu_result;
    wire [31:0] rd_data1, rd_data2;
    wire [31:0] ext_imm;

    reg [31:0] PC;
    reg [31:0] IR;
    reg [31:0] MDR;
    reg [31:0] A;
    reg [31:0] B;
    reg [31:0] ALUOut;

    wire PCWrite, PCWriteCond, PCWriteCondNeq, IorD, MemRead, MemWrite, IRWrite;
    wire [1:0] MemtoReg, RegDst, ALUSrcB, PCSource;
    wire ALUSrcA, RegWrite, SignExtend;
    wire [3:0] ALUOp;

    wire [5:0] opcode = IR[31:26];
    wire [4:0] rs     = IR[25:21];
    wire [4:0] rt     = IR[20:16];
    wire [4:0] rd     = IR[15:11];
    wire [4:0] shamt  = IR[10:6];
    wire [5:0] funct  = IR[5:0];
    wire [15:0] immi  = IR[15:0];
    wire [25:0] immj  = IR[25:0];

    assign halt = (IR == 32'b0);

    assign ext_imm = SignExtend ? {{16{immi[15]}}, immi} : {16'b0, immi};

    assign mem_addr = IorD ? ALUOut : PC;
    assign mem_write_data = B;

    wire [4:0] wr_addr = (RegDst == 2'b10) ? 5'd31 : 
                         (RegDst == 2'b01) ? rd : rt;

    wire [31:0] wr_data = (MemtoReg == 2'b10) ? PC : 
                          (MemtoReg == 2'b01) ? MDR : ALUOut;

    assign operand1 = ALUSrcA ? A : PC;
    assign operand2 = (ALUSrcB == 2'b11) ? (ext_imm << 2) :
                      (ALUSrcB == 2'b10) ? ext_imm :
                      (ALUSrcB == 2'b01) ? 32'd4 : B;

    assign PC_next = (PCSource == 2'b11) ? A :
                     (PCSource == 2'b10) ? {PC[31:28], immj, 2'b00} :
                     (PCSource == 2'b01) ? ALUOut : alu_result;

    wire Zero = (alu_result == 32'd0);
    wire PCEn = PCWrite | (PCWriteCond & Zero) | (PCWriteCondNeq & ~Zero);

    always @(posedge clk) begin
        if (rst) begin
            PC <= 0;
            IR <= 32'hFFFFFFFF; 
            MDR <= 0; A <= 0; B <= 0; ALUOut <= 0;
        end else begin
            if (PCEn) PC <= PC_next;
            if (IRWrite) IR <= mem_read_data;
            MDR <= mem_read_data;
            A <= rd_data1;
            B <= rd_data2;
            ALUOut <= alu_result;
        end
    end

    CTRL ctrl (
        .clk(clk),
        .rst(rst),
        .opcode(opcode),
        .funct(funct),
        .PCWrite(PCWrite),
        .PCWriteCond(PCWriteCond),
        .PCWriteCondNeq(PCWriteCondNeq),
        .IorD(IorD),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .IRWrite(IRWrite),
        .MemtoReg(MemtoReg),
        .RegDst(RegDst),
        .RegWrite(RegWrite),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ALUOp(ALUOp),
        .PCSource(PCSource),
        .SignExtend(SignExtend)
    );

    RF rf (
        .clk(clk),
        .rst(rst),
        .rd_addr1(rs),
        .rd_addr2(rt),
        .rd_data1(rd_data1),
        .rd_data2(rd_data2),
        .RegWrite(RegWrite),
        .wr_addr(wr_addr),
        .wr_data(wr_data)
    );

    MEM mem (
        .clk(clk),
        .rst(rst),
        .mem_addr(mem_addr),
        .MemWrite(MemWrite),
        .mem_write_data(mem_write_data),
        .mem_read_data(mem_read_data)
    );
    
    ALU alu (
        .operand1(operand1),
        .operand2(operand2),
        .shamt(shamt),
        .funct(ALUOp),
        .alu_result(alu_result)
    );
    
endmodule