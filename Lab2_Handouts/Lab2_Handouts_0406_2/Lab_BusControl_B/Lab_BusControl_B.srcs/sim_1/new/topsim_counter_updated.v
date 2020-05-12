`timescale 1ns / 1ps

module topsim_counter(

    );
reg [3:0]din_0, din_1, din_2, din_3;
wire BR_in_0, BR_in_1, BR_in_2, BR_in_3;
reg clk,rst;
wire [3:0] dbus_out;
reg mode;
reg [1:0]cnt_rstval;
top_counter ut0(
    .clk(clk),
    .rst(rst),
    .din_0(din_0), 
    .din_1(din_1), 
    .din_2(din_2), 
    .din_3(din_3), 
    .BR_in_0(BR_in_0), 
    .BR_in_1(BR_in_1), 
    .BR_in_2(BR_in_2), 
    .BR_in_3(BR_in_3),
    .dbus_out(dbus_out),
    .mode(mode),
    .cnt_rstval(cnt_rstval)
    );  
integer fp_r;
reg [1:0]expected_dout;
reg [2:0]num_pending_device;
integer i;
reg [3:0]req_vec;
assign {BR_in_3, BR_in_2, BR_in_1, BR_in_0} = req_vec;
integer ff;
reg success_flag;
reg[7:0] test_cnt;
reg[7:0] pass_cnt;
integer r;

always begin
#10 clk = ~clk;
end
initial begin
#0    clk = 0; rst = 1; din_0 = 0; din_1 = 1; din_2 = 2; din_3 = 3;req_vec = 0;success_flag=0;pass_cnt =0;test_cnt=0;
#25   rst = 0;
// ���Դ���

fp_r = $fopen("counter_test.txt", "r");
while(!$feof(fp_r)) begin
    req_vec = 0;
    #100
    ff=$fscanf(fp_r,"%b", mode);       // read the mode
    ff=$fscanf(fp_r,"%d", cnt_rstval);   // read the reset value
    ff=$fscanf(fp_r,"%b", req_vec );
    $display("========�����ٲò��ԣ�������ʼ��%d��========",cnt_rstval);
    if(mode == 1)   begin
        $display("======����ֹ�㿪ʼ��ѭ��ģʽ======");
    end else begin
        $display("======�Ӽ�����ʼ�㿪ʼ��ѭ��ģʽ======");
    end
    // ����֮��ʼ��һ�ֲ���
    rst = 1; 
    success_flag = 1;
    #55 
    rst = 0;
    num_pending_device = 0;
    for (i = 0; i<4 ;i=i+1)  begin // calculate the pending devices 
        if(req_vec[i] == 1)    num_pending_device = num_pending_device + 1;
    end
    $display("����%d���豸��������", num_pending_device);
    for (i = 0; i<num_pending_device; i=i+1)    begin
        $strobe("����״̬���豸3(", BR_in_3, ");�豸2(", BR_in_2, ");�豸1(", BR_in_1, ");�豸0(", BR_in_0,")");
        ff = $fscanf(fp_r, "%d", expected_dout);
        $strobe("�����豸",expected_dout,"���õ����߿���Ȩ");
        # 2333      // �ϳ�����ʱ֮��(Զ���ڼ������ļ������ڣ���Ӧ�ñ�֤���������������
        if(dbus_out == expected_dout)   begin
            $strobe($time,"ʱ�̣��豸",expected_dout,"�ѵõ���Ӧ");
            #23 req_vec[expected_dout] = 0; 
            $display($time,"ʱ�̣��豸",expected_dout,"������߷��ʣ������ѳ���");
        end else begin
            $display("�ѳ����ȴ�ʱ�����ޣ�������δͨ��");
            success_flag = 0;
        end
    end
    if(success_flag == 1)   pass_cnt = pass_cnt + 1;
    test_cnt = test_cnt + 1;
end
$display("������%d�����ԣ�ͨ����%d������", test_cnt, pass_cnt);
$fclose(fp_r);
$stop;
end


endmodule
