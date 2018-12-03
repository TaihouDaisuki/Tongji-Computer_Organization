.data
	buffer:	.space 20
.text
	main:
		la	$s0, buffer
		addi	$s1, $zero, 5
	input:
		addi	$v0, $zero, 5
		syscall
		sw	$v0, ($s0)
		subiu	$s1, $s1, 1
		addi	$s0, $s0, 32
		bne	$s1, $zero, input
		
		la	$s0, buffer
	sort_reset:
		addi	$t0, $zero, 128
	sort_loop:
		beq	$t0, 0, finish
		add	$t1, $s0, $zero
		add	$t2, $zero, 0
		i_loop:
			lw	$s1, ($t1)
			lw	$s2, 32($t1)
			bgt	$s1, $s2, swap
			swap_finish:
				addiu	$t1, $t1, 32
				addiu	$t2, $t2, 32
				bne	$t2, $t0, i_loop
	i_finish:
		subi	$t0, $t0, 32
		j	sort_loop
				
	#procedure swap(a,b)
	swap:
		sw	$s1, 32($t1)
		sw	$s2, ($t1)
		j	swap_finish
	#
	
	finish:
		lw	$2, ($s0)
		lw	$3, 32($s0)
		lw	$4, 64($s0)
		lw	$5, 96($s0)
		lw	$6, 128($s0)
