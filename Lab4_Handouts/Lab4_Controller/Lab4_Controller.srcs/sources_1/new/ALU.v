`timescale 1ns / 1ps

module ALU(
    input [7:0] A,B,
    input ALU_Sel,
    output [7:0] C
    );
    assign C = ALU_Sel ? A + B : A & B;
endmodule
