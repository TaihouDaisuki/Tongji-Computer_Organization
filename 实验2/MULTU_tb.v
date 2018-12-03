`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/24 15:13:21
// Design Name: 
// Module Name: MULTU_tb
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


module MULTU_tb;
    reg clk = 0;
    reg reset = 0;
    reg [31:0] a,b;
    wire [63:0] c;
    
    MULTU uut(.clk(clk), .reset(reset),
              .a(a), .b(b), .z(c));
    
    always #5 clk = ~clk;
    initial
    begin
        #13 reset <= 'b1; a <= 'd2; b <= 'd3;
        #10 a <= 'd2200000000; b <= 'd2200000000;
        #30 reset <= 'b0;
    end
endmodule
