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
