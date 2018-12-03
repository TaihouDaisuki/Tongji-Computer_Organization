`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/17 21:23:05
// Design Name: 
// Module Name: ALU
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

module ALU(
    input [`ALUCtrlBus] aluc,
    input [`RegBus] a,
    input [`RegBus] b,
    output [`RegBus] r
    );
    
    wire signed [`RegBus] as = a;
    wire signed [`RegBus] bs = b;
    reg [`AnsBus] ans;
    
    always @(a or b or aluc)
    begin
        case (aluc)
            `ALU_addu: begin ans <= a + b; end
            `ALU_add: begin ans <= as + bs; end
            
            `ALU_subu: begin ans <= a - b; end
            `ALU_sub: begin ans <= as - bs; end
            
            `ALU_and: begin ans <= a & b; end
            `ALU_or: begin ans <= a | b; end
            `ALU_xor: begin ans <= a ^ b; end
            `ALU_nor: begin ans <= ~(a | b); end
            
            `ALU_sltu: begin ans <= a < b ? `True : `False; end
            `ALU_slt: begin ans <= as < bs ? `True : `False; end
            
            `ALU_lui: begin ans <= {b[`HalfRegBus], 16'b0}; end
            
            `ALU_sra:
            begin
                if(a == `ZeroWord)
                    {ans[31:0], ans[32]} <= {bs, 1'b0};
                else
                    {ans[31:0], ans[32]} <= bs >>> (a-1);
            end 
            `ALU_srl: 
            begin 
                if(a == `ZeroWord)
                    {ans[31:0], ans[32]} <= {b, 1'b0};
                else 
                    {ans[31:0], ans[32]} <= b >> (a - 1);
            end
            `ALU_sll: begin ans <= b << a; end
            
            default: ans <= `ZeroWord;
        endcase
    end
    
    assign r = ans[31:0];
endmodule
