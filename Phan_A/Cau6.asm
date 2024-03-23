.data
	Message: .asciiz "Nhap vao 1 so nguyen duong N: "
	Message1: .asciiz "Tong cac chu so trong bieu dien nhi phan cua N la: "
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
	j sum
	
exit:
	li $v0, 10
	syscall
	
sum:
	andi $t0, $s0, 1
	add $s1, $s1, $t0
	srl $s0, $s0, 1
	beqz $s0, printSum
	j sum
	
printSum:
	li $v0, 4
	la $a0, Message1
	syscall
	li $v0, 1
	add $a0, $s1, 0
	syscall
	j exit
	
PrintEror:
	li $v0, 4
	la $a0, Eror
	syscall
	j main