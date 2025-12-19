.data
str1: .asciiz "p + q: "
.text
.globl main

main:
    # initialize x, y, z
    li $s0, 1    # x = 1
    li $s1, 2    # y = 2
    li $s2, 3    # z = 3
    
    # call foo(x, y, z) and add result to z
    addi $a0, $s0, 0   # m = x
    addi $a1, $s1, 0   # n = y
    addi $a2, $s2, 0   # o = z
    jal foo
    add $s2, $s2, $v0  # z = x + y + z + foo(x, y, z)

    # print z
    li $v0, 1
    move $a0, $s2
    syscall

    # exit program
    li $v0, 10
    syscall

foo:
    # save $ra on stack
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # call bar(m+o, n+o, m+n) and store result in $s0
    add $t0, $a0, $a2  # a = m + o
    add $t1, $a1, $a2  # b = n + o
    add $a2, $t0, $t1  # c = m + n
    jal bar
    move $s0, $v0      # p = bar(m+o, n+o, m+n)

    # call bar(m-o, n-m, n+n) and store result in $s1
    sub $t0, $a0, $a2  # a = m - o
    sub $t1, $a1, $t0  # b = n - m
    add $a2, $t1, $t1  # c = n + n
    jal bar
    move $s1, $v0      # q = bar(m-o, n-m, n+n)

    # print p + q
    add $a0, $s0, $s1  # argument to printf: p + q
    li $v0, 1
    syscall

    # exit function
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    add $v0, $s0, $s1
    jr $ra

# float bar(int x, float y)
# returns y*(2^x)
bar:
    # cast y to an integer
    cvt.w.s $f0, $f12
    mtc1 $a0, $f1  # move x to f1
    mtc1 $a1, $f12 # move y to f12
    # calculate 2^x and store in f2
    li $v0, 1
    mov.s $f2, $f0
    loop:
        beqz $v0, end_loop
        mul.s $f2, $f2, $f0
        addi $v0, $v0, -1
        j loop
    end_loop:
    # multiply y by 2^x
    mul.s $f12, $f12, $f2
    # convert result back to integer
    cvt.s.w $f12, $f12
    # move result to v0
    mfc1 $v0, $f12
    jr $ra
