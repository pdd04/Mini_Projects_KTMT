.data
	A: 		.space 100
	Message: 	.asciiz "Nhap so phan tu mang: "
	Message1: 	.asciiz "Nhap so: "
	Message2: 	.asciiz "Day ma cac phan tu so duong o dau so am o cuoi la:\n"
	Space: 		" "
	Eror: 		.asciiz "So phan tu mang phai lon hon bang 1!\n"
.text
main:
	li 	$v0, 4
	la 	$a0, Message
	syscall
	
	li 	$v0, 5
	syscall
	
	move 	$s0, $v0		# $s0 = n
	blt 	$s0, 1, PrintEror
	la 	$a1, A			# $a1 = address of A[0]
	addi 	$a2, $s0, 0
	j 	input_array
	
exit:
	li 	$v0, 10
	syscall
	
input_array:
	# Nhap input:
	beq 	$t2, $s0, Min		# $t2 = i = N => Min branch
	add 	$t0, $a1, $t1		# $t0 = address A[i]
	
	li 	$v0, 4
	la 	$a0, Message1
	syscall
	
	li 	$v0, 5
	syscall
	
	move 	$s1, $v0
	sw 	$s1, 0($t0)
	addi 	$t2, $t2, 1
	mul 	$t1, $t2, 4
	j 	input_array
	
Min:
	
	li 	$t0, 0		
	li 	$s1, 0		# $s1 = min = 0
	lw 	$v1, 0($a1)	# $v1 = A[0]
	addi 	$t2, $a1, 0	# $t2 = address of A[0]

FindMin:
	beq 	$t0, $s0, Sort		# $t0 = N => sort branch
	lw 	$t3, 0($t2)		# load A[i] vao $t3
	addi 	$t2, $t2, 4
	addi 	$t0, $t0, 1
	bgt 	$t3, $v1, FindMin	# $t3 > $t1 = min thi loop lai
	addi 	$v1, $t3, 0		# khong thi $t3 = $v1 = new min
	addi 	$s1, $t2, -4		# address cua min vao $s1
	j 	FindMin
	
Sort:
	mul 	$t0, $s0, 4		
	addi 	$t0, $t0, -4		
	add 	$t1, $a1, $t0		# address cua A[n - 1]
	
	# swap
	lw 	$t2, 0($t1)		# $t2 = A[n - 1]
	sw 	$v1, 0($t1)		# A[n - 1] = min
	sw 	$t2, 0($s1)		# A[index cua gia tri min] = $t2
	
	addi 	$s0, $s0, -1		# N--
	beqz 	$s0, PrintResult
	j 	Min
	
PrintResult:
	li 	$v0, 4
	la 	$a0, Message2
	syscall
	li 	$t0, 0
	
Print:
	# in ra ket qua
	beq 	$t0, $a2, exit
	li 	$v0, 1
	lw 	$a0, 0($a1)
	syscall
	
	li 	$v0, 4
	la 	$a0, Space
	syscall
	
	addi 	$t0, $t0, 1
	addi 	$a1, $a1, 4
	j 	Print
	
PrintEror:
	li 	$v0, 4
	la 	$a0, Eror
	syscall
	j 	main