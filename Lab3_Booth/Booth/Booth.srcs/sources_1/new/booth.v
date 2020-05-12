`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/02 11:02:56
// Design Name: 
// Module Name: booth
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module booth(
    input clk,        // 时钟信号
    input [7:0] x,    // 乘数
    input [7:0] y,    // 被乘数
    input start,      // 输入就绪信号
    output [15:0] z,  // 积
    output reg busy       // 输出就绪信号
    );
    
    parameter IDLE = 3'd0;
	parameter IMPROVE_MC = 3'd1;
	parameter MUL_MOV = 3'd2;
	parameter MUL_END = 3'd3;
	
	reg[2:0] cur_state,next_state;
	reg[7:0] x_data,x_data_2,y_data;
	reg[16:0] z_data;
	reg[4:0] cnt; 
	
	always @(posedge clk or posedge start)
		if(start)
			begin
				cur_state <= IDLE;
			end
		else
			begin
				cur_state <= next_state;
			end
		
	always @(cur_state or cnt)
		begin
			case(cur_state)
				IDLE:begin
						next_state = IMPROVE_MC;
				end
				IMPROVE_MC:begin
					next_state = MUL_MOV;
				end
				MUL_MOV:begin
					if(cnt >= 7)
						next_state = MUL_END;
					else
						next_state = MUL_MOV;
				end
				MUL_END:begin
					next_state = IDLE;
				end
				default:begin
					next_state = IDLE;
				end
			endcase
		end
			
	always@(cur_state or cnt)
		begin
			case(cur_state)
				IDLE:begin
					busy = 1;
				end
				IMPROVE_MC:begin
					x_data = x;
					x_data_2 = ~x + 1'b1;
					y_data = y;
					z_data = {8'd0,y_data,1'b0};
				end
				MUL_MOV:begin
					if(z_data[1:0] == 2'b01)
					    begin
							z_data = {(z_data[16:9] + x_data[7:0]),z_data[8:0]};
						end
					else if(z_data[1:0] == 2'b10)
						begin
							z_data = {(z_data[16:9] + x_data_2[7:0]),z_data[8:0]};
						end
					z_data = {z_data[16],z_data[16:1]};
				end
				MUL_END:begin
					busy = 0;
				end
			endcase
		end
		
	always@ (posedge clk)
		begin
			if (start)
				begin
					cnt <= 0;
				end
			else if((cur_state == MUL_MOV) && (cnt < 7))
				begin
					cnt <= cnt + 1'b1;
				end
			else if((cnt >= 7) && (cur_state ==MUL_END))
				begin
					cnt <= 0;
				end
		end
	
	reg[16:0] z_data_2;
	
	always@ (*)
        begin
            if(cur_state == MUL_END)
                z_data_2 = z_data;
        end
            	
	assign z = z_data_2[16:1];
					
    // 在此处编写你的代码
endmodule
