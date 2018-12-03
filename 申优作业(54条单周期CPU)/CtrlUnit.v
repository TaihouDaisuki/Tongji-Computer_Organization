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

    output reg reg_ena,
    output [`RegAddrBus] waddr,
    output reg [`RegBus] wdata,

    output ram_ena,
    output [`MemAddrBus] ram_addr,
    output reg [`MemBus] ram_wdata,

    //----------extend_op port----------
    input [`RegBus] cp0_rdata,
    input [`InstAddrBus] exc_addr,
    output mtc0,
    output eret,
    output teq_exc,
    output reg [3:0] cause,
    output [`CP0AddrBus] rd,            // CP0 addr

    input [`RegBus] mul_result,
    input [`RegBus] hi,
    input [`RegBus] lo,
    output reg [`MDUCtrlBus] mdu_op
    );

    //----------Instruction Prework----------
    wire [5:0] op =     inst[31:26];
    wire [4:0] shamt =  inst[10:6];
    wire [5:0] func =   inst[5:0];
    wire [15:0] imm =   inst[15:0];
    wire [25:0] addr =  inst[25:0];

    assign rs = inst[25:21];
    assign rt = inst[20:16];
    assign rd = inst[15:11];
    
    wire [`RegBus] shamt_ex = {27'b0, shamt};
    wire [`RegBus] imm_ex = (op == `andi_op || op == `ori_op || op == `xori_op) ? {16'b0, imm} : {{16{imm[15]}}, imm};

    //----------Register Prework----------
    assign waddr = (op == `R_type_op || op == `ex_op2) ? rd : ((op ==`jal_op) ? 5'b11111 : rt);
    
    //----------PC Prework----------
    wire [`InstAddrBus] npc = pc + 4;
    wire [`InstAddrBus] pc_jump = {npc[31:28], addr, 2'b00};
    wire [`InstAddrBus] pc_branch = npc + {{14{imm[15]}}, imm, 2'b00};

    //----------RAM Prework----------
    assign ram_ena = (op == `sw_op || op == `sb_op || op == `sh_op) ? `MemSave : `MemLoad;
    assign ram_addr = rdata1 + imm_ex;
    reg [`MemBus] load_data;

    //----------CP0 Prework----------
    assign eret = (op == `CP0_op && func == `eret_func) ? `Enable : `Disable;
    assign mtc0 = (op == `CP0_op && rs == `mtc0_rs) ? `Enable : `Disable;
    assign teq_exc = (rdata1 == rdata2) ? `Enable : `Disable;
    wire mfc0 = (op == `CP0_op && rs == `mfc0_rs) ? `Enable : `Disable;

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

            //-----extend_op-----
            `lb_op:     load_data <= {{24{ram_rdata[7]}}, ram_rdata[7:0]};
            `lbu_op:    load_data <= {24'b0, ram_rdata[7:0]};
            `lh_op:     load_data <= {{16{ram_rdata[15]}}, ram_rdata[15:0]};
            `lhu_op:    load_data <= {16'b0, ram_rdata[15:0]};
            
            default:    load_data <= ram_rdata;
        endcase

        //----------save part----------
        case (op)
            `sw_op:     ram_wdata <= rdata2;

            //-----extend_op-----
            `sb_op:     ram_wdata <= {24'b0, rdata2[7:0]};
            `sh_op:     ram_wdata <= {16'b0, rdata2[15:0]};

            default:    ram_wdata <= rdata2;
        endcase
    end

    //----------Register Port----------
    always @(*)
    begin
        //----------wena part----------
        case (op)
            `R_type_op:
            begin
                case(func)
                    `jr_func:   reg_ena <= `WriteDisable;
                    
                    //-----extend_op-----
                    `syscall_func, `break_func:
                                reg_ena <= `WriteDisable;
                    `multu_func,
                    `div_func, `divu_func,
                    `mthi_func, `mtlo_func:
                                reg_ena <= `WriteDisable;
                
                    default:    reg_ena <= `WriteEnable; //alu_op
                endcase
                
            end

            `addi_op, `addiu_op,
            `andi_op, `ori_op, `xori_op,
            `lw_op,
            `slti_op, `sltiu_op,
            `lui_op,
            `jal_op:        reg_ena <= `WriteEnable;

            //-----extend_op-----
            `lb_op, `lbu_op,
            `lh_op, `lhu_op:
                            reg_ena <= `WriteEnable;
                            
            `CP0_op:        reg_ena <= (rs == `mfc0_rs) ? `WriteEnable : `WriteDisable;
            
            `ex_op2:        reg_ena <= `WriteEnable;    // clz && mul
            default:        reg_ena <= `WriteDisable;
        endcase

        //----------wdata part----------
        case (op)
            `jal_op:        wdata <= npc;
            `lw_op:         wdata <= load_data;

            `R_type_op:
            begin
                case (func)
                    //-----extend_op-----
                    `jalr_func: wdata <= npc;
                    `mfhi_func: wdata <= hi;
                    `mflo_func: wdata <= lo;

                    default: wdata <= alu_result; //alu_op
                endcase
            end

            //-----extend_op-----
            `ex_op2:
            begin
                case (func)
                    `clz_func:
                    begin
                        casex (rdata1)
                            32'b1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx: wdata <= 32'h00;
                            32'b01xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx: wdata <= 32'h01;
                            32'b001xxxxxxxxxxxxxxxxxxxxxxxxxxxxx: wdata <= 32'h02;
                            32'b0001xxxxxxxxxxxxxxxxxxxxxxxxxxxx: wdata <= 32'h03;
                            32'b00001xxxxxxxxxxxxxxxxxxxxxxxxxxx: wdata <= 32'h04;
                            32'b000001xxxxxxxxxxxxxxxxxxxxxxxxxx: wdata <= 32'h05;
                            32'b0000001xxxxxxxxxxxxxxxxxxxxxxxxx: wdata <= 32'h06;
                            32'b00000001xxxxxxxxxxxxxxxxxxxxxxxx: wdata <= 32'h07;
                            32'b000000001xxxxxxxxxxxxxxxxxxxxxx?: wdata <= 32'h08;
                            32'b0000000001xxxxxxxxxxxxxxxxxxxxxx: wdata <= 32'h09;
                            32'b00000000001xxxxxxxxxxxxxxxxxxxxx: wdata <= 32'h0a;
                            32'b000000000001xxxxxxxxxxxxxxxxxxxx: wdata <= 32'h0b;
                            32'b0000000000001xxxxxxxxxxxxxxxxxxx: wdata <= 32'h0c;
                            32'b00000000000001xxxxxxxxxxxxxxxxxx: wdata <= 32'h0d;
                            32'b000000000000001xxxxxxxxxxxxxxxxx: wdata <= 32'h0e;
                            32'b0000000000000001xxxxxxxxxxxxxxxx: wdata <= 32'h0f;
                            32'b00000000000000001xxxxxxxxxxxxxxx: wdata <= 32'h10;
                            32'b000000000000000001xxxxxxxxxxxxxx: wdata <= 32'h11;
                            32'b0000000000000000001xxxxxxxxxxxxx: wdata <= 32'h12;
                            32'b00000000000000000001xxxxxxxxxxxx: wdata <= 32'h13;
                            32'b000000000000000000001xxxxxxxxxxx: wdata <= 32'h14;
                            32'b0000000000000000000001xxxxxxxxxx: wdata <= 32'h15;
                            32'b00000000000000000000001xxxxxxxxx: wdata <= 32'h16;
                            32'b000000000000000000000001xxxxxxxx: wdata <= 32'h17;
                            32'b0000000000000000000000001xxxxxxx: wdata <= 32'h18;
                            32'b00000000000000000000000001xxxxxx: wdata <= 32'h19;
                            32'b000000000000000000000000001xxxxx: wdata <= 32'h1a;
                            32'b0000000000000000000000000001xxxx: wdata <= 32'h1b;
                            32'b00000000000000000000000000001xxx: wdata <= 32'h1c;
                            32'b000000000000000000000000000001xx: wdata <= 32'h1d;
                            32'b0000000000000000000000000000001x: wdata <= 32'h1e;
                            32'b00000000000000000000000000000001: wdata <= 32'h1f;
                            32'b00000000000000000000000000000000: wdata <= 32'h20;
                            default: wdata <= 32'h00;
                        endcase
                    end
                    `mul_func: wdata <= mul_result;
                    default: wdata <= 32'h0;
                endcase
            end
       
            //-----extend_op-----
            `lb_op, `lbu_op, `lh_op, `lhu_op:  wdata <= load_data;

            `CP0_op: wdata <= (rs == `mfc0_rs) ? cp0_rdata : alu_result;

            default: wdata <= alu_result;
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

                    //-----extend_op-----
                    `jalr_func:     pc_out <= rdata1;
                    `syscall_func, `break_func, `teq_func:
                                    pc_out <= exc_addr; 

                    default:        pc_out <= npc;
                endcase
            end
            `j_op, `jal_op:     pc_out <= pc_jump;
            
            `beq_op:            pc_out <= (rdata1 == rdata2) ? pc_branch : npc;
            `bne_op:            pc_out <= (rdata1 != rdata2) ? pc_branch : npc;     
            
            //-----extend_op-----
            `CP0_op:
            begin
                case (func)
                    `eret_func:     pc_out <= exc_addr;
                    default:        pc_out <= npc;
                endcase
            end

            `bgez_op:
                pc_out <= (rdata1[31] == 0) ? pc_branch : npc;
            default:            pc_out <= npc;
        endcase
    end

    //---------------Extend Operation Port---------------
    //----------CP0 Port----------
    always @(*)
    begin
        if(op == `ex_op1)
        begin
            case (func)
                `syscall_func:  cause <= `SYSCALL_ERR;
                `teq_func:      cause <= `TEQ_ERR;
                `break_func:    cause <= `BREAK_ERR;
                default:        cause <= 4'b0000;
            endcase
        end
    end

    //----------MDU Port----------
    always @(*)
    begin
        if(op == `ex_op1)
        begin
            case (func)
                `multu_func: mdu_op <= `MDU_multu;
                `div_func:   mdu_op <= `MDU_div;
                `divu_func:  mdu_op <= `MDU_divu;
                `mthi_func:  mdu_op <= `MDU_mthi;
                `mtlo_func:  mdu_op <= `MDU_mtlo;
                default:     mdu_op <= `MDU_default;
            endcase
        end
        else
            mdu_op <= `MDU_default;
    end

endmodule
