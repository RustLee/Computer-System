`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/02 11:34:43
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top();
    `define SIGNAL 1'd0
    `define CHECK 1'd1
    
    reg state;
    reg next_state;
    
    reg clk;
    wire start = ~state;
    reg [7:0] x_data [99:0];
    reg [7:0] y_data [99:0];
    reg [15:0] z_data [99:0];
    reg [7:0] cnt;
    wire [7:0] x = x_data[cnt];
    wire [7:0] y = y_data[cnt];
    wire [15:0] z_out = z_data[cnt];
    wire [15:0] z;
    wire busy;
    booth u_booth(.x(x), .y(y), .z(z), .clk(clk), .start(start), .busy(busy));
    
    initial begin
        clk <= 0;
        $readmemh("../../../../x.dat", x_data);
        $readmemh("../../../../y.dat", y_data);
        $readmemh("../../../../z.dat", z_data);
        state <= `SIGNAL;
        cnt <= 0;
    end
    
    always @(posedge clk) begin
        state<=next_state;
        if (next_state==`SIGNAL) begin
            if(next_state == `SIGNAL) begin
                cnt <= cnt + 1;
                if(cnt == 8'd99) begin
                    $display("================== ����ͨ�� ==================");
                    $finish;
                end
            end
        end
        if(state== `CHECK && busy == 1'b0) begin
            if (z != z_out) begin
                $display("================== ����δͨ�� ==================");
                $display("�ڵ�  ", cnt+1 , "�����������г���");
                $display("���룺%d, %d", $signed(x), $signed(y));
                $display("�����%d", $signed(z));
                $display("��ȷ�𰸣�%d", $signed(z_out));
                $finish;
            end
        end
    end
    
    always @(*) begin
        case (state)
            `SIGNAL: next_state <= `CHECK;
            `CHECK: next_state <= busy ? `CHECK : `SIGNAL;
            default: next_state <= `SIGNAL;
        endcase
    end
    
    always #5 clk = !clk;
endmodule
