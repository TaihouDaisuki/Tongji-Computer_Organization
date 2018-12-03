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
    output [`MemBus] ram_wdata,
    
    output [159:0] oreg,  //reg output
    output reg_admin_ena,
    input [4:0] reg_i, 
    input [31:0] reg_input
    );
    //----------Instuction Port----------
    wire [`InstAddrBus] pc_next;
    wire pc_ena;
    
    //----------Decode Port----------
    wire [`RegAddrBus] rs, rt, rd;
    
    //----------Data Port----------
    wire [`RegBus] rdata1, rdata2, wdata;
    wire [`RegBus] ALU_a, ALU_b, alu_result;
    
    //----------Enable Port----------
    wire we;
    wire [`ALUCtrlBus] aluc;
    
    //----------Address Port----------
    wire [`RegAddrBus] waddr;
    
    //----------CP0 Port----------
    wire [`RegBus] cp0_rdata;
    wire [`InstAddrBus] exc_addr;
    wire mtc0, eret, teq_exc;
    wire [3:0] cause;

    //----------MDU Port----------
    wire [`MDUCtrlBus] mduc;
    wire [`DRegBus] mul_result;
    wire [`RegBus] hi, lo;


    //----------Get Instruction----------
    PCReg PC_reg (.clk(clk_in), .rst(reset), .ena(pc_ena),
                  .pc_in(pc_next),
                  .pc(pc));
    
    //----------Decoder & Controller----------
    CtrlUnit main_control (.inst(Instruction), .pc(pc),
                           .pc_out(pc_next),
                           .rs(rs), .rt(rt),
                           .rdata1(rdata1), .rdata2(rdata2),
                           .aluc(aluc), .ALU_a(ALU_a), .ALU_b(ALU_b),
                           .ram_rdata(ram_rdata), .alu_result(alu_result),
                           .reg_ena(we), .waddr(waddr), .wdata(wdata),
                           .ram_ena(ram_ena), .ram_addr(ram_addr), .ram_wdata(ram_wdata),
                           
                           .cp0_rdata(cp0_rdata), .exc_addr(exc_addr),
                           .mtc0(mtc0), .eret(eret), .teq_exc(teq_exc),
                           .cause(cause),
                           .rd(rd),
                           
                           .mul_result(mul_result[`LowerBus]),
                           .hi(hi), .lo(lo),
                           .mdu_op(mduc));
    
    //----------CP0----------
    CP0 CP0_unit (.clk(clk_in), .rst(reset),
                  .mtc0(mtc0),
                  .pc(pc), 
                  .addr(rd), .wdata(rdata2),
                  .eret(eret), .teq_exc(teq_exc), .cause(cause),
                  .rdata(cp0_rdata), .exc_addr(exc_addr));
    
    //----------Register----------
    regfile cpu_ref (.clk(clk_in), .rst(reset),
                     .we(we), .waddr(waddr), .wdata(wdata),
                     .raddr1(rs), .raddr2(rt),
                     .rdata1(rdata1), .rdata2(rdata2),
                     .oreg(oreg), .reg_admin_ena(reg_admin_ena),
                     .reg_i(reg_i), .reg_input(reg_input));
    
    //----------ALU----------
    ALU alu_unit (.aluc(aluc), .a(ALU_a), .b(ALU_b), 
                  .r(alu_result));
                  
    //----------MDU----------
    MDU MDU_unit(.clk(clk_in), .rst(reset),
                 .mduc(mduc),
                 .a(rdata1), .b(rdata2),
                 .mul_result(mul_result),
                 .hi(hi), .lo(lo),
                 .pc_ena(pc_ena));
endmodule
