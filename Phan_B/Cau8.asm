.data
	me1: .asciiz "Nhap n: "
	me2: .asciiz "Khong phu hop! "
	me3: .asciiz "Nhap cac phan tu: "
	me4: .asciiz "Tong cac phan tu chan trong mang: "
	me5: .asciiz "Tong cac phan tu le trong mang: "
	nl: .asciiz "\n"
	A: .word 0:100
.text
n_lp:
	li $v0, 4
	la $a0, me1
	syscall

	li $v0, 5
	syscall
	move $t0, $v0

	slti $t1, $t0, 1 #Kiem tra loi, neu n < 1 thi bi loi
	bne $t1, $zero, invalid

	li $t1, 0
	la $t2, A

	la $a0, me3
	li $v0, 4
	syscall

	li $v0, 4
	la $a0, nl
	syscall
	j input

	invalid: #In loi va yeu cau nhap lai
	la $a0, me2
	li $v0, 4
	syscall

	la $a0, nl
	li $v0, 4
	syscall
	j n_lp
	
input: #Nhap mang
	beq $t1,$t0,inputted

	li $v0, 5
	syscall

	sw $v0, 0($t2)
	addi $t1, $t1, 1
	addi $t2, $t2, 4
	j input

inputted:
	la $t2, A
	li $t1, 0 #$t1 la index
	li $t7, 2
	li $t8, 0 #$t8 la tong gia tri chan
	li $t9, 0 #$t9 la tng gia tri le

loop:
	beq $t1, $t0, done
	lw $s2, 0($t2)
	div $s2, $t7 #Chia $s2 cho 2, phan nguyen nam o thanh $lo, phan du nam o thanh $hi
	mfhi $s4 #Luu so du vao thanh $s4
	beq $s4, $zero, chan
	add $t9, $t9, $s2
	j tiep
 chan:
	add $t8, $t8, $s2
	j tiep
	tiep:
	addi $t1, $t1, 1
	addi $t2, $t2, 4
	j loop

done:
	li $v0, 4
	la $a0, nl
	syscall

	li $v0, 4
	la $a0, me4
	syscall

	li $v0, 1
	move $a0, $t8
	syscall

	li $v0, 4
	la $a0, nl
	syscall

	li $v0, 4
	la $a0, me5
	syscall

	li $v0, 1
	move $a0, $t9
	syscall

	li $v0, 10
	syscall