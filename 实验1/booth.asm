# s1 * s2 -> [s0,s2]
.text
	main:
		addi	$t2, $zero, 32
		# t1 highest
		addi	$t1, $zero, 0
		# t0 sec_highest
		addi	$t0, $zero, 0
		addi	$s0, $zero, 0
	input:
		addi	$v0, $zero, 5
		syscall
		add	$s1, $zero, $v0
		
		addi	$v0, $zero, 5
		syscall
		add	$s2, $zero, $v0
	
	mult_work:
		andi	$t1, $s2, 1
		beq	$t1, 0, even_work
		beq	$t1, 1, odd_work
		
		even_work:
			beq	$t0, 0, calc_continue
			beq	$t0, 1, plus
		odd_work:
			beq	$t0, 0, minus
			beq	$t0, 1, calc_continue

		plus:
			add	$s0, $s0, $s1
			j	calc_continue
		minus:
			sub	$s0, $s0, $s1
			j	calc_continue
			
	calc_continue:
		andi	$t3, $s0, 1
		sll	$t3, $t3, 31
		
		sra	$s0, $s0, 1
		addi	$t0, $t1, 0
		srl	$s2, $s2, 1
		addu	$s2, $s2, $t3
		
		subi	$t2, $t2, 1
		bne	$t2, 0, mult_work
		
	finish:
		addi	$v0, $zero, 10
		syscall
