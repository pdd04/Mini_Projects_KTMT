.data
	A: 		.space 100
	Message: 	.asciiz "Nhap so phan tu mang: "
	Message1: 	.asciiz "Nhap so: "
	Message2: 	.asciiz "Nhap k: "
	Message3: 	.asciiz "Phan tu can xoa khong ton tai!\n"
	Message4: 	.asciiz "Mang sau khi xoa phan tu thu k la:\n"
	Space: 		.asciiz " "
	Eror: 		.asciiz "So phan tu mang phai lon hon bang 1!\n"
	
.text
main:
	li 	$v0, 4
	la 	$a0, Message
	syscall
	
	# Nhap so phan tu N:
	li 	$v0, 5
	syscall
	
	move 	$s0, $v0		# $s0 = N
	blt 	$s0, 1, PrintEror	# N < 1 => Error
	la 	$a1, A			# $a1 = address of A[0]
	j 	input_array
	
exit:
	li 	$v0, 10
	syscall
	
input_array:
	beq 	$t2, $s0, input_k	# $t2 = N => Nhap k
	add 	$t0, $a1, $t1
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
	
input_k:
	li 	$v0, 4
	la 	$a0, Message2
	syscall
	
	li 	$v0, 5
	syscall
	
	move 	$s1, $v0	# $s1 = k 
	
	# k < 1 hoac k > N => khong the xoa vi phan tu khong ton tai
	blt 	$s1, 1, PrintEror1
	bgt 	$s1, $s0, PrintEror1
	
Check:
	addi 	$s1, $s1, -1	# $s1 = index can xoa = k - 1
	addi 	$t0, $s1, 0	# $t0 = $s1 = k - 1
	mul 	$s1, $s1, 4	
	add 	$t1, $a1, $s1	# $t1 = address of A[0] + 4 * (k - 1) 
				#     = dia chi cua phan tu can xoa
	addi 	$s0, $s0, -1	# $s0 = N - 1
	
loop:
	beq 	$t0, $s0, PrintResult	# $t0 = N => Print
	lw 	$t2, 4($t1)		# $t2 = A[k] = phan tu sau A[k - 1]
	sw 	$t2, 0($t1)		# Cho lai A[k - 1] = A[k]
	addi 	$t0, $t0, 1		# $t0++
	addi 	$t1 $t1, 4
	j 	loop

PrintResult:
	# In ket qua
	li 	$t0, 0
	li 	$v0, 4
	la 	$a0, Message4
	syscall

Print:
	beq 	$t0, $s0, exit
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
	
PrintEror1:
	li 	$v0, 4
	la 	$a0, Message3
	syscall
	j 	input_k