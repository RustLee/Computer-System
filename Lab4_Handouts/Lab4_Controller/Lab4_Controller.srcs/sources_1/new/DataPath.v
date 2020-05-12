`timescale 1ns / 1ps

module DataPath(
    input clk,
    input reset,
    input PC_i, IR_i, MAR_i, MDR_i, ACC_i, SP_i, R_i,
    input PC_o, MDR_o, ACC_o, SP_o, R_o,
    input PC_Sel, MDR_Sel, ACC_Sel,
    input ALU_Sel,
    // 预留其他控制信号
    input MemRead, MemWrite,    
    output [7:0] IR2CU,
    output ZF
    );

wire [7:0] Bus, ALU2Reg, Mem2Reg;
wire [7:0] MAR2Mem, MDR2Mem, ACC2ALU;

// Regs
Regs R0(
    .clk(clk),
    .reset(reset),
    .Bus_din(Bus), .ALU_result(ALU2Reg), .Mem_rdata(Mem2Reg),
    .PC_Sel(PC_Sel), .MDR_Sel(MDR_Sel), .ACC_Sel(ACC_Sel), 
    .PC_i(PC_i), .IR_i(IR_i), .MAR_i(MAR_i), .MDR_i(MDR_i), .ACC_i(ACC_i), .SP_i(SP_i), .R_i(R_i),          // Write Enable
    .PC_o(PC_o), .MDR_o(MDR_o), .ACC_o(ACC_o), .SP_o(SP_o), .R_o(R_o),                                      // Output Enable
    .PC_to_Bus(Bus), .MDR_to_Bus(Bus), .ACC_to_Bus(Bus), .SP_to_Bus(Bus), .R_to_Bus(Bus),                   // Output to Bus
    .IR_to_CU(IR2CU), .MAR_to_Mem(MAR2Mem), .MDR_to_Mem(MDR2Mem), .ACC_to_ALU(ACC2ALU),                     // Output to Other Components
    .ZF(ZF)
    );

// Mem
mem_wrap mm0( .clk(clk), .addr(MAR2Mem), .rreq(MemRead), .wreq(MemWrite), .dout(Mem2Reg), .din(MDR2Mem));
             
// ALU
ALU alu0( .A(Bus), .B(ACC2ALU), .ALU_Sel(ALU_Sel), .C(ALU2Reg));

endmodule
