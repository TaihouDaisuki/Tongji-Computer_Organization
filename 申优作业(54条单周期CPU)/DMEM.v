`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/18 17:53:07
// Design Name: 
// Module Name: DMEM
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

module DMEM(
    input clk,
    input wena,
    input [`MemAddrBus] addr,
    input [`MemBus] idata,
    output [`MemBus] odata
    );

    //reg [7:0] dmem [0:4096];
    //assign odata[31:24] = (wena == `MemLoad) ? dmem[addr + 3] : 8'b0;
    //assign odata[23:16] = (wena == `MemLoad) ? dmem[addr + 2] : 8'b0;
    //assign odata[15:8]  = (wena == `MemLoad) ? dmem[addr + 1] : 8'b0;
    //assign odata[7:0]   = (wena == `MemLoad) ? dmem[addr]     : 8'b0;
    
    reg [31:0] dmem[0:1023];
    assign odata = (wena == `MemLoad) ? dmem[addr] : `ZeroWord;

    always @(negedge clk)
    begin
        if(wena == `MemSave)
        begin
            dmem[addr] <= idata;
        end
    end
endmodule
