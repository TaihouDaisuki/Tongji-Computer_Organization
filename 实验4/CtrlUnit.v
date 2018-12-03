`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/18 17:52:37
// Design Name: 
// Module Name: CtrlUnit
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

module CtrlUnit(
    input [`InstBus] inst,
    input [`InstAddrBus] pc,

    output reg [`InstAddrBus] pc_out,

    output [`RegAddrBus] rs,
    output [`RegAddrBus] rt,

    input [`RegBus] rdata1,
    input [`RegBus] rdata2,

    output reg [`ALUCtrlBus] aluc,
    output reg [`RegBus] ALU_a,
    output reg [`RegBus] ALU_b,

    input [`MemBus] ram_rdata,
    input [`RegBus] alu_result,

    output reg we,
    output [`RegAddrBus] waddr,
    output reg [`RegBus] wdata,

    output ram_ena,
    output [`MemAddrBus] ram_addr,
    output reg [`MemBus] ram_wdata    
    );

    //----------Instruction Prework----------
    wire [5:0] op =     inst[31:26];
    wire [4:0] shamt =  inst[10:6];
    wire [5:0] func =   inst[5:0];
    wire [15:0] imm =   inst[15:0];
    wire [25:0] addr =  inst[25:0];

    assign rs = inst[25:21];
    assign rt = inst[20:16];
    wire [`RegAddrBus] rd = inst[15:11];
    
    wire [`RegBus] shamt_ex = {27'b0, shamt};
    wire [`RegBus] imm_ex = (op == `andi_op || op == `ori_op || op == `xori_op) ? {16'b0, imm} : {{16{imm[15]}}, imm};

    //----------Register Prework----------
    assign waddr = (op == `R_type_op) ? rd : ((op ==`jal_op) ? 5'b11111 : rt);
    
    //----------PC Prework----------
    wire [`InstAddrBus] npc = pc + 4;
    wire [`InstAddrBus] pc_jump = {npc[31:28], addr, 2'b00};
    wire [`InstAddrBus] pc_branch = npc + {{14{imm[15]}}, imm, 2'b00};

    //----------RAM Prework----------
    assign ram_ena = (op == `sw_op) ? `MemSave : `MemLoad;
    assign ram_addr = rdata1 + imm_ex;
    reg [`MemBus] load_data;


    //----------ALU Port----------
    always @(*)
    begin
        //----------ALU data----------
        case (op)
            `R_type_op:
            begin
                case (func)
                    `add_func, `sub_func,
                    `addu_func, `subu_func,
                    `and_func, `or_func, `xor_func, `nor_func,
                    `slt_func, `sltu_func, 
                    `sllv_func, `srlv_func, `srav_func:
                    begin
                        ALU_a <= rdata1;
                        ALU_b <= rdata2;
                    end

                    `sll_func, `srl_func, `sra_func:
                    begin
                        ALU_a <= shamt_ex;
                        ALU_b <= rdata2;
                    end

                    default:
                    begin
                        ALU_a <= rdata1;
                        ALU_b <= rdata2;
                    end
                endcase
            end

            `addi_op, `addiu_op,
            `andi_op, `ori_op, `xori_op,
            `slti_op, `sltiu_op,
            `lui_op:
            begin
                ALU_a <= rdata1;
                ALU_b <= imm_ex;
            end

            default:
            begin
                ALU_a <= rdata1;
                ALU_b <= rdata2;
            end
        endcase
        //----------ALU control----------
        case (op)
            `R_type_op:
            begin
                case (func)
                    `add_func:                  aluc <= `ALU_add;
                    `addu_func:                 aluc <= `ALU_addu;
                    `sub_func:                  aluc <= `ALU_sub;
                    `subu_func:                 aluc <= `ALU_subu;
                    `and_func:                  aluc <= `ALU_and;
                    `or_func:                   aluc <= `ALU_or;
                    `xor_func:                  aluc <= `ALU_xor;
                    `nor_func:                  aluc <= `ALU_nor;
                    `slt_func:                  aluc <= `ALU_slt;
                    `sltu_func:                 aluc <= `ALU_sltu;
                    `sll_func, `sllv_func:      aluc <= `ALU_sll;
                    `srl_func, `srlv_func:      aluc <= `ALU_srl;
                    `sra_func, `srav_func:      aluc <= `ALU_sra;

                    default:                    aluc <= `ALU_addu;
                endcase
            end

            `addi_op:                           aluc <= `ALU_add;
            `addiu_op:                          aluc <= `ALU_addu;
            `andi_op:                           aluc <= `ALU_and;
            `ori_op:                            aluc <= `ALU_or;
            `xori_op:                           aluc <= `ALU_xor;
            `slti_op:                           aluc <= `ALU_slt;
            `sltiu_op:                          aluc <= `ALU_sltu;
            `lui_op:                            aluc <= `ALU_lui;

            default:                            aluc <= `ALU_addu;
        endcase
    end

    //----------RAM Port----------
    always @(*)
    begin
        //----------load part----------
        case (op)
            `lw_op:     load_data <= ram_rdata;
            
            default:    load_data <= ram_rdata;
        endcase

        //----------save part----------
        case (op)
            `sw_op:     ram_wdata <= rdata2;

            default:    ram_wdata <= rdata2;
        endcase
    end

    //----------Register Port----------
    always @(*)
    begin
        //----------wena part----------
        case (op)
            `sw_op,
            `beq_op, `bne_op,
            `j_op:          we <= `WriteDisable;

            default:        we <= `WriteEnable;
        endcase

        //----------wdata part----------
        case (op)
            `R_type_op:     wdata <= alu_result;
            `jal_op:        wdata <= npc;
            `lw_op:         wdata <= load_data;
            default:        wdata <= alu_result;
        endcase
    end

    //----------PC Port----------
    always @(*)
    begin
        case (op)
            `R_type_op:
            begin
                case (func)
                    `jr_func:       pc_out <= rdata1;

                    default:        pc_out <= npc;
                endcase
            end
            `j_op, `jal_op:     pc_out <= pc_jump;
            
            `beq_op:            pc_out <= (rdata1 == rdata2) ? pc_branch : npc;
            `bne_op:            pc_out <= (rdata1 != rdata2) ? pc_branch : npc;     
           
            default:            pc_out <= npc;
        endcase
    end
endmodule
