`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/17 21:18:34
// Design Name: 
// Module Name: CPU_31base
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

module sccomp_dataflow(
    input clk_in,
    input reset,
    output [`InstBus] inst,
    output [`InstAddrBus] pc,
    output [`MemAddrBus] addr
    );
    
    //----------Logical Port----------
    wire [`InstAddrBus] _pc = (pc - `DefaultInstAddr) >> 2;
    wire [`MemAddrBus] _addr = addr - `DefaultDataAddr;
    
    
    //----------RAM Port----------
    wire [`MemBus] ram_wdata, ram_rdata;
    wire ram_ena;
              
    //----------CPU----------
    cpu sccpu(.clk_in(clk_in), .reset(reset),
              .Instruction(inst), .pc(pc),
              .ram_ena(ram_ena), .ram_addr(addr),
              .ram_rdata(ram_rdata), .ram_wdata(ram_wdata));
              
    //----------Rom----------
    IMEM rom (.a(_pc[10:0]),
              .spo(inst));
                   
    //----------Ram----------
    DMEM ram (.clk(clk_in), .wena(ram_ena),
              .addr(_addr), 
              .idata(ram_wdata), .odata(ram_rdata));
endmodule
