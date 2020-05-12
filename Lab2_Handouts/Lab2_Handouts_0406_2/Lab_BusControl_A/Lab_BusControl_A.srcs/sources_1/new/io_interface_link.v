`timescale 1ns / 1ps

module io_interface_link(
    input BG_in, // 由其他设备进来的BG信号
    output reg BG_out, // 给其他设备的BG信号（链式）
    input BR_in,    // 外部输入的总线请求
    output reg BR_out,  // 输出：总线请求信号
    output reg BS_out,  // 输出：总线忙信号
    input [3:0]din, // 请求地址：外部输入
    output reg [3:0]dout    // 放在地址总线上的数据
    );

    always @(BR_in)
        begin
            if(BR_in)
				begin
					BR_out = 1;
				end
			else
				begin
					BR_out = 0;
				end
		end
		
	always @(BG_in or BR_in)
		begin
			if(BG_in == 1 && BR_in == 1)
				begin					
					dout = din;
				end
			else
			    begin
                    dout = 4'bzzzz;
			    end
			if(BG_in == 1 && BR_in == 1)
			    begin
			        BS_out = 1;
			    end
			else
			    begin
			        BS_out = 0;
			    end
			if(BG_in == 1 && BR_in == 0)
				begin					
					BG_out = 1;
				end
			else
			    begin
			        BG_out = 0;
			    end			    
		end
	
endmodule
