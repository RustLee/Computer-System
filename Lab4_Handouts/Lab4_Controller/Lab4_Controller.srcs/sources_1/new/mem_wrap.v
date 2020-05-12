`timescale 1ns / 1ps

module mem_wrap(
    input clk,
    input [7:0]addr,
    input rreq,
    input wreq,
    output [7:0] dout,
    input [7:0] din
    );
reg memread;
reg memwrite;
reg [7:0] imem[255:0];

always @(posedge clk)   begin
    memread <= rreq;
    memwrite <= wreq;
end

assign dout = memread ? imem[addr] : 8'bzzzzzzzz;

initial begin
    // 修改此处以更换测试样例
    $readmemb("test_set/9sum.txt", imem);
end

always @(posedge clk)   begin
    if(memwrite)    begin
        imem[addr] <= din;
    end
end

endmodule