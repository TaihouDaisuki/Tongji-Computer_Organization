start: 	
	j loop_start
loop:
	lw $3, 100
	lw $4, 104
	lw $5, 108
	lw $6, 112
	lw $7, 116
	lw $31, 120
	beq $31, 0x00000000, reloop
	j sort_start
reloop:
	j loop
loop_start:
	addi $2, $0, 3
	mtc0 $2, $12
	syscall
	
sort_start:
	sub $8, $3, $4
	bgez $8, skip12
	addi $9, $3, 0
	addi $3, $4, 0
	addi $4, $9, 0
skip12:
	sub $8, $3, $5
	bgez $8, skip13
	addi $9, $3, 0
	addi $3, $5, 0
	addi $5, $9, 0
skip13:
	sub $8, $3, $6
	bgez $8, skip14
	addi $9, $3, 0
	addi $3, $6, 0
	addi $6, $9, 0
skip14:
	sub $8, $3, $7
	bgez $8, skip15
	addi $9, $3, 0
	addi $3, $7, 0
	addi $7, $9, 0
skip15:
	sub $8, $4, $5
	bgez $8, skip23
	addi $9, $4, 0
	addi $4, $5, 0
	addi $5, $9, 0
skip23:
	sub $8, $4, $6
	bgez $8, skip24
	addi $9, $4, 0
	addi $4, $6, 0
	addi $6, $9, 0
skip24:
	sub $8, $4, $7
	bgez $8, skip25
	addi $9, $4, 0
	addi $4, $7, 0
	addi $7, $9, 0
skip25:
	sub $8, $5, $6
	bgez $8, skip34
	addi $9, $5, 0
	addi $5, $6, 0
	addi $6, $9, 0
skip34:
	sub $8, $5, $7
	bgez $8, skip35
	addi $9, $5, 0
	addi $5, $7, 0
	addi $7, $9, 0
skip35:
	sub $8, $6, $7
	bgez $8, skip45
	addi $9, $6, 0
	addi $6, $7, 0
	addi $7, $9, 0
skip45:
	addi $31, $0, 0x00000000
	sw $3, 100
	sw $4, 104
	sw $5, 108
	sw $6, 112
	sw $7, 116
	sw $31, 120
	eret
	

