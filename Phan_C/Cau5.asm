.data
	String: 	.space 256
	Message: 	.asciiz "Nhap vao xau ky tu: "
	Message1: 	.asciiz "Ky tu chu hoa xuat hien nhieu nhat trong xau la: "
	Message2: 	.asciiz "Vi tri cac ky tu la: "
	Space: 		.asciiz " "
	NewLine: 	.asciiz "\n"
	
.text
main:
	# Nhap sau:
	li 	$v0, 4
	la 	$a0, Message
	syscall
	
	li 	$v0, 8
	la 	$a0, String
	li 	$a1, 256
	syscall
	
	la 	$a1, String
	li 	$a2, 1
	addi	$fp, $sp, 0
	j 	PushStack
	
exit:
	li 	$v0, 10
	syscall
	
PushStack:
	lb 	$t0, 0($a1)
	beqz 	$t0, FindMaxFreq 
	blt 	$t0, 65, continue
	bgt 	$t0, 97, continue
	jal 	Check
	sb 	$t0, 0($sp)
	sw 	$a2, 4($sp)
	addi 	$a3, $a3, 1
	addi 	$sp, $sp, 8
	
continue:
	addi 	$a1, $a1, 1
	j 	PushStack
Check:
	li 	$t1, 0
	mul 	$t2, $a3, 8
	sub 	$t3, $sp, $t2
	
loop:
	beq 	$t1, $a3, Return
	lb 	$s2, 0($t3)
	beq 	$s2, $t0, Update
	addi 	$t1, $t1, 1
	addi 	$t3, $t3, 8
	j 	loop
	
Update:
	lw 	$s3, 4($t3)
	addi 	$s3, $s3, 1
	sw 	$s3, 4($t3)
	j 	continue
	
Return:
	jr 	$ra
	
FindMaxFreq:
	addi	$sp, $fp, 0
	li 	$t0, 0
	li 	$t1, 0
	
MaxFreq:
	beq 	$t0, $a3, PrintResult
	lb 	$t2, 0($sp)
	lw 	$t3, 4($sp)
	bgt 	$t3, $t1, UpdateMaxFreq
	
ContinueFind:
	addi 	$sp, $sp, 8
	addi 	$t0, $t0, 1
	j 	MaxFreq
	
UpdateMaxFreq:
	addi 	$s1, $t2, 0
	addi 	$t1, $t3, 0
	j 	ContinueFind
	
PrintResult:
	li 	$v0, 4
	la 	$a0, Message1
	syscall
	
	li 	$v0, 11
	addi 	$a0, $s1, 0
	syscall
	
	li 	$v0, 4
	la 	$a0, NewLine
	syscall
	
FindLocation:
	la 	$a1, String
	li 	$t0, 0
	li 	$v0, 4
	la 	$a0, Message2
	syscall
	
PrintLocation:
	lb 	$v1, 0($a1)
	beqz 	$v1, exit
	addi 	$a1, $a1, 1
	addi 	$t0, $t0, 1
	bne 	$v1, $s1, PrintLocation
	li 	$v0, 1
	addi 	$a0, $t0, 0
	syscall
	
	li 	$v0, 4
	la 	$a0, Space
	syscall
	j 	PrintLocation
