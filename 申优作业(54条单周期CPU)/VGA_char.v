`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/15 13:14:39
// Design Name: 
// Module Name: VGA_char
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


module VGA_char(
    input [2:0] dH,
    input [3:0] dV,
    input [4:0] alph,
    output reg Point
    );
    reg [127:0] Char_Matrix[16:0];
    initial
    begin
        Char_Matrix[0]  = {8'h00,8'h00,8'h3E,8'h63,8'h63,8'h63,8'h6B,8'h6B,8'h63,8'h63,8'h63,8'h3E,8'h00,8'h00,8'h00,8'h00}; // 0 8'h30
        Char_Matrix[1]  = {8'h00,8'h00,8'h0C,8'h1C,8'h3C,8'h0C,8'h0C,8'h0C,8'h0C,8'h0C,8'h0C,8'h3F,8'h00,8'h00,8'h00,8'h00}; // 1
        Char_Matrix[2]  = {8'h00,8'h00,8'h3E,8'h63,8'h03,8'h06,8'h0C,8'h18,8'h30,8'h61,8'h63,8'h7F,8'h00,8'h00,8'h00,8'h00}; // 2
        Char_Matrix[3]  = {8'h00,8'h00,8'h3E,8'h63,8'h03,8'h03,8'h1E,8'h03,8'h03,8'h03,8'h63,8'h3E,8'h00,8'h00,8'h00,8'h00}; // 3
        Char_Matrix[4]  = {8'h00,8'h00,8'h06,8'h0E,8'h1E,8'h36,8'h66,8'h66,8'h7F,8'h06,8'h06,8'h0F,8'h00,8'h00,8'h00,8'h00}; // 4
        Char_Matrix[5]  = {8'h00,8'h00,8'h7F,8'h60,8'h60,8'h60,8'h7E,8'h03,8'h03,8'h63,8'h73,8'h3E,8'h00,8'h00,8'h00,8'h00}; // 5
        Char_Matrix[6]  = {8'h00,8'h00,8'h1C,8'h30,8'h60,8'h60,8'h7E,8'h63,8'h63,8'h63,8'h63,8'h3E,8'h00,8'h00,8'h00,8'h00}; // 6
        Char_Matrix[7]  = {8'h00,8'h00,8'h7F,8'h63,8'h03,8'h06,8'h06,8'h0C,8'h0C,8'h18,8'h18,8'h18,8'h00,8'h00,8'h00,8'h00}; // 7
        Char_Matrix[8]  = {8'h00,8'h00,8'h3E,8'h63,8'h63,8'h63,8'h3E,8'h63,8'h63,8'h63,8'h63,8'h3E,8'h00,8'h00,8'h00,8'h00}; // 8
        Char_Matrix[9]  = {8'h00,8'h00,8'h3E,8'h63,8'h63,8'h63,8'h63,8'h3F,8'h03,8'h03,8'h06,8'h3C,8'h00,8'h00,8'h00,8'h00}; // 9
        Char_Matrix[10] = {8'h00,8'h00,8'h08,8'h1C,8'h36,8'h63,8'h63,8'h63,8'h7F,8'h63,8'h63,8'h63,8'h00,8'h00,8'h00,8'h00}; // A
        Char_Matrix[11] = {8'h00,8'h00,8'h7E,8'h33,8'h33,8'h33,8'h3E,8'h33,8'h33,8'h33,8'h33,8'h7E,8'h00,8'h00,8'h00,8'h00}; // B
        Char_Matrix[12] = {8'h00,8'h00,8'h1E,8'h33,8'h61,8'h60,8'h60,8'h60,8'h60,8'h61,8'h33,8'h1E,8'h00,8'h00,8'h00,8'h00}; // C
        Char_Matrix[13] = {8'h00,8'h00,8'h7C,8'h36,8'h33,8'h33,8'h33,8'h33,8'h33,8'h33,8'h36,8'h7C,8'h00,8'h00,8'h00,8'h00}; // D
        Char_Matrix[14] = {8'h00,8'h00,8'h7F,8'h33,8'h31,8'h34,8'h3C,8'h34,8'h30,8'h31,8'h33,8'h7F,8'h00,8'h00,8'h00,8'h00}; // E
        Char_Matrix[15] = {8'h00,8'h00,8'h7F,8'h33,8'h31,8'h34,8'h3C,8'h34,8'h30,8'h30,8'h30,8'h78,8'h00,8'h00,8'h00,8'h00}; // F
        Char_Matrix[16] = {8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00}; // space
    end
    
    wire [127:0] Matrix;
    assign Matrix = Char_Matrix[alph];
    always @(*)
    begin
        Point <= Matrix[127 - (8*dV + dH)]; //Char_Matrix里是从高位往低位存的
    end
endmodule
