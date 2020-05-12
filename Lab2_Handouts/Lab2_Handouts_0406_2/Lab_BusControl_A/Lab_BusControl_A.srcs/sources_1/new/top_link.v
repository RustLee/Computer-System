`timescale 1ns / 1ps


module top_link(
    input [3:0]din_0, din_1, din_2, din_3,      // IO数据输入
    input BR_in_0, BR_in_1, BR_in_2, BR_in_3,   // IO请求
    output [3:0] dbus_out                       // 数据总线输出
    );
    
    wire BG_out_0, BG_out_1, BG_out_2, BG_out_3;
    wire BR_out_0, BR_out_1, BR_out_2, BR_out_3 ,BR_out;
	wire BS_out_0, BS_out_1, BS_out_2, BS_out_3 ,BS_out;
	           
	assign BR_out = (BR_out_0 | BR_out_1 | BR_out_2 | BR_out_3);
	assign BS_out = (BS_out_0 | BS_out_1 | BS_out_2 | BS_out_3);
	
    controller_link c0(
		.BS(BS_out),
		.BR(BR_out),
        .BG(BG_out_0)
    );
    io_interface_link s0(
        .BG_in(BG_out_0),
        .BG_out(BG_out_1),
        .BR_in(BR_in_0),
		.BR_out(BR_out_0),
		.BS_out(BS_out_0),
        .din(din_0),
		.dout(dbus_out)
    );
    io_interface_link s1(
        .BG_in(BG_out_1),
        .BG_out(BG_out_2),
        .BR_in(BR_in_1),
		.BR_out(BR_out_1),
		.BS_out(BS_out_1),
        .din(din_1),
		.dout(dbus_out)
    );
    io_interface_link s2(
        .BG_in(BG_out_2),
        .BG_out(BG_out_3),
        .BR_in(BR_in_2),
		.BR_out(BR_out_2),
		.BS_out(BS_out_2),
        .din(din_2),
		.dout(dbus_out)
    );
    io_interface_link s3(
        .BG_in(BG_out_3),
        .BR_in(BR_in_3),
		.BR_out(BR_out_3),
		.BS_out(BS_out_3),
        .din(din_3),
		.dout(dbus_out)
    );	
// 实例化四个IO接口，实例化控制器，并完成接线工作

endmodule
