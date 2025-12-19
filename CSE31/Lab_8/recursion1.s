.data
x: .word 0
result: .asciiz "%d\n"

.text
.globl main
main:
    # Allocate memory for input variable
    li $v0, 9
    li $a0, 4
    syscall
    sw $v0, x

    # Print message to prompt user for input
    la $a0, result
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
    li $v0, 1
    move $a0, $t1
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
    sw $t1, 0($sp)
    move $s0, $a0

    # Base case 1: m = -1
    li $t0, -1
    beq $s0, $t0, base_case1
    nop

    # Base case 2: m <= -2
    li $t0, -2
    ble $s0, $t0, base_case2
    nop

    # Recursive case
    addi $s0, $s0, -3
    move $a0, $s0
    jal recursion
    sw $v0, 0($sp)
    addi $s0, $s0, 1
    move $a0, $s0
    jal recursion
    lw $t1, 0($sp)
    add $v0, $t1, $v0
    add $v0, $v0, $s0

    # Function epilogue
    lw $ra, 8($sp)
    lw $s0, 4($sp)
    lw $t1, 0($sp)
    addi $sp, $sp, 12
    jr $ra

base_case1: 
    # Base case 1: m = -1
    li $v0, 1
    jr $ra

base_case2: 
    # Base case 2: m <= -2
    li $t0, -2
    blt $s0, $t0, base_case3
    nop

    # m < -2
    li $v0, 2
    jr $ra

base_case3:
    # m = -2
    li $v0, 3
    jr $ra
