	.data	
C:		.space 400
Array:	 	.word 56,3,46,47,34,12,1,5,10,8,33,25,29,31,50,43
ArrayText1: 	.asciiz "Unsorted Array: "
ArrayText2:	.asciiz "Sorted Array: "
Space:		.asciiz " "
EndLine:  	.asciiz "\n"

	.text
Main:
	#Prints The Message: "Unsorted Array: "
	la $a0, ArrayText1			#load the data at ArrayText1 into $a0
	li $v0, 4					#get ready to print
	syscall						#print the content in $a0
	
	#Print The Unsorted Array
	la $a1, Array				#load the address of Array into $a1
	la $a2, 16					#load 16 (size of Array) into $a2
	jal PrintArray				#jal to PrintArray to print Array values
	la $a0, EndLine				#store the data in EndLine into $a0
	li $v0, 4					#get ready to print
	syscall						#print the content in $a0
	
	#MergeSort
	la $a0, Array				#load the address of Array into $a0
	la $a1, 0					#load 0 (low) into $a1
	la $a2, 15					#load 15 (high) into $a2
	jal MergeSort
	
	#Prints The Message: "Sorted Array: "
	la $a0, ArrayText2			#load the data at ArrayText2 into $a0
	li $v0, 4					#get ready to print
	syscall						#print the content in $a0
	
	#Print The Sorted Array
	la $a1, Array				#load the address of Array into $a1
	la $a2, 16					#load 16 (size of Array) into $a2
	jal PrintArray
	
	#Exits The Program
	j Exit						#jumps to Exit

MergeSort:
	#Store registers in the stack (Push)
	subi $sp, $sp, 20			#allocate memory for saving register values.
	sw $ra, 16($sp)				#save return address
	sw $s0, 12($sp)				#save Array address
	sw $s1, 8($sp)				#save low
	sw $s2, 4($sp)				#save high
	sw $s3, 0($sp)				#save mid
	
	#Move all A registers to S registers
	move $s0, $a0				#store $a0(Array address) to $s0
	move $s1, $a1				#store $a1(low) to $s1
	move $s2, $a2				#store $a2(high) to $s2
	move $s3, $a3				#store $a3(mid) to $s3
	
	#Check if the if statement is valid
		#low<high
	slt $t0, $s1, $s2			#low<high
	beq $t0, $zero, MSExit		#if false, MSExit

	#Calculate mid
		#mid=(low+high)/2
	add $s3, $s1, $s2			#mid=low+high
	srl $s3, $s3, 1				#mid=(low+high)/2
	
	#Get the registers ready to enter MergeSort
	move $a0, $s0				#store $s0(Array address) into $a0
	move $a1, $s1				#store $s1(low) into $a1
	move $a2, $s3				#store $s3(mid) into $a2
	jal MergeSort
	
	#Get the registers ready to enter MergeSort
	move $a0, $s0				#store $s0(Array address) into $a0
	addi $a1, $s3, 1			#store mid+1 into $a1
	move $a2, $s2				#store $s2(high) into $a2
	jal MergeSort
	
	#Get the registers ready to enter Merge
	move $a0, $s0				#store $s0(Array address) into $a0
	move $a1, $s1				#store $s1(low) into $a1
	move $a2, $s2				#store $s2(high) into $a2
	move $a3, $s3				#store $s3(mid) into $a3
	jal Merge

	MSExit:
		#Restore all registers (Pop)
		lw $s3, 0($sp)			#restore mid
		lw $s2, 4($sp)			#restore high
		lw $s1, 8($sp)			#restore low
		lw $s0, 12($sp)			#restore Array address
		lw $ra, 16($sp)			#restore return address
		addi $sp, $sp, 20		#free the memory
		jr $ra
	
Merge:
	move $t0, $a1 				#move $a1 (low) into $t0 (i)
	move $t1, $a1				#move $a1 (low) into $t1 (k)
	addi $t2, $a3, 1			#store $a3 (mid) + 1 to $t2 (j)
	la $t9, C					#store C address in $t9
	
	while1:
		#Check if while1 is valid
			#i<=mid && j<=high
		sle $t3, $t0, $a3		#i <= mid
		sle $t4, $t2, $a2		#j <= high
		and $t3, $t3, $t4		#check if both are two
		beq $t3, $zero, while2	#if one is false, skip while1

		if:
			#Check if if is valid
				#Find value at a[i]
			sll $t3, $t0, 2		#offset of i
			add $t3, $a0, $t3	#address of a[i]
			lw $t3, 0($t3)		#value at a[i]
				#Find value at a[j]
			sll $t4, $t2, 2		#offset of j
			add $t4, $a0, $t4	#address of a[j]
			lw $t4, 0($t4)		#value at a[j]
				#a[i]<a[j]
			slt $t4, $t3, $t4
			beq $t4, $zero, else
			
			#Store a[i] in c[k]
				#c[k] = a[i]
			sll $t4, $t1, 2		#offset of k
			add $t4, $t9, $t4	#address of c[k]
			sw $t3, 0($t4)		#c[k] = a[i]
			
			#Increments
			addi $t1, $t1, 1	#k++
			addi $t0, $t0, 1	#i++
			
			j while1
			
		else:
			#Store a[j] in c[k]
				#c[k] = a[j]
			sll $t3, $t1, 2		#offset of k
			add $t3, $t9, $t3	#address of c[k]
			sll $t4, $t2, 2		#offset of j
			add $t4, $a0, $t4	#address of a[j]
			lw $t4, 0($t4)		#value of a[j]
			sw $t4, 0($t3)		#c[k] = a[j]
				
			#Increments
			addi $t1, $t1, 1	#k++
			addi $t2, $t2, 1	#j++
			
			j while1
			
	while2:
		#Check if while2 is valid
			#i <= mid
		sle $t3, $t0, $a3		#i<=mid
		beq $t3, $zero, while3
		
		#Store a[i] in c[k]
			#c[k] = a[i]
		sll $t3, $t1, 2			#offset of k
		add $t3, $t9, $t3		#address of c[k]
		sll $t4, $t0, 2			#offset of i
		add $t4, $a0, $t4		#address of a[i]
		lw $t4, 0($t4)			#value at a[i]
		sw $t4, 0($t3)			#c[k] = a[i] 
		
		#Increments
		addi $t1, $t1, 1		#k++
		addi $t0, $t0, 1		#i++
		
		j while2
		
	while3:
		#Check if while3 is valid
			#j <= high
		sle $t3, $t2, $a2
		beq $t3, $zero, forLoopReseti
		
		#Store a[j] in c[k]
			#c[k] = a[j]
		sll $t3, $t1, 2			#offset of k
		add $t3, $t9, $t3		#address of c[k]
		sll $t4, $t2, 2			#offset of j
		add $t4, $a0, $t4		#address of a[j]
		lw $t4, 0($t4)			#value at a[j]
		sw $t4, 0($t3)			#c[k] = a[j]
		
		#Increments
		addi $t1, $t1, 1		#k++
		addi $t2, $t2, 1		#j++
		
		j while3

	forLoopReseti:
		#Set i to low
		move $t0, $a1
		
	forLoop:
		#Check if the loop is valid
			#i < k
		slt $t3, $t0, $t1
		beq $t3, $zero, mergeExit
		
		#Store c[j] in a[i]
			#a[i] = c[i]
		sll $t3, $t0, 2			#offset of i
		add $t4, $a0, $t3		#address of a[i]
		add $t3, $t9, $t3		#address of c[i]
		lw $t3, 0($t3)			#value at c[i]
		sw $t3, 0($t4)			#a[i] = c[i]
		
		#Increment
		addi $t0, $t0, 1		#i++
		
		j forLoop
		
	mergeExit:
		jr $ra
		
PrintArray:
	li $t0, 0					#set $t0 (i) to 0
	
	printWhile:
		#Check if there are more index's to print out
			# i ($t0) < arraySize ($a2)
		slt $t1, $t0, $a2
		beq $t1, $zero, printExit
		
		#Find the value at index i ($t0) and print it
		sll $t1, $t0, 2			#offset at index i ($t0)
		add $t1, $a1, $t1		#address at index i
		lw $a0, 0($t1)			#load word at address $t1 into $a0
		li $v0, 1				#get ready to print
		syscall					#print the value
		lw $a0, Space			#load " " into $a0
		li $v0, 11				#get ready to print
		syscall					#print " "
		
		#Increment
		addi $t0, $t0, 1
		
		j printWhile
		
	printExit:
		jr $ra					#return to jal call in main

Exit:				
	li $v0, 10					
	syscall						#program is over
