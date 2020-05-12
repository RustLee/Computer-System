`timescale 1ns / 1ps

module Regs(
    input clk,
    input reset,
    input [7:0] Bus_din, ALU_result, Mem_rdata,
    input PC_Sel, MDR_Sel, ACC_Sel,
    input PC_i, IR_i, MAR_i, MDR_i, ACC_i, SP_i, R_i,   // Write Enable
    input PC_o, MDR_o, ACC_o, SP_o, R_o,                // Output Enable
    output [7:0] PC_to_Bus, MDR_to_Bus, ACC_to_Bus, SP_to_Bus, R_to_Bus,          // Output to Bus
    output [7:0] IR_to_CU, MAR_to_Mem, MDR_to_Mem, ACC_to_ALU,                             // Output to Other Components
    output ZF
    );

reg [7:0] PC, IR, MAR, MDR, ACC, SP, R;

always @(posedge clk)   begin
    if(~reset)  begin
        $strobe("PC: %b \n IR: %b \n MAR: %b \n MDR: %b \n ACC: %b \n SP: %b \n R: %b \n Bus: %b\n", PC, IR, MAR, MDR, ACC, SP, R, Bus_din);
    end
end

// To the bus
assign PC_to_Bus = PC_o ? PC : 8'bzzzzzzzz;
assign MDR_to_Bus = MDR_o ? MDR : 8'bzzzzzzzz;
assign ACC_to_Bus = ACC_o ? ACC : 8'bzzzzzzzz;
assign SP_to_Bus = SP_o ? SP : 8'bzzzzzzzz;
assign R_to_Bus = R_o ? R : 8'bzzzzzzzz;

// To other components
assign IR_to_CU = IR;
assign MAR_to_Mem = MAR;
assign MDR_to_Mem = MDR;
assign ACC_to_ALU = ACC;
// ZF
assign ZF = ~(|ACC);        // IF ACC == 0, ZF = 1

// PC
always @(posedge clk)   begin
    if(reset)   begin
        PC <= 8'b0;
    end else if( PC_Sel == 1'b0 && PC_i ) begin
        PC <= Bus_din;
    end else if ( PC_Sel == 1'b1 && PC_i) begin
        PC <= PC + 1'b1;
    end else begin
        PC <= PC;
    end
end

// IR
always @(posedge clk)   begin
    if(reset)   begin
        IR <= 8'b0;
    end else if( IR_i ) begin
        IR <= Bus_din;
    end else begin
        IR <= IR;
    end
end

// MAR (MAR不输出到总线)
always @(posedge clk)   begin
    if(reset)   begin
        MAR <= 8'b0;
    end else if( MAR_i ) begin
        MAR <= Bus_din;
    end else begin
        MAR <= MAR;
    end
end


// MDR
always @(posedge clk)   begin
    if(reset)   begin
        MDR <= 8'b0;
    end else if( MDR_Sel == 1'b0 && MDR_i ) begin
        MDR <= Bus_din;
    end else if ( MDR_Sel == 1'b1 && MDR_i) begin
        MDR <= Mem_rdata;
    end else begin
        MDR <= MDR;
    end
end

// ACC（ACC输入是ALU输出）
always @(posedge clk)   begin
    if(reset)   begin
        ACC <= 8'b0;
    end else if( ACC_Sel == 1'b1 && ACC_i ) begin
        ACC <= ALU_result;
    end else if( ACC_Sel == 1'b0 && ACC_i ) begin
        ACC <= Bus_din;
    end else begin
        ACC <= ACC;
    end
end

// SP
always @(posedge clk)   begin
    if(reset)   begin
        SP <= 8'b0;
    end else if( SP_i ) begin
        SP <= Bus_din;
    end else begin
        SP <= SP;
    end
end

// R
always @(posedge clk)   begin
    if(reset)   begin
        R <= 8'b0;
    end else if( R_i ) begin
        R <= Bus_din;
    end else begin
        R <= R;
    end
end

endmodule
