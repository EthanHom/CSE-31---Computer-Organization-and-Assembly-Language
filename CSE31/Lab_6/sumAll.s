.data
str: .asciiz "Please enter a number: "
evenStr: .asciiz "Sum of even numbers is: "
oddStr: .asciiz "\nSum of odd numbers is: "

.text 
main: 
	# print str
	li $v0, 4
	la $a0, str
	syscall
	
	# even
	#li $t1, 0
	addi $t1, $zero, 0
	
	#odd
	#li $t2, 0
	addi $t2, $zero, 0
	
	#user input 
	li $v0, 5
	syscall
	
	While:		
		beqz $v0, After
		
		addi $t3, $zero, 2
		div $v0, $t3
		mfhi $t3
		beq $t3, $zero, Else
		add $t2, $t2, $v0
		j After1
		Else: 
			add $t1, $t1, $v0
		After1:	
			li $v0, 4
			la $a0, str
			syscall
		
			li $v0, 5
			syscall
				
			j While
	After: 		
		li $v0, 4
		la $a0, evenStr
		syscall	
		
		li $v0, 1
		move $a0, $t1
		syscall
		
		li $v0, 4
		la $a0, oddStr
		syscall
		
		li $v0, 1
		move $a0, $t2
		syscall