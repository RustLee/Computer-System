`timescale 1ns / 1ps

module controller_counter(
    input clk,              // 时钟
    input rst,              // 复位
    input BR,               // 总线请求线
    input BS,               // 总线繁忙信号
    input mode,             // 计数模式
    // 1：从终止点开始的循环模式，0：从固定值开始的固定优先级模式
    input [1:0] cnt_rstval, // 计数器的复位值
    output reg [1:0] cnt    // 计数器的输出值
    );
    
    reg BS_before = 0;
	reg counter = 0;
	reg clk1 = 0;

	always @(posedge clk)
		begin
			if(counter == 1)
				begin
					clk1 <= ~clk1;
					counter <= ~counter;
				end
			else
				begin
					counter <= ~counter;
				end
		end
	
    always @(posedge clk1)
        begin
            if(rst)
                begin
                    cnt <= cnt_rstval;
                end
            else
                begin
                    if(BR == 0 && BS == 0)
                        begin
                            cnt <= cnt_rstval;
                        end
                    if(BR == 1 && BS == 0)
                        begin
                            cnt <= (cnt == 2'b11 ? 2'b00 : cnt + 1);
                        end
                    if(BS == 1)
                        begin
                            cnt <= cnt;
                        end
                    if(BS == 0 && BS_before == 1)
                        begin
                            if(mode == 0)
                                begin
                                    cnt <= cnt_rstval;end
                            else    
                                begin
                                    cnt <= cnt;end
                        end
				end
			BS_before <= BS;
		end
endmodule
