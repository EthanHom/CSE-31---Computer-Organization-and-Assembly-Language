.data 
n:	.word 25
str1: .asciiz "Less than\n"
str2: .asciiz "Less than or equal to\n"
str3: .asciiz "Greater than\n"
str4: .asciiz "Greater than or equal to\n"
str5: .asciiz "Enter a number: "

.text
main: 
	la $a0, str5
	li $v0, 4
	syscall

	la $s0, n
	lw $t1, 0($s0)

	li $v0, 5
	syscall
	move $t0, $v0
	#blt $t0,$t1,less_than
	#bge $t0,$t1,greater_than_or_equal
	bgt $t0,$t1,greater_than
	ble $t0,$t1,less_than_or_equal
	
	j end

less_than:
	la $a0, str1
	li $v0, 4
	syscall
	j end

greater_than_or_equal: 
	la $a0, str4 
	li $v0, 4 
	syscall
	j end

less_than_or_equal:
	la $a0, str2
	li $v0, 4
	syscall
	j end

greater_than: 
	la $a0, str3
	li $v0, 4
	syscall
	j end

end: 
	li $v0, 10
	syscall