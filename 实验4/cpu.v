`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/25 21:32:02
// Design Name: 
// Module Name: cpu
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

module cpu(
    input clk_in,
    input reset,
    input [`InstBus] Instruction,
    output [`InstAddrBus] pc,
    output ram_ena,
    output [`MemAddrBus] ram_addr,
    input [`MemBus] ram_rdata,
    output [`MemBus] ram_wdata
    );
    //----------Instuction Port----------
    wire [`InstAddrBus] pc_next;
    
    //----------Decode Port----------
    wire [`RegAddrBus] rs, rt;
    
    //----------Data Port----------
    wire [`RegBus] rdata1, rdata2, wdata;
    wire [`RegBus] ALU_a, ALU_b, alu_result;
    
    //----------Enable Port----------
    wire we;
    wire [`ALUCtrlBus] aluc;
    
    //----------Address Port----------
    wire [`RegAddrBus] waddr;

    //----------Flag Port----------
    wire zero, carry, negative, overflow;
    
    //----------Get Instruction----------
    PCReg PC_reg (.clk(clk_in), .rst(reset), .ena(`Enable),
                  .pc_in(pc_next),
                  .pc(pc));
    
    
    //----------Decoder & Controller----------
    CtrlUnit main_control (.inst(Instruction), .pc(pc),
                         .pc_out(pc_next),
                         .rs(rs), .rt(rt),
                         .rdata1(rdata1), .rdata2(rdata2),
                         .aluc(aluc), .ALU_a(ALU_a), .ALU_b(ALU_b),
                         .ram_rdata(ram_rdata), .alu_result(alu_result),
                         .we(we), .waddr(waddr), .wdata(wdata),
                         .ram_ena(ram_ena), .ram_addr(ram_addr), .ram_wdata(ram_wdata));
    
    //----------Register----------
    regfile cpu_ref (.clk(clk_in), .rst(reset),
                     .we(we), .waddr(waddr), .wdata(wdata),
                     .raddr1(rs), .raddr2(rt),
                     .rdata1(rdata1), .rdata2(rdata2));
    
    //----------ALU----------
    ALU alu_part (.aluc(aluc), .a(ALU_a), .b(ALU_b), 
                  .r(alu_result),
                  .zero(zero), .carry(carry), .negative(negative), .overflow(overflow));
endmodule
