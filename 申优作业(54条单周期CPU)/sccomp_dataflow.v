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
    output [`InstAddrBus] pc,
    
    output [159:0]oreg,  // reg output
    output reg_admin_ena,
    input [4:0] reg_i, 
    input [31:0] reg_input
    );
    //----------cpu clk----------
    wire cpu_clk;
    
    //----------cpu port----------
    wire [`InstBus] inst;
    wire [`MemAddrBus] addr;
    
    //----------Logical Port----------
    wire [`InstAddrBus] _pc = (pc - `DefaultInstAddr) >> 2;
    wire [`MemAddrBus] _addr = (addr - `DefaultDataAddr) >> 2;  
    
    //----------RAM Port----------
    wire [`MemBus] ram_wdata, ram_rdata;
    wire ram_ena;
        
    
    //----------Divider----------
    Divider#(.mod(10)) get_cpu_CLK(.I_CLK(clk_in), .RST(RST), .O_CLK(cpu_clk));
              
    //----------CPU----------
    cpu sccpu(.clk_in(cpu_clk), .reset(reset),
              .Instruction(inst), .pc(pc),
              .ram_ena(ram_ena), .ram_addr(addr),
              .ram_rdata(ram_rdata), .ram_wdata(ram_wdata),
              .oreg(oreg), .reg_admin_ena(reg_admin_ena),
              .reg_i(reg_i), .reg_input(reg_input));
              
    //----------Rom----------
    IMEM rom (.a(_pc[6:0]),
              .spo(inst));
                   
    //----------Ram----------
    DMEM ram (.clk(cpu_clk), .wena(ram_ena),
              .addr(_addr), 
              .idata(ram_wdata), .odata(ram_rdata));
endmodule
