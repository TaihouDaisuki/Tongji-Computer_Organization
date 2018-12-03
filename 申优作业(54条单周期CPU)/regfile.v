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
    output [`RegBus] rdata2,
    
    output [159:0] oreg,     // reg output
    output reg_admin_ena,
    input [4:0] reg_i, 
    input [31:0] reg_input
    );
    //-----Register-----
    reg [`RegBus] array_reg [0:`RegSize - 1];
    integer i;
    
    //-----VGA_output-----
    assign oreg[31:0]       = array_reg[3];
    assign oreg[63:32]      = array_reg[4];
    assign oreg[95:64]      = array_reg[5];
    assign oreg[127:96]     = array_reg[6];
    assign oreg[159:128]    = array_reg[7];
    
    //-----write-----
    always @(negedge clk or posedge rst)
    begin
        if(rst == `RstEnable)
        begin
            for (i = 0; i < `RegSize - 1; i = i + 1)
                array_reg[i] <= `ZeroWord;
            array_reg[`RegSize - 1] <= 32'hffffffff;
        end
        else
        begin
            if((we == `WriteEnable) && (waddr != `RegAddrWidth'h0))
                array_reg[waddr] <= wdata;
            if(reg_i)
                array_reg[reg_i] <= reg_input;
        end
    end
    
    //-----port1_read-----
    assign rdata1 = array_reg[raddr1];
    //-----port2_read-----
    assign rdata2 = array_reg[raddr2];
    
    assign reg_admin_ena = (array_reg[31] == 32'hffffffff); 
endmodule
