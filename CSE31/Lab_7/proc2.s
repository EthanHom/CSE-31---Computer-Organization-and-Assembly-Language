	.data
x:		.word 5
y:		.word 10
m:		.word 15
b:		.word 2

		.text
MAIN:	la $t0, x
		lw $s0, 0($t0)		# s0 = x
		la $t0, y
		lw $s1, 0($t0)		# s1 = y
		
		# Prepare to call sum(x)
		add $a0, $zero, $s0	# Set a0 as input argument for SUM
		jal SUM
		add $t0, $s1, $s0
		add $s1, $t0, $v0
		addi $a0, $s1, 0 
		li $v0, 1		 
		syscall	
		j END

		
SUM: 	addi $sp, $sp, -12	# Create space on stack for 3 registers
		sw $ra, 0($sp)		# Backup $ra
		sw $s0, 4($sp)		# Backup $s0
		sw $a0, 8($sp)		# Backup $a0
		la $t0, m
		lw $s0, 0($t0)		# s0 = m
		add $a0, $s0, $a0	# Update $a0 as new argument for SUB
		jal SUB
		add $v0, $a0, $v0
		lw $ra, 0($sp)		# Restore $ra
		lw $s0, 4($sp)		# Restore $s0
		lw $a0, 8($sp)		# Restore $a0
		addi $sp, $sp, 12	# Remove space on stack
		jr $ra		
		
SUB:	addi $sp, $sp, -4	# Create space on stack for 1 register
		sw $s0, 0($sp)		# Backup $s0 from SUM
		la $t0, b
		lw $s0, 0($t0)		# s0 = b
		sub $v0, $a0, $s0
		lw $s0, 0($sp)		# Restore $s0 from SUM
		addi $sp, $sp, 4	# Remove space on stack
		jr $ra

		
END:


