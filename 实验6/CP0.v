1`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/13 13:14:18
// Design Name: 
// Module Name: CP0
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

module CP0(
    input clk,
    input rst,
    input mtc0,
    input [`InstAddrBus] pc,
    input [`CP0AddrBus] addr,
    input [`RegBus] wdata,       // data from GP register
    input eret,
    input teq_exc,
    input [3:0] cause,
    output [`RegBus] rdata,     // data for GP register
    output [`InstAddrBus] exc_addr
    );
    
    reg [`RegBus] cp0[`CP0_size - 1 : 0];
    integer i;
    
    wire [`RegBus]status = cp0[`status_i]; // status register
    wire exception = (status[0] == `Enable) && 
                      ((status[1] == `Enable && cause == `SYSCALL_ERR) ||
                       (status[2] == `Enable && cause == `BREAK_ERR) ||
                       (status[3] == `Enable && cause == `TEQ_ERR && teq_exc == `Enable));
    assign rdata = cp0[addr];
    assign exc_addr = (eret == `Enable) ? cp0[`epc_i] : `DefaultErrAddr;
    
    always @(posedge clk or posedge rst)
    begin
        if(rst == `RstEnable)
        begin
            for (i = 0; i < `CP0_size; i = i + 1)
                cp0[i] <= `ZeroWord;
        end
        else
        begin
            if(mtc0 == `Enable)
                cp0[addr] <= wdata;
            else if(exception)
            begin
                cp0[`status_i] <= status << 5;
                cp0[`cause_i] <= {24'b0, cause, 2'b0};
                cp0[`epc_i] <= pc;
            end
            else if(eret == `Enable)
            begin
                cp0[`status_i] <= status >> 5;
            end
        end
    end
endmodule
    