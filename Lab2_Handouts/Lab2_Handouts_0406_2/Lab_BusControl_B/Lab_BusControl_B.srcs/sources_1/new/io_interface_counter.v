`timescale 1ns / 1ps

module io_interface_counter(
    input clk,
    input rst,
    input   BR_in,              // 外部输入的总线请求
    output reg BR_out,         // 输出：总线请求信号
    output reg BS_out,             // 输出：总线忙信号
    input   [3:0]din,           // 请求地址：外部输入
    output wire [3:0]dout,          // 放在地址总线上的数据
    input   [1:0] device_id,    // 设备地址（配置）
    input   [1:0] cnt_in        // 计数器输入
    );

// 不使用总线时，必须输出高阻态（z)
	reg ena = 1'b0;
	always @(*)
		begin
			if(BR_in)
				begin
					if(cnt_in == device_id)
						begin
							BR_out <= 1;
							BS_out <= 1;
							ena <= 1;
						end
					else
						begin
							BR_out <= 1;
							BS_out <= 0;
							ena <= 0;
						end
			    end
			else
				begin
					BR_out <= 1;
					BS_out <= 0;
					ena <= 0;
				end
		end
		assign dout = ena ? din : 4'bzzzz;
endmodule
