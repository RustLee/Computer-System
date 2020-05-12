`timescale 1ns / 1ps

module io_interface_link(
    input BG_in, // �������豸������BG�ź�
    output reg BG_out, // �������豸��BG�źţ���ʽ��
    input BR_in,    // �ⲿ�������������
    output reg BR_out,  // ��������������ź�
    output reg BS_out,  // ���������æ�ź�
    input [3:0]din, // �����ַ���ⲿ����
    output reg [3:0]dout    // ���ڵ�ַ�����ϵ�����
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
