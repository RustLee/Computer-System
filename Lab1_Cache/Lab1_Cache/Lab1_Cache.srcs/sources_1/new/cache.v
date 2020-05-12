`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// Cache参数 ///////////////////////////////////////
// 映射方式：直接相联
// 数据字长：1 Byte
// Cache块大小：4 Bytes
// 主存地址宽度： 11 bit
// Cache容量：64 Lines * 4 Bytes/Line = 256 Bytes
// 替换策略：无（直接相联，无替换策略）
//////////////////////////////////////////////////////////////////////////////////


module cache(
    // 全局信号
    input clk,
    input reset,
    // 从CPU来的访问信号
    input [10:0] raddr_from_cpu,     // CPU來的读地址
    input rreq_from_cpu,            // CPU来的读请求
    // 从下层内存模块来的信号
    input [31:0] rdata_from_mem,     // 内存读取的数据
    input rvalid_from_mem,          // 内存读取数据可用标志
    input wait_data_from_mem,
    // 输出给CPU的信号
    output [7:0] rdata_to_cpu,      // 输出给CPU的数据
    output hit_to_cpu,              // 输出给CPU的命中标志
    // 输出给下层内存模块的信号
    output rreq_to_mem,         // 输出给下层内存模块的读请求
    output [10:0] raddr_to_mem  // 输出给下层模块的首地址
    );


// Your Code Here
parameter READY = 2'b00;
parameter TAG_CHECK = 2'b01;
parameter REFILL = 2'b10;
reg[1:0] cur_state = READY,next_state = READY;
reg[1:0] in_addr; //字块内地址
reg[5:0] cache_addr; //cache字块地址
reg[2:0] tag;	//主存字块地址
reg[0:0] wea;
reg[35:0] din;
reg[0:0] vaild;
reg[2:0] cache_tag;
reg[7:0] dout;
reg req;
reg refill_done;

wire[35:0] block_out;
wire[7:0]data_out;

    blk_mem_gen_0 your_instance_name (
      .clka(clk),    // input wire clka
      .wea(wea),      // input wire [0 : 0] wea
      .addra(cache_addr),  // input wire [5 : 0] addra
      .dina(din),    // input wire [35 : 0] dina
      .douta(block_out)  // output wire [35 : 0] douta
    );
	
	always @(*)
		begin
			in_addr <= raddr_from_cpu[1:0];
			cache_addr <= raddr_from_cpu[7:2];
			tag <= raddr_from_cpu[10:8];
			vaild <= block_out[35];
			cache_tag <= block_out[34:32];
		end 
	
	always @(posedge clk)
		begin
			if(reset)
				begin
					cur_state <= READY;
				end
			else 
				begin
					cur_state <= next_state;
				end
		end

	always @(*)
		begin
			case(cur_state)
				READY:begin
					if(rreq_from_cpu)
						begin
							next_state <= TAG_CHECK;
						end
					else
						begin
							next_state <= READY;
						end
				end
				
				TAG_CHECK:begin
					if(hit_to_cpu)
						begin
							next_state <= READY;
						end
					else
						begin
							next_state <= REFILL;
						end
				end
				
				REFILL:begin
					if(refill_done)
						begin
							next_state <= TAG_CHECK;
						end
					else
						begin
							next_state <= REFILL;
						end
				end
				
				default:begin end 
			endcase
		end
		
	assign hit_to_cpu = (cur_state == TAG_CHECK)
						&&vaild&&(tag == cache_tag);
	assign rdata_to_cpu = data_out;
	assign rreq_to_mem = req;
	assign raddr_to_mem = raddr_from_cpu;
	
	always @(posedge clk)
		begin
			case(cur_state)
				READY:begin
					req <= 0;
					refill_done <= 0;
					wea <= 0;
				end
				
				TAG_CHECK:begin
				end
				
				REFILL:begin
					req <= 1;
					if(wait_data_from_mem == 0)
						begin
							din[31:0] <= rdata_from_mem;
							din[34:32] <= tag;
							din[35] <= rvalid_from_mem;
							wea <= 1;
							refill_done <= 1;
						end
				end
				
				default:begin end
			endcase
		end
					
	always @(*)
		begin
			case(in_addr)
				0:begin 
					dout <= block_out[7:0];
				end
				1:begin 
					dout <= block_out[15:8];
				end
				2:begin 
					dout <= block_out[23:16];
				end
				3:begin 
					dout <= block_out[31:24];
				end
				default:begin end
			endcase
		end
	assign data_out = dout;	
endmodule
