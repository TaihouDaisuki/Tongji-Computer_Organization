`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/15 14:01:01
// Design Name: 
// Module Name: top_file
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


module top_file(
    //-----common port-----
    input clk,
    input rst,
    
    //-----input port-----
    input start_press,
    input input_press,
    input [15:0] input_num,
    
    //-----VGA port-----
    output [3:0] R,
    output [3:0] G,
    output [3:0] B,
    output HS,
    output VS
    );
    //-----State define-----
    reg [2:0] Q = 0;
    reg [2:0] cnt_input = 0;
    reg [4:0] time_cnt;
    wire out_input_press;
    reg delay1, delay2, delay3;
    
    //-----CPU admin port-----
    wire reg_admin_ena;
    wire [4:0] reg_i_admin = (Q == 'd0 || Q == 'd1 || Q == 'd2) ? {2'b0, cnt_input} : 
                                ((Q == 'd3 && reg_admin_ena) ? 'd31 : 'd0);
    wire [31:0] reg_input_admin = (Q == 'd0 || Q == 'd1 || Q == 'd2) ? {16'b0, input_num} : 
                                    ((Q == 'd3 && reg_admin_ena) ? 'd0 : 32'hffffffff);
    
    // CPU
    wire [159:0] regs_from_cpu;
    sccomp_dataflow cpu_unit(.clk_in(clk), .reset(rst),
                             .oreg(regs_from_cpu), .reg_admin_ena(reg_admin_ena),
                             .reg_i(reg_i_admin), .reg_input(reg_input_admin));
    // VGA                   
    VGA_driver VGA(.CLK(clk), .RST(rst),
                   .Q(Q),
                   .reg1to5(regs_from_cpu),
                   .R(R), .G(G), .B(B),
                   .HS(HS), .VS(VS));
    
    //press_down
    always @(posedge clk)
    begin
        if(rst == 1)
        begin
            delay1 <= 0; delay2 <= 0; delay3 <= 0;
        end
        else
        begin
            delay1 <= input_press;
            delay2 <= delay1;
            delay3 <= delay2;
        end
    end
    assign out_input_press = delay1 & delay2 & delay3;
     
    // State machine
    always @(posedge clk)
    begin
        if(rst == 1)
        begin
            Q <= 0;
            cnt_input <= 'd3;
            time_cnt <= 0;
        end
        else
        begin
            if(Q == 'd0)  //input
            begin
                if(out_input_press)
                begin
                    Q <= 'd1;
                    cnt_input <= cnt_input + 1;
                end
            end
            else if(Q == 'd1) //buffer
            begin
                if(cnt_input < 'd7)
                begin
                    if(out_input_press == 'd0)
                        Q <= 'd0;
                end
                else
                    Q <= 'd2;
            end
            else if(Q == 'd2) // wait for start
            begin
                if(start_press)
                    Q <= 'd3;
            end
            else if(Q == 'd3)
            begin
                if(reg_admin_ena == 0)
                    Q <= 'd4;
            end
            else
                ;
        end
    end
endmodule
