.data
	A: 		.space 100
	Message: 	.asciiz "Nhap so phan tu mang: "
	Message1: 	.asciiz "Nhap so: "
	Message2: 	.asciiz "So chan lon nhat nho hon moi so le trong mang la: "
	Eror: 		.asciiz "So phan tu mang phai lon hon bang 1!\n"
	
.text
main:
	li 	$v0, 4
	la 	$a0, Message
	syscall
	
	# Nhap so phan tu N:
	li 	$v0, 5
	syscall
	
	move 	$s0, $v0	# luu N vao $s0
	blt 	$s0, 1, PrintEror
	la 	$a1, A		# $a1 = address of A[0]
	j 	input_array
	
exit:
	li 	$v0, 10
	syscall
	
input_array:
	# Nhap cac phan tu cua mang:
	beq 	$t2, $s0, init
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

init:
	addi 	$a2, $a1, 0	# $a2 = $a1 = address of A[0]
	li	$s2, 0		# $s2 = i = 0
	li	$t9, 2		# $t9 = 2
	li	$s7, 999999	# $s7 = minOdd = gia tri le be nhat la 999999
	
CheckOdd:	
	beq	$s2, $s0, init2		# i = N => CheckMaxEven branch
	lw	$t8, 0($a2)		# $t8 = A[i]
	div	$t8, $t9		# A[i] % 2
	mfhi	$t7			# Lay mode cua phep chia tren
	beq	$t7, 1, CheckMinOdd	# Neu A[i] la so le thi xem so do la be nhat chua 
	addi	$a2, $a2, 4		# address of next index
	addi	$s2, $s2, 1		# i++
	j	CheckOdd
	
CheckMinOdd:
	slt	$t6, $t8, $s7		# Neu A[i] < minOdd => $t6 = 1
	beq	$t6, 1, UpdateMinOdd	# Neu thoa man thi gan gia tri minOdd = A[i]

UpdateMinOdd:
	addi	$s7, $t8, 0		# minOdd = A[i]
	addi	$a2, $a2, 4		# address of next index
	addi	$s2, $s2, 1		# i++
	j	CheckOdd
	
# -----------------------------------------------------------------------------
# Sau khi tim duoc so le nho nhat, ta di tim so chan lon nhat nho hon so le do!
init2:
	addi 	$a2, $a1, 0	# $a2 = $a1 = address of A[0]
	li	$s2, 0		# $s2 = i = 0
	li	$t9, 2		# $t9 = 2
	li	$s6, 0		# $s6 = maxEven = gia tri chan lonw nhat la 0

CheckEven:	
	beq	$s2, $s0, Print 	# i = N => CheckMaxEven branch
	lw	$t8, 0($a2)		# $t8 = A[i]
	div	$t8, $t9		# A[i] % 2
	mfhi	$t7			# Lay mode cua phep chia tren
	beq	$t7, 0, CheckMaxEven	# Neu A[i] la so chan thi xem so do la lon nhat chua 
	addi	$a2, $a2, 4		# address of next index
	addi	$s2, $s2, 1		# i++
	j	CheckEven

CheckMaxEven:
	sgt	$t6, $t8, $s6		# Neu A[i] > maxEven => $t6 = 1
	slt	$t5, $t8, $s7		# Neu A[i] < minOdd => $t5 = 1
	add	$t4, $t5, $t6		
	beq	$t4, 2, UpdateMaxEven	# Neu thoa man hai dieu kien tren thi gan maxEven = A[i]

UpdateMaxEven:
	addi	$s6, $t8, 0		# maxEven = A[i]
	addi	$a2, $a2, 4		# address of next index
	addi	$s2, $s2, 1		# i++
	j	CheckEven

Print:
	# In ra ket qua
	li	$v0, 4
	la	$a0, Message2
	syscall
	
	li	$v0, 1
	move	$a0, $s6
	syscall
	j 	exit
		
PrintEror:
	li 	$v0, 4
	la 	$a0, Eror
	syscall
	j 	main