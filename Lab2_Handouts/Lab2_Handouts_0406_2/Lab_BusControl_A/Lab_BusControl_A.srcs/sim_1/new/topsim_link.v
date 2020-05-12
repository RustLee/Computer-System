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
// 测试代码

fp_r = $fopen("link_test.txt", "r");
 
while(!$feof(fp_r)) begin
    req_vec = 0;
    #100
    $fscanf(fp_r,"%b", req_vec );
    $display("========进行仲裁测试（链式查询方法）========");

    num_pending_device = 0;
    for (i = 0; i<6 ;i=i+1)  begin // calculate the pending devices 
        if(req_vec[i] == 1)    num_pending_device = num_pending_device + 1;
    end
    $strobe("共有%d个设备提起请求", num_pending_device);
    for (i = 0; i<num_pending_device; i=i+1)    begin
        $strobe("请求状态：设备3(", BR_in_3, ");设备2(", BR_in_2, ");设备1(", BR_in_1, ");设备0(", BR_in_0,")");
        $fscanf(fp_r, "%d", expected_dout);
        $strobe("本次设备",expected_dout,"将得到总线控制权");
        wait(dbus_out == expected_dout)$strobe($time,"时刻，设备",expected_dout,"已得到响应");
        #20 req_vec[expected_dout] = 0; 
        $display($time,"时刻，设备",expected_dout,"完成总线访问，请求已撤出");
    end
end
$display("测试全部通过");
$fclose(fp_r);
$stop;
end


endmodule
