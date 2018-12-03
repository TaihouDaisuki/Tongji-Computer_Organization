`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/24 15:38:04
// Design Name: 
// Module Name: MULT_tb
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


module MULT_tb;
    reg clk = 0;
    reg reset = 0;
    reg signed [31:0] a,b;
    wire signed [63:0] c;
    
    MULT uut(.clk(clk), .reset(reset),
              .a(a), .b(b), .z(c));
    
    always #5 clk = ~clk;
    initial
    begin
        #13 reset <= 'b1; a <= 'd3; b <= 'd2;
        #20 a <= 'd5; b <= 'h80000000; 
        #20 a <= -5;
        #20 a <= 'd0;
        #30 reset <= 'b0;
    end
endmodule
