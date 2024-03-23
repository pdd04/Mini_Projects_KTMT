.data
	Message: .asciiz "Nhap vao 1 so nguyen duong N: "
	Message1: .asciiz "N la so chinh phuong\n"
	Message2: .asciiz "N khong la so chinh phuong\n"
	Message3: .asciiz "Cac so chinh phuong nho hon N la:\n"
	Message4: .asciiz "Khong co so chinh phuong nho hon N"
	Space: .asciiz " "
	Eror: .asciiz "So nhap vao phai lon hon 0!\n"
.text
main:
	li $v0, 4
	la $a0, Message
	syscall
	li $v0, 5
	syscall
	move $s0, $v0
	bltz $s0, PrintEror
	beqz $s0, Print_perfect_square
	li $t0, 0
	j check
	
exit:
	li $v0, 10
	syscall
	
check:
	addi $t0, $t0, 1
	div $s0, $t0
	mfhi $t1
	beqz $t1, check_perfect_square
	j check
	
check_perfect_square:
	mflo $t2
	beq $t2, $t0, Print_perfect_square
	blt $t2, $t0, Print_not_perfect
	j check
	
Print_perfect_square:
	li $v0, 4
	la $a0, Message1
	syscall
	j Number_perfect_square
	
Print_not_perfect:
	li $v0, 4
	la $a0, Message2
	syscall
	j Number_perfect_square
	
PrintEror:
	li $v0, 4
	la $a0, Eror
	syscall
	j main
	
Number_perfect_square:
	beqz $s0, Print_no_number
	li $v0, 4
	la $a0, Message3
	syscall
	li $v0, 1
	li $a0, 0
	syscall
	li $v0, 4
	la $a0, Space
	syscall
	li $s1, 1
	li $t0, 1
	
loop:
	beq $s1, $s0, exit
	div $s1, $t0
	mfhi $t1
	beqz $t1, check_number
	addi $s1, $s1, 1
	j loop
	
check_number:
	mflo $t2
	beq $t2, $t0, Print_Number
	blt $t2, $t0, reset
	addi $t0, $t0, 1
	j loop
	
reset:
	addi $t0, $zero, 0
	addi $s1, $s1, 1
	j loop
	
Print_Number:
	li $v0, 1
	addi $a0, $s1, 0
	syscall
	li $v0, 4
	la $a0, Space
	syscall
	j reset
	
Print_no_number:
	li $v0, 4
	la $a0, Message4
	syscall
	j exit
	