`timescale 1ns / 1ps


module top_counter(
    input clk,rst,
    input [3:0]din_0, din_1, din_2,din_3,
    input BR_in_0, BR_in_1, BR_in_2, BR_in_3,
    input mode,
    input [1:0]cnt_rstval,
    output [3:0] dbus_out
    );
	
	wire BR_out_0,BR_out_1,BR_out_2,BR_out_3;
	wire BS_out_0,BS_out_1,BS_out_2,BS_out_3;
	
	parameter[1:0] device_id0 = 2'b00;
	parameter[1:0] device_id1 = 2'b01;
	parameter[1:0] device_id2 = 2'b10;
	parameter[1:0] device_id3 = 2'b11;
	
	reg BS = 0;
	reg BR = 0;
	wire[1:0] cnt;
	
	always @(posedge clk)
		begin
			if(rst)
				begin
					BS <= 0;
					BR <= 0;
				end
            else
                begin
                    if(BR_out_0 == 1||BR_out_1 == 1||BR_out_2 == 1||BR_out_3 == 1)
                        begin 
                            BR <= 1; 
                        end
                    else 
                        begin 
                            BR <= 0; 
                        end
                    if(BS_out_0 == 1||BS_out_1 == 1||BS_out_2 == 1||BS_out_3 == 1)
                        begin 
                            BS <= 1; 
                        end 
                    else 
                        begin 
                            BS <= 0; 
                        end
                end				
		end
		
    controller_counter c0(clk,rst,BR,BS,mode,cnt_rstval,cnt);    
    io_interface_counter S0(clk,rst,BR_in_0,BR_out_0,BS_out_0,din_0,dbus_out,device_id0,cnt);
    io_interface_counter S1(clk,rst,BR_in_1,BR_out_1,BS_out_1,din_1,dbus_out,device_id1,cnt);
    io_interface_counter S2(clk,rst,BR_in_2,BR_out_2,BS_out_2,din_2,dbus_out,device_id2,cnt);
    io_interface_counter S3(clk,rst,BR_in_3,BR_out_3,BS_out_3,din_3,dbus_out,device_id3,cnt);  
		
endmodule
