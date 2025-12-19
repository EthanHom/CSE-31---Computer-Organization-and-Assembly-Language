.data 

orig: .space 100	# In terms of bytes (25 elements * 4 bytes each)
sorted: .space 100

str0: .asciiz "Enter the number of assignments (between 1 and 25): "
str1: .asciiz "Enter score: "
str2: .asciiz "Original scores: "
str3: .asciiz "Sorted scores (in descending order): "
str4: .asciiz "Enter the number of (lowest) scores to drop: "
str5: .asciiz "Average (rounded down) with dropped scores removed: "

space: .asciiz " "
newline: .asciiz "\n"


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
	
	li $v0, 4 
	la $a0, str2 
	syscall
	move $a0, $s1	# More efficient than la $a0, orig
	move $a1, $s0
	jal printArray	# Print original scores
	li $v0, 4 
	la $a0, str3 
	syscall 
	move $a0, $s2	# More efficient than la $a0, sorted
	jal printArray	# Print sorted scores
	
	li $v0, 4 
	la $a0, str4 
	syscall 
	li $v0, 5	# Read the number of (lowest) scores to drop
	syscall
	move $a1, $v0
	sub $a1, $s0, $a1	# numScores - drop
	move $a0, $s2
	jal calcSum	# Call calcSum to RECURSIVELY compute the sum of scores that are not dropped
	
	# Your code here to compute average and print it
		
	move $s0, $a1 # adjust length of array to account for dropped scores
	li $v0, 0 # initialize the sum of the scores
	li $t0, 0 # initialize the number of scores
	la $t1, sorted
	#add $t2, $t1, ($s0 << 2) # $t2 = address of the last score to be included in the calculation
	#
	sll $t3, $s0, 2     # Shift the value in $s0 left by 2 to multiply by 4 (the word size)
	add $t3, $t3, $t1   # Add the result to $t1
	lw $t2, ($t3)       # Load the word from the address in $t3 into $t2
	#
	addi $t2, $t2, -4 # correct for the 0-based indexing of the array
	loop_calcsum:
    		lw $t3, ($t1)
    		add $v0, $v0, $t3
    		addi $t0, $t0, 1
    		addi $t1, $t1, 4
    		blt $t1, $t2, loop_calcsum
    	
    	# Compute the average score rounded down
	div $t0, $t0, $a1
	mflo $t0

	# Print the average score
	li $v0, 4
	la $a0, str5
	syscall
	move $a0, $t0
	li $v0, 1
	syscall
	
	lw $ra, 0($sp)
	addi $sp, $sp 4
	li $v0, 10 
	syscall

	
	
# printList takes in an array and its size as arguments. 
# It prints all the elements in one line with a newline at the end.
printArray:
	# Your implementation of printList here	
   	
	addi $sp, $sp, -4       # allocate space for return address
    	sw   $ra, 0($sp)        # save return address on the stack
    	addi $sp, $sp, -8       # allocate space for $s0 and $s1
    	sw   $s0, 4($sp)        # save $s0 on the stack
    	sw   $s1, 0($sp)        # save $s1 on the stack

    	# function body
    	move $s0, $a0           # copy the address of arr to $s0
    	move $s1, $a1           # copy len to $s1
loop:
    	beq  $s1, $zero, exit2   # if len == 0, exit the loop
    	lw   $a0, ($s0)         # load arr[i] into $a0
    	li   $v0, 1             # set $v0 to 1 (print integer syscall)
    	syscall                # print arr[i]
    	la   $a0, space         # load the address of the space character
    	li   $v0, 4             # set $v0 to 4 (print string syscall)
    	syscall                # print a space character
    	addi $s0, $s0, 4        # move to the next element of arr
    	addi $s1, $s1, -1       # decrement len
    	j    loop               # repeat the loop

exit2:
    	la   $a0, newline       # load the address of the newline character
    	li   $v0, 4             # set $v0 to 4 (print string syscall)
    	syscall                # print a newline character

    	# function epilogue
    	lw   $s0, 4($sp)        # restore $s0 from the stack
    	lw   $s1, 0($sp)        # restore $s1 from the stack
    	lw   $ra, 8($sp)        # restore return address from the stack
    	addi $sp, $sp, 12       # deallocate space for $s0, $s1, and return address
    	jr   $ra                # return to the caller
	
	
# selSort takes in the number of scores as argument. 
# It performs SELECTION sort in descending order and populates the sorted array
selSort:
	
	
penis:
  	lw $t1, ($s0) # load a word from s1
  	addi $s0, $s0, 4 # increment the address of s1
  	sw $t1, ($s1) # store the word to s2
  	addi $s1, $s1, 4 # increment the address of s2
  	addi $t0, $t0, -1 # decrement the loop counter
  	bne $t0, $zero, penis # if loop counter != 0, branch back to Loop


	# Your implementation of selSort here
	addi $sp, $sp, -8	# Reserve space on stack
	sw $ra, 0($sp)		# Save the return address
	sw $s0, 4($sp)		# Save $s0
	
	move $s0, $a0		# $s0 = array
	move $t0, $zero		# $t0 = i = 0
	move $t1, $zero		# $t1 = j = 0
	
loop_outer:
	bge $t0, $a1, end_selSort	# If i >= n, exit
	
	move $t1, $t0		# j = i
	addi $t1, $t1, 1
	
loop_inner:
	bge $t1, $a1, end_inner	# If j >= n, exit inner loop
	
	sll $t2, $t0, 2	# Compute the address of array[i]
	add $t2, $s0, $t2
	
	sll $t3, $t1, 2	# Compute the address of array[j]
	add $t3, $s0, $t3
	
	lw $t4, 0($t2)		# t4 = array[i]
	lw $t5, 0($t3)		# t5 = array[j]
	
	bge $t5, $t4, end_if	# If array[j] < array[i], skip swap
	
	sw $t5, 0($t2)		# Swap array[i] and array[j]
	sw $t4, 0($t3)
	
end_if:
	addi $t1, $t1, 1	# j++
	j end_inner
	
end_inner:
	addi $t0, $t0, 1	# i++
	j loop_outer
	
end_selSort:
	move $v0, $s0		# Return sorted array
	lw $ra, 0($sp)		# Restore return address
	lw $s0, 4($sp)		# Restore $s0
	addi $sp, $sp, 8	# Deallocate space on stack
	jr $ra			# Return


	
# calcSum takes in an array and its size as arguments.
# It RECURSIVELY computes and returns the sum of elements in the array.
# Note: you MUST NOT use iterative approach in this function.
calcSum:
	# Your implementation of calcSum here

	addi $sp, $sp, -12
    	sw $ra, 0($sp)
    	sw $a0, 4($sp)
    	sw $a1, 8($sp)

    	# Base case: if len <= 0, return 0
    	lw $t0, 8($sp)
    	blez $t0, calcSum_done
    	addi $a1, $a1, -1

    	# Recursive case: return calcSum(arr, len - 1) + arr[len - 1]
    	lw $t1, 4($sp)
    	lw $t2, 8($sp)
    	sll $t3, $t2, 2
    	add $t4, $t1, $t3    # t4 = &arr[len-1]
    	lw $t5, ($t4)        # t5 = arr[len-1]
    	jal calcSum          # recursive call on arr[0..len-2]
    	add $v0, $v0, $t5   # v0 = calcSum(arr, len - 1) + arr[len - 1]

calcSum_done:
    	lw $a0, 4($sp)
    	lw $a1, 8($sp)
    	lw $ra, 0($sp)
    	addi $sp, $sp, 12
    	jr $ra
