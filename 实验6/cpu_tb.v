`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/03 21:10:21
// Design Name: 
// Module Name: cpu_tb
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

module cpu_tb;
    reg clk = 0;
    reg rst;
    wire [`InstBus] inst;
    wire [`InstAddrBus] _pc;
    wire [`MemAddrBus] addr;
    
    wire [`InstAddrBus] pc = _pc - `DefaultInstAddr;
    
    integer file_output;
    integer counter;
    initial
    begin
        file_output = $fopen("regs.txt");
        rst = 1; counter = 0;
        #50 rst = 0;
    end
    
    always
    begin
        #40 clk = ~clk;
        #10
        if(clk == 1'b0) 
        begin
            if(counter == 2049) 
            begin
                $fclose(file_output);
            end
            else 
            begin
                counter = counter + 1;
                $fdisplay(file_output, "pc: %h", pc);
                $fdisplay(file_output, "instr: %h", cpu_tb.uut.inst);
                $fdisplay(file_output, "regfile0: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[0]);
                $fdisplay(file_output, "regfile1: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[1]);
                $fdisplay(file_output, "regfile2: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[2]);
                $fdisplay(file_output, "regfile3: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[3]);
                $fdisplay(file_output, "regfile4: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[4]);
                $fdisplay(file_output, "regfile5: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[5]);
                $fdisplay(file_output, "regfile6: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[6]);
                $fdisplay(file_output, "regfile7: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[7]);
                $fdisplay(file_output, "regfile8: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[8]);
                $fdisplay(file_output, "regfile9: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[9]);
                $fdisplay(file_output, "regfile10: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[10]);
                $fdisplay(file_output, "regfile11: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[11]);
                $fdisplay(file_output, "regfile12: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[12]);
                $fdisplay(file_output, "regfile13: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[13]);
                $fdisplay(file_output, "regfile14: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[14]);
                $fdisplay(file_output, "regfile15: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[15]);
                $fdisplay(file_output, "regfile16: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[16]);
                $fdisplay(file_output, "regfile17: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[17]);
                $fdisplay(file_output, "regfile18: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[18]);
                $fdisplay(file_output, "regfile19: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[19]);
                $fdisplay(file_output, "regfile20: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[20]);
                $fdisplay(file_output, "regfile21: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[21]);
                $fdisplay(file_output, "regfile22: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[22]);
                $fdisplay(file_output, "regfile23: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[23]);
                $fdisplay(file_output, "regfile24: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[24]);
                $fdisplay(file_output, "regfile25: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[25]);
                $fdisplay(file_output, "regfile26: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[26]);
                $fdisplay(file_output, "regfile27: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[27]);
                $fdisplay(file_output, "regfile28: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[28]);
                $fdisplay(file_output, "regfile29: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[29]);
                $fdisplay(file_output, "regfile30: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[30]);
                $fdisplay(file_output, "regfile31: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[31]);
            end
        end    
    end
    
    sccomp_dataflow uut(.clk_in(clk), .reset(rst),
                        .inst(inst), .pc(_pc), .addr(addr));
endmodule
