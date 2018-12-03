`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/30 12:34:15
// Design Name: 
// Module Name: DIVU_tb
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


module DIVU_tb;
    reg clk = 1, rst, st;
    reg [31:0] dividend, divisor;
    wire bsy;
    wire [31:0] q, r;
    
    DIVU uut(.clock(clk), .reset(rst), .start(st),
             .dividend(dividend), .divisor(divisor),
             .busy(bsy),
             .q(q), .r(r));
    
    always #5 clk = ~clk;
    initial
    begin
        rst <= 0; st <= 1;
        #3 
            rst <= 0;
            dividend <= 32'd7;
            divisor <= 32'd2;
        #6 st <= 0;
        #400 st <= 1;
        #5 
            st <= 0;
            dividend <= 32'hffffffff;
            divisor <= 32'h55555555;
    end
endmodule
