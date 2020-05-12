//////////////////////////////////////////////////////////////////////////////////
// Company: Harbin Institute of Technology, Shenzhen 
// Engineer: Bohan Hu
// 
// Create Date: 2020/01/23 23:40:45
// Design Name: Cache Design Lab Grader
// Module Name: Driver
// Project Name: Cache Design Lab
// Target Devices: xc7a100tfgg484-1
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

// ���������use_pll�����ϰ�ʱ��ʱ��Ƶ��Ϊ10MHz
// ���������auto_reset�����ϰ�ʱ��ÿ���1s�ķ�ʽ�Զ�����һ�θ�λ���������ɸ�λ�������������Ĵ���
// ����ʱ���뽫����һ��ע�ͣ����������ٶȽ������
`define simulation

`ifndef simulation
    `define use_pll
    `define auto_reset
`endif

module driver(
    input clk_in,
    input reset_in,
    input [10:0] end_addr,
    output reg [9:0] count,
    output reg test_success,
     output reg test_fail
    );

// ÿ�븴λ1�Σ��Զ�����reset�ź�
// ���еĴ�����������ͬһ��ʱ�ӱ����˳���λ�����ֶ���Reset�źŻᶶ��
// ���״̬���Ĳ�ͬ�����ڲ�ͬ��ʱ�������˳���λ״̬��״̬�����ܻ����Ƿ�״̬�����Ҫ��ȡ����λ���Ա�����ʱ��ͬ��
wire reset;
wire clk;

`ifdef auto_reset
reg [31:0] cnt;
assign reset = cnt > (30000000 - 1000000) ? 1 : 0;
always @(posedge clk)   begin
    if(reset_in)   begin
        cnt <= 0;
    end else begin
        cnt <= cnt + 1;
        if(cnt >= 30000000)    begin
            cnt <= 0;
        end
    end
end
`else
    assign reset = reset_in;
`endif

// �����Ը�λ
`ifdef use_pll
clk_wiz_0 clk_pll
(
    .clk_out1(clk),
    .clk_in1(clk_in)
);
`else
    assign clk = clk_in;
`endif



// trace rom
reg [10:0] test_addr;
reg cache_rreq;
wire cache_hit;
wire [7:0] cache_rdata;
wire [7:0] trace_rdata;

wire rreq_cache2mem;
wire [10:0] raddr_cache2mem;
wire [1:0] burst_len_cache2mem;
wire [31:0] rdata_mem2cache;
wire rvalid_mem2cache;
wire wait_data_mem2cache;
blk_mem trace(.clka(clk),.addra(test_addr),.dina(0),.wea(0),.douta(trace_rdata));
cache ut0(      .clk(clk),
                .reset(reset),
                .raddr_from_cpu(test_addr),
                .rreq_from_cpu(cache_rreq),
                .rdata_to_cpu(cache_rdata),
                .hit_to_cpu(cache_hit),
                .rreq_to_mem(rreq_cache2mem),
                .raddr_to_mem(raddr_cache2mem),
                .rdata_from_mem(rdata_mem2cache),
                .rvalid_from_mem(rvalid_mem2cache),
                .wait_data_from_mem(wait_data_mem2cache) );
mem_wrap mem0(  .clk(clk),
                .reset(reset),
                .rreq(rreq_cache2mem),
                .raddr(raddr_cache2mem),
                .rdata(rdata_mem2cache),
                .rvalid(rvalid_mem2cache),
                .wait_data(wait_data_mem2cache)
                 );
                
enum logic [7:0] { IDLE = 8'b0000_0000,
               READ_TRACE = 8'b0000_0001,
               READ_CACHE = 8'b0000_0010,
               RES_COMPARE = 8'b0010_0000,
               TEST_FAIL = 8'b0000_1000,
               TEST_PASS = 8'b0001_0000 } current_state, next_state;


// ״̬ת���߼�               
always @(posedge clk)   begin
    if(reset)   begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

reg [7:0] data_from_cache;
reg [7:0] data_from_trace;

// �����ǰ״̬�ǵȴ�Cache������Cache���ݿ��ã�����Բɼ�Cache������
always @(posedge clk)   begin
    if(reset)   begin
        data_from_cache <= 0;
    end else begin
        if(current_state == READ_CACHE && cache_hit) begin
            data_from_cache <= cache_rdata;
        end
    end
end

// trace ramһ�����ڿ��Զ�������
always @(posedge clk)   begin
    if(reset)   begin
        data_from_trace <= 0;
    end else begin
        if(current_state == READ_TRACE) begin
            data_from_trace <= trace_rdata;
        end
    end
end

always @(*) begin
    case (current_state)
        IDLE:   begin
            next_state = READ_TRACE;
        end
        READ_TRACE: begin
            next_state = READ_CACHE;
        end
        READ_CACHE: begin
            if(cache_hit)   begin
                next_state = RES_COMPARE; // Cache�ɹ��������ݣ����Խ�����һ���ȶ�
            end else begin   
                next_state = READ_CACHE;
            end
        end
        RES_COMPARE: begin
            if(data_from_cache == data_from_trace)   begin
                if(test_addr == end_addr)   begin   // �������
                    next_state = TEST_PASS;
                end else begin
                    next_state = READ_TRACE;
                end
            end else begin
                next_state = TEST_FAIL;
            end
        end
        TEST_FAIL:  begin
            next_state = TEST_FAIL;
        end
        TEST_PASS:  begin
            next_state = TEST_PASS;
        end
        default:    begin
            next_state = IDLE;
        end
    endcase
end

// ���ܼ�����
always @(posedge clk)   begin
    if(reset)   begin  
        count <= 0;
    end else if(current_state == READ_CACHE)   begin
        count <= count + 1;
    end else begin
        count <= count;
    end
end

// �ڶ���״̬����д�����εĹ����У���Ҫע��״̬��ԭ�е���ʱ���߼�������ź���Ҫ��д������߼�
always @(posedge clk) begin
    if(reset)   begin
            test_addr <= 0;
            cache_rreq <= 0;
            test_success <= 0;
            test_fail <= 0;
    end else begin
        case (next_state)
            IDLE:   begin
                test_addr <= test_addr;
                cache_rreq <= 0;
                test_success <= 0;
                test_fail <= 0;
            end
            READ_TRACE: begin
                test_addr <= test_addr;
                cache_rreq <= 0;
                test_success <= 0;
                test_fail <= 0;
            end
            READ_CACHE: begin
                test_addr <= test_addr;
                cache_rreq <= 1; 
                test_success <= 0;
                test_fail <= 0;
            end
            RES_COMPARE:    begin
                test_addr <= test_addr + 1;
                cache_rreq <= 0;
                test_success <= 0;
                test_fail <= 0;
            end
            TEST_FAIL:  begin
                test_addr <= test_addr;
                cache_rreq <= 0;
                test_success <= 0;
                test_fail <= 1;
            end
            TEST_PASS:  begin
                test_addr <= test_addr;
                cache_rreq <= 0;
                test_success <= 1;
                test_fail <= 0;
            end
            default:    begin
                test_addr <= 0;
                cache_rreq <= 0;
                test_success <= 0;
                test_fail <= 0;
            end
        endcase
    end
end



endmodule
