//-------------------- 31_base--------------------
//----------Common Part----------
`define Enable                  1'b1
`define Disable                 1'b0
`define True                    1
`define False                   0
`define RstEnable               1'b1
`define RstDisable              1'b0
`define ReadEnable              1'b1
`define ReadDisable             1'b0
`define WriteEnable             1'b1
`define WriteDisable            1'b0
`define ZeroWord                32'h00000000


//----------Instruction Part----------
`define InstAddrBus             31:0
`define InstBus                 31:0
`define OpBus                   5:0
`define DefaultInstAddr         32'h00400000


//----------Register Part----------
`define RegAddrBus              4:0
`define RegBus                  31:0
`define DRegBus                 63:0
`define HigherBus               63:32
`define LowerBus                31:0
`define HalfRegBus              15:0
`define RegSize                 32
`define RegAddrWidth            5
`define FailRegAddr             5'b00000


//----------ALU Part----------
`define ALUCtrlBus              3:0
`define AnsBus                  32:0

`define ALU_addu                4'b0000
`define ALU_add                 4'b0010
`define ALU_subu                4'b0001
`define ALU_sub                 4'b0011
`define ALU_and                 4'b0100
`define ALU_or                  4'b0101
`define ALU_xor                 4'b0110
`define ALU_nor                 4'b0111
`define ALU_lui                 4'b100x
`define ALU_slt                 4'b1011
`define ALU_sltu                4'b1010
`define ALU_sra                 4'b1100
`define ALU_sll                 4'b111x
`define ALU_srl                 4'b1101


//----------Memory Part----------
`define MemSave                 1'b1
`define MemLoad                 1'b0
`define MemAddrBus              31:0
`define MemBus                  31:0
`define DefaultDataAddr         32'h10010000


//----------Operation Part----------
`define No_op                   6'b111111
`define No_func                 6'b111111

`define R_type_op               6'b000000
`define add_func                6'b100000
`define addu_func               6'b100001
`define sub_func                6'b100010
`define subu_func               6'b100011
`define and_func                6'b100100
`define or_func                 6'b100101
`define xor_func                6'b100110
`define nor_func                6'b100111
`define slt_func                6'b101010
`define sltu_func               6'b101011
`define sll_func                6'b000000
`define srl_func                6'b000010
`define sra_func                6'b000011
`define sllv_func               6'b000100
`define srlv_func               6'b000110
`define srav_func               6'b000111
`define jr_func                 6'b001000

`define addi_op                 6'b001000
`define addiu_op                6'b001001
`define andi_op                 6'b001100
`define ori_op                  6'b001101
`define xori_op                 6'b001110
`define lw_op                   6'b100011
`define sw_op                   6'b101011
`define beq_op                  6'b000100
`define bne_op                  6'b000101
`define slti_op                 6'b001010
`define sltiu_op                6'b001011
`define lui_op                  6'b001111

`define j_op                    6'b000010
`define jal_op                  6'b000011

//-------------------- 23_extend --------------------
//----------Extend Operation Part----------
`define lb_op                   6'b100000
`define lbu_op                  6'b100100
`define lh_op                   6'b100001
`define lhu_op                  6'b100101
`define sb_op                   6'b101000
`define sh_op                   6'b101001

//op == ex_op1
`define ex_op1                  6'b000000
`define jalr_func               6'b001001
`define syscall_func            6'b001100
`define teq_func                6'b110100
`define break_func              6'b001101
`define multu_func              6'b011001
`define div_func                6'b011010
`define divu_func               6'b011011
`define mthi_func               6'b010001
`define mtlo_func               6'b010011
`define mfhi_func               6'b010000
`define mflo_func               6'b010010    

`define ex_op2                  6'b011100 
`define clz_func                6'b100000
`define mul_func                6'b000010

`define CP0_op                  6'b010000
`define eret_func               6'b011000
`define mfc0_rs                 5'b00000
`define mtc0_rs                 5'b00100

`define bgez_op                 6'b000001

//----------CP0 Part----------
`define CP0_size                32

`define CP0AddrBus              4:0

`define status_i                12
`define cause_i                 13
`define epc_i                   14

`define IE                      0
`define DefaultErrAddr          32'h00400004

`define SYSCALL_ERR             4'b1000
`define BREAK_ERR               4'b1001
`define TEQ_ERR                 4'b1101

//----------MDU Part----------
`define MDUCtrlBus              2:0
`define MDU_default             3'h0
`define MDU_multu               3'h2
`define MDU_div                 3'h3
`define MDU_divu                3'h4
`define MDU_mthi                3'h5
`define MDU_mtlo                3'h6
