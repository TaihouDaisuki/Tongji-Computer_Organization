`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/17 22:19:29
// Design Name: 
// Module Name: regfile
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

module regfile(
    input clk,
    input rst,
    //----write_port-----
    input we,
    input [`RegAddrBus] waddr,
    input [`RegBus] wdata,
    //-----read_port-----
    input [`RegAddrBus] raddr1,
    output [`RegBus] rdata1,
    input [`RegAddrBus] raddr2,
    output [`RegBus] rdata2
    );
    
    //-----Register-----
    reg [`RegBus] array_reg [0:`RegSize - 1];
    reg [5:0] i;
    
    //-----write-----
    always @(negedge clk or posedge rst)
    begin
        if(rst == `RstEnable)
        begin
            for (i = 0; i < `RegSize; i = i + 1)
                array_reg[i] <= `ZeroWord;
        end
        else if(rst == `RstDisable)
        begin
            if((we == `WriteEnable) && (waddr != `RegAddrWidth'h0))
                array_reg[waddr] <= wdata; 
        end
    end
    
    //-----port1_read-----
    assign rdata1 = array_reg[raddr1];
    //-----port2_read-----
    assign rdata2 = array_reg[raddr2];
endmodule
