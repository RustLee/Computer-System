`timescale 1ns / 1ps

module all_sim(

    );
reg clk,reset;
top t0(clk,reset);
initial begin
#0 clk = 0; reset = 1;
#101 reset = 0;
end

always begin
    #10 clk = ~clk;
end

endmodule
