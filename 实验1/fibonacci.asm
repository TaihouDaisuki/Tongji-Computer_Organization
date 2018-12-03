.text		
	main:
	input:
		addi 	$v0, $zero, 5
		syscall
		add 	$4, $v0, $zero
	reset:
		addi	$2, $zero, 0
		addi	$3, $zero, 1
	work:
		add	$5, $2, $zero
		add	$2, $3, $zero
		add	$3, $5, $2
		beq	$4, 0, finish
		subi	$4, $4, 1
		j	work
	finish:
		add	$1, $5, $zero
