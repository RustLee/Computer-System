`timescale 1ns / 1ps

module topsim_link(

    );
reg [3:0]din_0, din_1, din_2, din_3;
wire BR_in_0, BR_in_1, BR_in_2, BR_in_3;
wire [3:0] dbus_out;

top_link ut0(
    .din_0(din_0), 
    .din_1(din_1), 
    .din_2(din_2), 
    .din_3(din_3), 
    .BR_in_0(BR_in_0), 
    .BR_in_1(BR_in_1), 
    .BR_in_2(BR_in_2), 
    .BR_in_3(BR_in_3),
    .dbus_out(dbus_out)
    );  
integer fp_r;
reg [1:0]expected_dout;
reg [2:0]num_pending_device;
integer i;
reg [3:0]req_vec;
assign {BR_in_3, BR_in_2, BR_in_1, BR_in_0} = req_vec;

initial begin
#0    din_0 = 0; din_1 = 1; din_2 = 2; din_3 = 3;req_vec = 0;
// ���Դ���

fp_r = $fopen("link_test.txt", "r");
 
while(!$feof(fp_r)) begin
    req_vec = 0;
    #100
    $fscanf(fp_r,"%b", req_vec );
    $display("========�����ٲò��ԣ���ʽ��ѯ������========");

    num_pending_device = 0;
    for (i = 0; i<6 ;i=i+1)  begin // calculate the pending devices 
        if(req_vec[i] == 1)    num_pending_device = num_pending_device + 1;
    end
    $strobe("����%d���豸��������", num_pending_device);
    for (i = 0; i<num_pending_device; i=i+1)    begin
        $strobe("����״̬���豸3(", BR_in_3, ");�豸2(", BR_in_2, ");�豸1(", BR_in_1, ");�豸0(", BR_in_0,")");
        $fscanf(fp_r, "%d", expected_dout);
        $strobe("�����豸",expected_dout,"���õ����߿���Ȩ");
        wait(dbus_out == expected_dout)$strobe($time,"ʱ�̣��豸",expected_dout,"�ѵõ���Ӧ");
        #20 req_vec[expected_dout] = 0; 
        $display($time,"ʱ�̣��豸",expected_dout,"������߷��ʣ������ѳ���");
    end
end
$display("����ȫ��ͨ��");
$fclose(fp_r);
$stop;
end


endmodule
