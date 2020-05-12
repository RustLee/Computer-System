`timescale 1ns / 1ps

module top(
    input clk,
    input reset
    );

wire [7:0] IR_in;
wire     ZF,PC_i, IR_i, MAR_i, MDR_i, ACC_i, SP_i, R_i,PC_o, MDR_o, ACC_o, SP_o, R_o,PC_Sel, MDR_Sel, MemRead, MemWrite;
wire ALU_Sel, ACC_Sel;
Control_Unit cu0(
    .clk(clk),
    .reset(reset),
    .IR(IR_in),
    .ZF(ZF),
    .PC_i(PC_i), .IR_i(IR_i), .MAR_i(MAR_i), .MDR_i(MDR_i), .ACC_i(ACC_i), .SP_i(SP_i), .R_i(R_i),
    .PC_o(PC_o), .MDR_o(MDR_o), .ACC_o(ACC_o), .SP_o(SP_o), .R_o(R_o),
    .PC_Sel(PC_Sel), .MDR_Sel(MDR_Sel), .ACC_Sel(ACC_Sel),
    .ALU_Sel(ALU_Sel), 
    // 预留其他控制信号
    .MemRead(MemRead), .MemWrite(MemWrite)
    // 总线源编码
    );

DataPath dp(
    .clk(clk),
    .reset(reset),
    .PC_i(PC_i), .IR_i(IR_i), .MAR_i(MAR_i), .MDR_i(MDR_i), .ACC_i(ACC_i), .SP_i(SP_i), .R_i(R_i),
    .PC_o(PC_o), .MDR_o(MDR_o), .ACC_o(ACC_o), .SP_o(SP_o), .R_o(R_o),
    .PC_Sel(PC_Sel), .MDR_Sel(MDR_Sel), .ACC_Sel(ACC_Sel),
    .ALU_Sel(ALU_Sel), 
    // 预留其他控制信号
    .MemRead(MemRead), .MemWrite(MemWrite),    
    .IR2CU(IR_in),
    .ZF(ZF)
    );
endmodule
