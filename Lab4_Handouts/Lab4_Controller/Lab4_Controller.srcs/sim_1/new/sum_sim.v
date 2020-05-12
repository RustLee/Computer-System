`timescale 1ns / 1ps

module sum_sim(

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

initial begin
    #0 wait(t0.dp.mm0.imem[37] == 8'hff)
    $display("Gooooooooooooooooooood! Finally Here! 4+3+2+1=",t0.dp.mm0.imem[36]);
    $stop;
end
endmodule
