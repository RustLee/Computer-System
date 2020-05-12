`timescale 1ns / 1ps

module io_interface_counter(
    input clk,
    input rst,
    input   BR_in,              // �ⲿ�������������
    output reg BR_out,         // ��������������ź�
    output reg BS_out,             // ���������æ�ź�
    input   [3:0]din,           // �����ַ���ⲿ����
    output wire [3:0]dout,          // ���ڵ�ַ�����ϵ�����
    input   [1:0] device_id,    // �豸��ַ�����ã�
    input   [1:0] cnt_in        // ����������
    );

// ��ʹ������ʱ�������������̬��z)
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
