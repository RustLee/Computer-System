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
// 测试代码

fp_r = $fopen("counter_test.txt", "r");
while(!$feof(fp_r)) begin
    req_vec = 0;
    #100
    ff=$fscanf(fp_r,"%b", mode);       // read the mode
    ff=$fscanf(fp_r,"%d", cnt_rstval);   // read the reset value
    ff=$fscanf(fp_r,"%b", req_vec );
    $display("========进行仲裁测试（计数起始点%d）========",cnt_rstval);
    if(mode == 1)   begin
        $display("======从终止点开始的循环模式======");
    end else begin
        $display("======从计数起始点开始的循环模式======");
    end
    // 重置之后开始下一轮测试
    rst = 1; 
    success_flag = 1;
    #55 
    rst = 0;
    num_pending_device = 0;
    for (i = 0; i<4 ;i=i+1)  begin // calculate the pending devices 
        if(req_vec[i] == 1)    num_pending_device = num_pending_device + 1;
    end
    $display("共有%d个设备提起请求", num_pending_device);
    for (i = 0; i<num_pending_device; i=i+1)    begin
        $strobe("请求状态：设备3(", BR_in_3, ");设备2(", BR_in_2, ");设备1(", BR_in_1, ");设备0(", BR_in_0,")");
        ff = $fscanf(fp_r, "%d", expected_dout);
        $strobe("本次设备",expected_dout,"将得到总线控制权");
        # 2333      // 较长的延时之后(远长于计数器的计数周期），应该保证数据总线输出正常
        if(dbus_out == expected_dout)   begin
            $strobe($time,"时刻，设备",expected_dout,"已得到响应");
            #23 req_vec[expected_dout] = 0; 
            $display($time,"时刻，设备",expected_dout,"完成总线访问，请求已撤出");
        end else begin
            $display("已超出等待时间上限，本样例未通过");
            success_flag = 0;
        end
    end
    if(success_flag == 1)   pass_cnt = pass_cnt + 1;
    test_cnt = test_cnt + 1;
end
$display("运行了%d个测试，通过了%d个测试", test_cnt, pass_cnt);
$fclose(fp_r);
$stop;
end


endmodule
