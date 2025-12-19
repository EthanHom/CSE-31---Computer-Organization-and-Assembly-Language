.data
prompt: .asciiz "Please enter an integer: "
return1: .asciiz "Returning 1\n"
return3: .asciiz "Returning 3\n"
result: .asciiz "%d\n"

.text
.globl main
main:
    # Allocate memory for input variable
    li $v0, 9
    li $a0, 4
    syscall
    addi $sp, $sp, -4    # allocate 4 bytes on the stack
    sw $zero, ($sp)      # store 0 in the allocated memory
    move $s0, $sp        # save the address in $s0
    sw $v0, 0($s0)

    # Print message to prompt user for input
    la $a0, prompt
    li $v0, 4
    syscall

    # Read input integer from user
    li $v0, 5
    syscall
    move $t0, $v0

    # Call recursion function
    move $a0, $t0
    jal recursion
    move $t1, $v0

    # Print result
    li $v0, 4
    la $a0, result
    syscall
    move $a0, $t1
    li $v0, 1
    syscall

    # Exit program
    li $v0, 10
    syscall


# Recursive function to calculate value of mth Fibonacci number
# Expects the value of m in $a0 and returns the result in $v0
recursion:
    # Function prologue
    addi $sp, $sp, -12
    sw $ra, 8($sp)
    sw $s0, 4($sp)
    sw $s1, 0($sp)
    move $s0, $a0

    # Base case 1: m = -1
    li $t0, -1
    beq $s0, $t0, base_case1
    nop

    # Base case 2: m = 0
    li $t0, 0
    beq $s0, $t0, base_case2
    nop

    # Recursive case
    addi $s0, $s0, -2
    move $a0, $s0
    jal recursion
    addi $s0, $s0, 1
    move $a0, $s0
    jal recursion
    add $v0, $v0, $v1

    # Function epilogue
    lw $ra, 8($sp)
    lw $s0, 4($sp)
    lw $s1, 0($sp)
    addi $sp, $sp, 12
    jr $ra

base_case1: 
    # Base case 1: m = -1
    li $v0, 1
    la $a0, return1
    li $v0, 4
    syscall
    jr $ra

base_case2: 
    # Base case 2: m = 0
    li $v0, 3
    la $a0, return3
    li $v0, 4
    syscall
    jr $ra
