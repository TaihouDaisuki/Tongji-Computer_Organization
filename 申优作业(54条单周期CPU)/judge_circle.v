`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/15 13:17:09
// Design Name: 
// Module Name: judge_circle
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


module judge_circle
    #(
        parameter signed X1 = 120,
        parameter signed X2 = 260,
        parameter signed X3 = 400,
        parameter signed X4 = 540,
        parameter signed X5 = 680,
        parameter signed Y = 80,
        parameter signed R2 = 3600
    )
    (
        input signed [10:0] Hcnt,
        input signed [10:0] Vcnt,
        output [4:0] fC
    );
    assign fC[0] = ((Hcnt - X1) * (Hcnt - X1) + (Vcnt - Y) * (Vcnt - Y)) <= R2;
    assign fC[1] = ((Hcnt - X2) * (Hcnt - X2) + (Vcnt - Y) * (Vcnt - Y)) <= R2;
    assign fC[2] = ((Hcnt - X3) * (Hcnt - X3) + (Vcnt - Y) * (Vcnt - Y)) <= R2;
    assign fC[3] = ((Hcnt - X4) * (Hcnt - X4) + (Vcnt - Y) * (Vcnt - Y)) <= R2;
    assign fC[4] = ((Hcnt - X5) * (Hcnt - X5) + (Vcnt - Y) * (Vcnt - Y)) <= R2;
endmodule
