`timescale 1ns / 1ps

module BP(
    input clk,
    input rst,
    input [31:0] PC,

    output Pred_Taken,
    output [31:0] Pred_Target,

    input Update_En,
    input [31:0] Update_PC,
    input [31:0] Update_Target,
    input Update_Taken,
    input Update_IsBranch,
    input Update_IsJump
);

    reg [23:0] BTB_Tag [0:63];
    reg [31:0] BTB_Target [0:63];  
    reg [1:0]  BTB_Type [0:63];

    reg [1:0] PHT [0:255]; 

    integer i;
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 64; i = i + 1) begin
                BTB_Type[i] <= 2'b00;
            end
            for (i = 0; i < 256; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
        end else if (Update_En) begin
            BTB_Tag[Update_PC[7:2]] <= Update_PC[31:8];
            BTB_Target[Update_PC[7:2]] <= Update_Target;
            BTB_Type[Update_PC[7:2]] <= Update_IsJump ? 2'b10 : 2'b01;

            if (Update_IsBranch) begin
                case (PHT[Update_PC[9:2]])
                    2'b00: PHT[Update_PC[9:2]] <= Update_Taken ? 2'b01 : 2'b00;
                    2'b01: PHT[Update_PC[9:2]] <= Update_Taken ? 2'b10 : 2'b00;
                    2'b10: PHT[Update_PC[9:2]] <= Update_Taken ? 2'b11 : 2'b01;
                    2'b11: PHT[Update_PC[9:2]] <= Update_Taken ? 2'b11 : 2'b10;
                endcase
            end
        end
    end

    wire [5:0] btb_idx = PC[7:2];
    wire [23:0] btb_tag = PC[31:8];
    wire btb_hit = (BTB_Type[btb_idx] != 2'b00) && (BTB_Tag[btb_idx] == btb_tag);

    wire [1:0] pht_val = PHT[PC[9:2]];

    assign Pred_Target = BTB_Target[btb_idx];
    
    assign Pred_Taken = btb_hit && (BTB_Type[btb_idx] == 2'b10 || (BTB_Type[btb_idx] == 2'b01 && pht_val >= 2'b10));

endmodule