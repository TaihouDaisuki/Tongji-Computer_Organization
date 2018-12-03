`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/03 19:59:29
// Design Name: 
// Module Name: MDU
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

module MDU(
    input clk,
    input rst,
    input [`MDUCtrlBus] mduc,
    input [`RegBus] a,
    input [`RegBus] b,
    output [`DRegBus] mul_result,
    output reg [`RegBus] hi,
    output reg [`RegBus] lo,
    output reg pc_ena
    );
    
    //----------mult port----------
    wire [`DRegBus] mult_res, multu_res; 
    assign mul_result = mult_res;
    
    //----------div port----------
    wire[`DRegBus] div_res, divu_res;
    wire div_start, divu_start;
    wire div_busy, divu_busy;
    wire div_over = ~div_busy;
    wire divu_over = ~divu_busy;
    
    assign div_start = (mduc == `MDU_div && div_busy == `Disable) ? `Enable : `Disable;
    assign divu_start = (mduc == `MDU_divu && divu_busy == `Disable) ? `Enable : `Disable; 
    
    always @(*)
    begin
        case(mduc)
            `MDU_div: pc_ena = (div_over == `Enable || mduc != `MDU_div) ? `Enable : `Disable;
            `MDU_divu: pc_ena = (divu_over == `Enable || mduc != `MDU_divu) ? `Enable : `Disable;
            default: pc_ena = `Enable;
        endcase
    end
    
    always @(posedge clk or posedge rst)
    begin
        if(rst == `Enable)
        begin
            hi <= `ZeroWord;
            lo <= `ZeroWord;
        end
        else
        begin
            case(mduc) 
                `MDU_multu:     {hi, lo} <= multu_res;
                `MDU_div:       {lo, hi} <= div_res;
                `MDU_divu:      {lo, hi} <= divu_res;
                `MDU_mthi:      hi <= a;
                `MDU_mtlo:      lo <= a;
                default:        ;
            endcase
        end
    end
    
    MULT mult_unit (.reset(~rst),
                    .a(a), .b(b), 
                    .z(mult_res));
    MULTU multu_unit (.reset(~rst),
                      .a(a), .b(b), 
                      .z(multu_res));
                      
    DIV div_unit (.clock(clk), .reset(mduc != `MDU_div),
                  .start(div_start),
                  .dividend(a), .divisor(b),
                  .q(div_res[`HigherBus]), .r(div_res[`LowerBus]),
                  .busy(div_busy));
    DIVU divu_unit (.clock(clk), .reset(mduc != `MDU_divu),
                    .start(divu_start),
                    .dividend(a), .divisor(b),
                    .q(divu_res[`HigherBus]), .r(divu_res[`LowerBus]),
                    .busy(divu_busy));
endmodule
