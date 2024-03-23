.data 
	A: .word 0:100
	Message: .asciiz "Nhap so phan tu mang: "
	Message1: .asciiz "Nhap so: "
	Message2: .asciiz "Day so am giam ma khong lam thay doi thu tu so duong la:\n"
	Eror: .asciiz "So phan tu mang phai lon hon bang 2!\n"
	Space: .asciiz " "
.text
main:
	li $v0, 4
	la $a0, Message
	syscall				#in ra thong bao nhap so phan tu day
	li $v0, 5
	syscall				# input number
	move $s0, $v0			# truyen gia tri vua nhap vao N
	blt $s0, 2, PrintEror		#in ra thong bao loi neu so phan tu khong dung
	la $a1, A			# load adress of A to a1
	j input_array
exit:
	li $v0, 10
	syscall				#exit
input_array:
	beq $t2, $s0, CheckArray	# if i = N
	add $t0, $a1, $t1		# t0 = adrress of A + $t1 (A[i])
	li $v0, 4
	la $a0, Message1
	syscall				#nhap vao chuoi
	li $v0, 5
	syscall				#input number
	move $s1, $v0     
	sw $s1, 0($t0)			# $s1 = A[i]
	addi $t2, $t2, 1               # i++
	mul $t1, $t2, 4			# adress of A + 4 (A[i++])
	j input_array
CheckArray:
	addi $v0, $s0, -1		# N-1
	li $t0, 0			# i = 0
	addi $t1, $a1, 0		# $t1 = address of A
loop:
	beq $t0, $v0, PrintResult	# if i = N-1 in ket qua
	lw $v1, 0($t1)			# lay gia tri o dia chi $t1 luu vao $v1(A[i])
	bltz $v1, FindMax    		# if $v1 < 0 FindMax
Continue:
	addi $t0, $t0, 1		# i++
	addi $t1, $t1, 4		# address of A + 4
	j loop				# return loop1
FindMax:
	addi $t5, $v1, 0		# Max tam thoi
	addi $t2, $t1, 4		# adress of A[i] + 4
	addi $t3, $t0, 1		# j = i + 1
Max:
	beq $t3, $s0, Update		# if j = N tiep tuc vong loop1
	lw $s1, 0($t2)			# luu gia tri tu dia tri $t2 vao $s1
	bgez $s1, Skip			# if $s1 >= 0 Skip
	blt $s1, $t5, Skip		# if $s1 < $v1 Skip
	addi $t5, $s1, 0		# Max = Max moi
	addi $t4, $t2, 0		# vi tri Maxx
Skip:
	addi $t3, $t3, 1		# j++
	addi $t2, $t2, 4		# Address of A[j] + 4
	j Max				# return loop 2
Update:
	beq $t5, $v1, Continue		# neu max khoi doi continue
	sw $t5, 0($t1)			# truyen gia tri max vao A[i]
	sw $v1, 0($t4)			# truyen gia tri o A[i] vao vi tri Max
	j Continue
PrintResult:
	li $v0, 4
	la $a0, Message2
	syscall
	li $t0, 0			# i = 0
Print:
	beq $t0, $s0, exit		# if i = N exit
	li $v0, 1
	lw $a0, 0($a1)
	syscall				# in ra A[i]
	li $v0, 4
	la $a0, Space
	syscall				# in dau cach
	addi $a1, $a1, 4
	addi $t0, $t0, 1		# i++
	j Print
PrintEror:
	li $v0, 4
	la $a0, Eror
	syscall
	j main
