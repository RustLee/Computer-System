`timescale 1ns / 1ps

module controller_link(
    input BS,BR,
    output reg BG
    );
	
    always @(BR)
        begin
            if(BR == 1 && BS == 0)
                begin
                    BG = 1;
                end
            else
                begin
                    BG = 0;
                end
        end
endmodule