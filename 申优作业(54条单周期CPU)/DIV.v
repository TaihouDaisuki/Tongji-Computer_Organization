`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/28 19:21:48
// Design Name: 
// Module Name: DIV
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

module DIV(
    input [31:0]dividend,
    input [31:0]divisor,
    input start,
    input clock,
    input reset,
    output [31:0]q,
    output [31:0]r,
    output reg busy
    );
    
    reg [4:0]count;
    
    reg [31:0]tmp_q, tmp_r, tmp_d;
    reg r_sign, q_sign, d_sign;
    assign q = q_sign == 1 ? -tmp_q : tmp_q;
    assign r = r_sign == 1 ? (d_sign == 1 ? -(tmp_r + tmp_d) : tmp_r + tmp_d) 
                           : (d_sign == 1 ? -tmp_r : tmp_r);
    
    wire [32:0]tmp_sub;
    assign tmp_sub = r_sign ? {{tmp_r, tmp_q[31]} + {1'b0, tmp_d}} : {{tmp_r, tmp_q[31]} - {1'b0, tmp_d }};
    
    reg pre_start;
    always @(posedge clock or posedge reset)
    begin
        pre_start <= start;
        if(reset == 1)
        begin
            busy <= 0;
            count <= 0;
        end
        else if({pre_start, start} == 2'b10)
        begin
            tmp_d <= divisor[31] == 1 ? -divisor : divisor;
            tmp_q <= dividend[31] == 1 ? -dividend : dividend;
            tmp_r <= 32'b0;
            r_sign <= 0;
            q_sign <= divisor[31] ^ dividend[31];
            d_sign <= dividend[31];
            busy <= 1;
            count <= 0;
        end
        else if({pre_start, start} == 2'b00 && busy == 1)
        begin
            tmp_r <= tmp_sub[31:0];
            r_sign <= tmp_sub[32];
            tmp_q <= {tmp_q[30:0], ~tmp_sub[32]};
            count <= count + 5'b1;
            busy <= count == 5'd31 ? 0 : 1;
        end
    end
endmodule
