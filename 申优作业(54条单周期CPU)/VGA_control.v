`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/15 13:16:08
// Design Name: 
// Module Name: VGA_control
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


module VGA_control
    #(
        parameter H_TOTAL = 1056,
        parameter V_TOTAL = 628
    )
    (
        input CLK,
        input RST,
        output reg [10:0] Hcnt,
        output reg [10:0] Vcnt
    );
    initial
    begin
        Hcnt <= 0;
        Vcnt <= 0;
    end
    wire VGA_CLK;
    Divider#(.mod(2)) get_VGA_CLK(.I_CLK(CLK), .RST(RST), .O_CLK(VGA_CLK));
    
    //---------------行扫描---------------
    always @(posedge VGA_CLK or posedge RST)
    begin
        if(RST)
            Hcnt <= 11'd0;
        else
        begin
            if(Hcnt < H_TOTAL - 1)
                Hcnt <= Hcnt + 1;
            else
                Hcnt <= 11'd0;
        end
    end
    //---------------列扫描---------------
    always @(posedge VGA_CLK or posedge RST)
    begin
        if(RST)
            Vcnt <= 11'd0;
        else if(Hcnt == H_TOTAL - 1) //行结束
        begin
            if(Vcnt < V_TOTAL - 1)
                Vcnt <= Vcnt + 1;
            else
                Vcnt <= 11'd0;
        end
    end
endmodule
