`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/15 13:12:30
// Design Name: 
// Module Name: VGA_driver
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


`define H_FRONT 11'd40
`define H_BACK  11'd88
`define H_SYNC  11'd128
`define H_DISP  11'd800
`define H_TOTAL (`H_FRONT + `H_BACK + `H_SYNC + `H_DISP)

`define V_FRONT 11'd1
`define V_BACK  11'd23
`define V_SYNC  11'd4
`define V_DISP  11'd600
`define V_TOTAL (`V_FRONT + `V_BACK + `V_SYNC + `V_DISP)

`define TITLE_X1 'd50
`define TITLE_Y1 'd10
`define TITLE_X2 'd750
`define TITLE_Y2 'd150
`define TITLE_XL (`TITLE_X2 - `TITLE_X1)
`define TITLE_YL (`TITLE_Y2 - `TITLE_Y1)

`define TEXT_X1 'd88
`define TEXT_Y1 'd170
`define TEXT_X2 'd216
`define TEXT_Y2 'd330
`define TEXT_XL (`TEXT_X2 - `TEXT_X1)
`define TEXT_YL (`TEXT_Y2 - `TEXT_Y1)

module VGA_driver(
    input CLK,
    input RST,
    input [2:0] Q,
    input [159:0] reg1to5,
    output reg[3:0] R,
    output reg[3:0] G,
    output reg[3:0] B,
    output HS,
    output VS
    );
    wire [10:0] Hcnt, Vcnt;
    VGA_control#(.H_TOTAL(`H_TOTAL), .V_TOTAL(`V_TOTAL)) get_HV(.CLK(CLK), .RST(RST), .Hcnt(Hcnt), .Vcnt(Vcnt));
    assign HS = (Hcnt < `H_SYNC) ? 1'b0 : 1'b1; //VGA行同步信号
    assign VS = (Vcnt < `V_SYNC) ? 1'b0 : 1'b1; //VGA场信号同步
    //---------------输出区域使能 800*600---------------
    wire [10:0] en_H, en_V; wire en;
    assign en_H = ((Hcnt >= `H_SYNC + `H_BACK) && (Hcnt < `H_TOTAL - `H_FRONT)) ? (Hcnt - `H_SYNC - `H_BACK + 1) : 11'b0;
    assign en_V = ((Vcnt >= `V_SYNC + `V_BACK) && (Vcnt < `V_TOTAL - `V_FRONT)) ? (Vcnt - `V_SYNC - `V_BACK + 1) : 11'b0; 
    assign en = ((en_H > 11'b0) && (en_V > 11'b0)) ? 1'b1 : 1'b0;
    //---------------提示坐标确定---------------
    wire [10:0] dTITLE_H, dTITLE_V;
    assign dTITLE_H = ((Hcnt >= `H_SYNC + `H_BACK + `TITLE_X1) && (Hcnt < `H_SYNC + `H_BACK + `TITLE_X2)) ? 
                      (Hcnt - `H_SYNC - `H_BACK - `TITLE_X1) : `TITLE_XL;
    assign dTITLE_V = ((Vcnt >= `V_SYNC + `V_BACK + `TITLE_Y1) && (Vcnt < `V_SYNC + `V_BACK + `TITLE_Y2)) ? 
                      (Vcnt - `V_SYNC - `V_BACK - `TITLE_Y1) : `TITLE_YL;
    //---------------正文坐标确定---------------
    wire [10:0] dTEXT_H, dTEXT_V;
    assign dTEXT_H = ((Hcnt >= `H_SYNC + `H_BACK + `TEXT_X1) && (Hcnt < `H_SYNC + `H_BACK + `TEXT_X2)) ? 
                     (Hcnt - `H_SYNC - `H_BACK - `TEXT_X1) : `TEXT_XL; 
    assign dTEXT_V = ((Vcnt >= `V_SYNC + `V_BACK + `TEXT_Y1) && (Vcnt < `V_SYNC + `V_BACK + `TEXT_Y2)) ? 
                     (Vcnt - `V_SYNC - `V_BACK - `TEXT_Y1) : `TEXT_YL;
    wire [2:0] dTH; wire[3:0] dTV;
    assign dTH = ((Hcnt >= `H_SYNC + `H_BACK + `TEXT_X1) && (Hcnt < `H_SYNC + `H_BACK + `TEXT_X2)) ? 
                 (((Hcnt - `H_SYNC - `H_BACK - `TEXT_X1) & 'b1111) >> 'd1) : 'd0;
    assign dTV = ((Vcnt >= `V_SYNC + `V_BACK + `TEXT_Y1) && (Vcnt < `V_SYNC + `V_BACK + `TEXT_Y2)) ? 
                 (((Vcnt - `V_SYNC - `V_BACK - `TEXT_Y1) & 'b11111) >> 'd1) : 'd0;
    //---------------正文字符位置确定---------------
    wire [5:0] dcnt;
    assign dcnt = ((Hcnt >= `H_SYNC + `H_BACK + `TEXT_X1) && (Hcnt < `H_SYNC + `H_BACK + `TEXT_X2) 
                   && (Vcnt >= `V_SYNC + `V_BACK + `TEXT_Y1) && (Vcnt < `V_SYNC + `V_BACK + `TEXT_Y2)) ?
                  ((((Vcnt - `V_SYNC - `V_BACK - `TEXT_Y1) >> 'd5) << 'd3) + ((Hcnt - `H_SYNC - `H_BACK - `TEXT_X1) >> 'd4)): 'b0;
    //---------------提示部分判圆---------------
    wire [4:0] fC;
    judge_circle#(
                  .X1(`H_SYNC + `H_BACK + 'd120),
                  .X2(`H_SYNC + `H_BACK + 'd260),
                  .X3(`H_SYNC + `H_BACK + 'd400),
                  .X4(`H_SYNC + `H_BACK + 'd540),
                  .X5(`H_SYNC + `H_BACK + 'd680),
                  .Y(`V_SYNC + `V_BACK + ((`TITLE_Y1 + `TITLE_Y2) >> 'b1))
                  )
                  in_circle(.Hcnt(Hcnt), .Vcnt(Vcnt), .fC(fC));
    //---------------正文部分取字符点阵---------------
    wire Point;
    VGA_char print_char(.dH(dTH), .dV(dTV),
                        .alph(reg1to5[((((dcnt >> 'd3) + 'd1) << 'd5) - (((dcnt & 'b111) << 'd2) + 1)) -: 4]),
                        .Point(Point));
    //---------------RGB值确定---------------
    always @(Hcnt or Vcnt)
    begin
        if(en > 1'b0)
        begin
            if(dTITLE_H < `TITLE_XL && dTITLE_V < `TITLE_YL ) //TITLE_part
            begin
                case(Q)
                    'd0, 'd1: // input
                        if(fC[0] == 1)
                        begin
                            R <= 'd0; G <= 'd0; B <= 'd15; // blue
                        end
                        else
                        begin
                            R <= 'd0; G <= 'd0; B <= 'd0;
                        end
                    'd2: // wait for start
                        if(fC[1] == 1)
                        begin
                            R <= 'd15; G <= 'd15; B <= 'd0; // yellow
                        end
                        else
                        begin
                            R <= 'd0; G <= 'd0; B <= 'd0;
                        end
                    'd3, 'd4: // finish
                        if(fC[2] == 1)
                        begin
                            R <= 'd15; G <= 'd0; B <= 'd0; // red
                        end
                        else
                        begin
                            R <= 'd0; G <= 'd0; B <= 'd0;
                        end
                    default: ;
                endcase
            end
            else if (dTEXT_H < `TEXT_XL && dTEXT_V < `TEXT_YL) //TEXT_part
            begin
                if(Point == 1)
                begin
                    R <= 'd0; G <= 'd15; B <= 'd0;
                end
                else
                begin
                    R <= 'd0; G <= 'd0; B <= 'd0;
                end
            end
            else
            begin
                R <= 'd0; G <= 'd0; B <= 'd0;
            end
        end
        else
        begin
            R <= 'd2;
            G <= 'd2; //消隐区设置RBG，亮度调整，越低越亮
            B <= 'd2;
        end
    end
endmodule
