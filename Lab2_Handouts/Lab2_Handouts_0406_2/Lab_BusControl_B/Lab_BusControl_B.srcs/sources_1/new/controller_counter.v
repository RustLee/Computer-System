`timescale 1ns / 1ps

module controller_counter(
    input clk,              // ʱ��
    input rst,              // ��λ
    input BR,               // ����������
    input BS,               // ���߷�æ�ź�
    input mode,             // ����ģʽ
    // 1������ֹ�㿪ʼ��ѭ��ģʽ��0���ӹ̶�ֵ��ʼ�Ĺ̶����ȼ�ģʽ
    input [1:0] cnt_rstval, // �������ĸ�λֵ
    output reg [1:0] cnt    // �����������ֵ
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
