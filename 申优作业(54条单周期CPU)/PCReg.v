`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/17 21:57:59
// Design Name: 
// Module Name: PCReg
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

`include "defines.vh"

module PCReg(
    input clk,
    input rst,
    input ena,
    input [`InstAddrBus] pc_in,
    output reg [`InstAddrBus] pc
    );
    
    always @(posedge clk or posedge rst)
    begin
        if(rst == `RstEnable)
            pc <= `DefaultInstAddr;
        else if(ena == `Enable)
            pc <= pc_in;
    end
endmodule
