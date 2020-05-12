`timescale 1ns / 1ps

module all_sim(

    );
reg clk,reset;
wire [9:0] count;
wire [10:0] end_addr = 11'b01_1111_1111;
wire test_success, test_fail;
driver g0(
    clk,
    reset,
    end_addr,
    count,
    test_success,
    test_fail
    );

initial begin
#0 
reset = 1;
    clk = 0;
#105 reset = 0;

end

always @(posedge clk)   begin
    if(g0.current_state == 8'b0000_0001)    $display("访问地址为",g0.test_addr);
    if(g0.current_state == 8'b0000_0010 && g0.next_state == 8'b0000_0010 )    $display("等待Cache响应，应得到数据",g0.data_from_trace);
    if(g0.cache_hit)    $display("Cache访问命中!");
    if(g0.current_state == 8'b0010_0000)    $display("Cache已取回数据", g0.data_from_cache);
    if(g0.next_state == 8'b0000_0001)      $display("该地址测试正确，将测试下一个地址\n ----------- ");
end
always begin
    #10 clk = ~clk;
end 
always @(posedge clk)   begin
    if(test_success)    begin 
        $display("=======================测试全部通过=========================");
        $stop; 
    end
    if(test_fail)   begin   
        $display("==========================测试未通过，具体请看上面调试信息==========================");
        $stop;
    end
end
endmodule
