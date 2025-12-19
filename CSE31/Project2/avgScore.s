.data 

orig: .space 100	# In terms of bytes (25 elements * 4 bytes each)
sorted: .space 100
holder: .space 100
sortedh: .space 100

str0: .asciiz "Enter the number of assignments (between 1 and 25): "
str1: .asciiz "Enter score: "
str2: .asciiz "Original scores: "
str3: .asciiz "Sorted scores (in descending order): "
str4: .asciiz "Enter the number of (lowest) scores to drop: "
str5: .asciiz "Average (rounded down) with dropped scores removed: "

space: .asciiz " "
line: .asciiz "\n"


.text 

# This is the main program.
# It first asks user to enter the number of assignments.
# It then asks user to input the scores, one at a time.
# It then calls selSort to perform selection sort.
# It then calls printArray twice to print out contents of the original and sorted scores.
# It then asks user to enter the number of (lowest) scores to drop.
# It then calls calcSum on the sorted array with the adjusted length (to account for dropped scores).
# It then prints out average score with the specified number of (lowest) scores dropped from the calculation.
main: 
	addi $sp, $sp -4
	sw $ra, 0($sp)
	li $v0, 4 
	la $a0, str0 
	syscall 
	li $v0, 5	# Read the number of scores from user
	syscall
	move $s0, $v0	# $s0 = numScores
	move $t0, $0
	la $s1, orig	# $s1 = orig
	la $s2, sorted	# $s2 = sorted
	
loop_in:
	li $v0, 4 
	la $a0, str1 
	syscall 
	sll $t1, $t0, 2
	add $t1, $t1, $s1
	li $v0, 5	# Read elements from user
	syscall
	sw $v0, 0($t1)
	addi $t0, $t0, 1
	bne $t0, $s0, loop_in
	
	move $a0, $s0
	jal selSort	# Call selSort to perform selection sort in original array

	li $t4, 0
	li $t3, 0
	
	move $a0, $s1	# More efficient than la $a0, orig
	move $a1, $s0
	li $t8, 0
	li $t7, 0
	li $v0, 4 
	la $a0, str2 
	syscall 
	move $a0, $s2	# More efficient than la $a0, sorted
	jal printArray	# Print sorted scores

	jal calcSum
	li $v0, 4 
	la $a0, str4 
	syscall 
	li $v0, 5	# Read the number of (lowest) scores to drop
	syscall
	move $a1, $v0
	sub $a1, $s0, $a1	# numScores - drop
	move $a0, $s2
	jal calcSum2
	
	# Your code here to compute average and print it
	
	lw $ra, 0($sp)
	addi $sp, $sp 4
	li $v0, 10 
	syscall
	
	
# printList takes in an array and its size as arguments. 
# It prints all the elements in one line with a newline at the end.
printArray:
	# Your implementation of printList here	
	beq $t7, $s0, exit_loop
	lw $t6, holder($t8)
	li $v0, 1
	move $a0, $t6
	syscall 
	li $v0, 4
	la $a0, space
	syscall 
	addi $t7, $t7, 1
	addi $t8, $t8, 4
	j printArray
	exit_loop: 
		jr $ra
		li $t8, 0
		li $t7, 0
	

# selSort takes in the number of scores as argument. 
# It performs SELECTION sort in descending order and populates the sorted array
selSort:
	li $t3, 0
    	li $t0, 0
    	li $t1, 0
    	li $t2, 0
    	li $t7, 0
    	li $t8, 0
	la $s1, orig
	addi $t7, $zero, 4
	mult $s0, $t7
	mflo $t8
	addi $t8, $t8, 4
	add $s3, $s1, $t8
	la $s2, sorted
	la $s5, holder
    	li $t5, 0
    	li $v0, 4
   	la $a0, str3
   	syscall
copy_loop:
	beq $s1, $s3, reset
	lw $t0, 0($s1) 
 	addi $s1, $s1,4
 	sw $t0, 0($s5)
 	addi $s5, $s5, 4
	j copy_loop
reset:
	la $s1, orig
	la $s2, sorted
	la $s5, holder
	j main_loop	
main_loop:
    	beq $s1, $s3, resetstack
    	lw $t0, 0($s1) 
    	addi $s1, $s1, 4
    	slt $t2, $s4, $t0
    	bne $t2, $zero, main_loop
    	move $s4, $t0
    	j main_loop
resetstack:
	la $s1, orig
	lw $t0, 0($s1)
	j findmin
	
findmin:
    	beq $t0, $s4, loopfinish
    	lw $t0, 0($s1)
    	addi $s1, $s1, 4
    	addi $t5, $t5, 4
 	j findmin
 	
loopfinish: 
   	la $s1,orig
   	addi $t3, $t3, 4 
   	li $t0, 0
   	li $t1, 0
   	li $t2, 0
   	add $t0, $t0, $s4
   	add $s1, $s1, $t3
   	lw $t2, -4($s1)
   	bne $t5, $zero, subtract
   	j norm	
   
	subtract:
		addi $t5, $t5, -4
   		j contd
	norm:
   		add $t5, $t5, $t3
   		j contd
	contd:
       		beq $t0, $t2, skip
   		lw $t6, orig($t5)
		sw $t2,orig($t5)
		sw $t6, -4($s1)
		j skip
	skip:
   		li $t5, 0
   	 	sw $s4, 0($s2)
		addi    $s2, $s2, 4
		bne $s4, $zero, go
		j aftergo
	go:	
	aftergo:   	 
		lw      $s4,0($s1)
   		bleu    $t3,  $t8, main_loop
  	 	la      $s1,orig 
  	 	sw      $s4, sorted($t3)
  	 	j done
  	 		
done:
   	j desc 
   	
desc:
	li $a0, 0
	li $s3, 0
	li $t0, 0
	li $t1, 0 
	li $t2, 0
	li $t5, 0

	addi $t3, $t3, -8
	
	add $t2, $t2, $s0
	la $s3, sortedh
	j descloop
descloop:
	beq $t2, $t0, descdone
	lw $t1, sorted($t3)
	beq $t1, $zero, skipdesc
	li $v0, 1
	move $a0, $t1
	syscall
	li $v0, 4
	la $a0, space
	syscall
	addi $t2, $t2, -1
	j skipdesc
skipdesc:	 
	addi $t3, $t3, -4	 
	j descloop
descdone:
   	li $v0,4
   	la $a0, line
   	syscall
	jr $ra
	
	
# calcSum takes in an array and its size as arguments.
# It RECURSIVELY computes and returns the sum of elements in the array.
# Note: you MUST NOT use iterative approach in this function.
calcSum:
	li $a0, 0
	li $s3, 0
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0 
	la $s5, holder
	j recurs
	
recurs:
    	blt $t1,$s0,recurs_call
    	j recurs_done        

recurs_call:
    	addi $t1,$t1,1
    	lw $t3, 0($s5)
    	add $s3, $s3, $t3  
    	addi $s5, $s5, 4 
    	j recurs

recurs_done:
    	li $v0, 4
   	la $a0,line
   	syscall
    	jr $ra
    
#
calcSum2:
	li $a0, 0
	li $t7, 0
	li $s3, 0
	li $t0, 0
	li $t1, 0 
	li $t2, 0
	li $t3, 0 
	la $s2, sorted

    	sub $t2, $s0, $a1
    	addi $a1, $a1, 1
    	lw $t4, 0($s2)
    	beq $t4, $zero, addto
    	j routinestart
addto:
	addi $s2, $s2, 4
	j routinestart
	
routinestart: 
	beq $t0, $t2, routinedone
	addi $t0, $t0, 1
	lw $t3, 0($s2)

	addi $s2, $s2, 4
	j routinestart
	
routinedone:
	j recurs2
	
recurs2:
    	blt $t1,$a1,recurs_call2
    	j recurs_done2       

recurs_call2:
    	addi $t1,$t1,1
    	lw $t3, 0($s2)
    	add $s3, $s3, $t3
    	addi $s2, $s2, 4
    	j recurs2

recurs_done2:
   	addi $a1, $a1, -1
   	div $s3, $a1
   	mflo $t7
   
    	li $v0, 4
    	la $a0, str5
    	syscall
    
    	li $v0, 1
    	move $a0, $t7
    	syscall
    	jr $ra
