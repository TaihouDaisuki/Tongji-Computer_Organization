`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/28 16:00:56
// Design Name: 
// Module Name: DIVU
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


module DIVU(
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
    reg r_sign;
    assign q = tmp_q;
    assign r = r_sign == 1 ? tmp_r + tmp_d : tmp_r;
    
    wire [32:0]tmp_sub;
    assign tmp_sub = r_sign ? {{tmp_r, q[31]} + {1'b0, tmp_d}} : {{tmp_r, q[31]} - {1'b0, tmp_d }};
    
    reg pre_start;
    always @(posedge clock or posedge reset or posedge start or negedge start)
    begin
        pre_start <= start;
        if(reset == 1)
        begin
            busy <= 0;
            count <= 0;
        end
        else if({pre_start, start} == 2'b10)
        begin
            tmp_d <= divisor;
            tmp_q <= dividend;
            tmp_r <= 32'b0;
            r_sign <= 0;
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
