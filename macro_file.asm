#### print_int ####  	print_int(4)	print_int($t0)
.macro print_int (%x)
    	li 	$v0, 1
    	add	$a0, $zero, %x
    	syscall
.end_macro

#### print_gloat ####  	print_loat(4.2)	print_int($f0)
.macro print_float (%f)
    	li 	$v0, 2
    	mov.s $f12, %f
    	syscall
.end_macro

#### print_str ####  	print_str("string in quotes")
.macro print_str (%str)
    	.data
macro_str:	.asciiz %str
    	.text
   	li	$v0, 4
    	la	$a0, macro_str
  	syscall
.end_macro

.macro draw_pixel (%x, %y, %c)
	add 	$a0, $0, %x    
	add 	$a1, $0, %y   
	add 	$a2, $0, %c  
	
	# s1 = address = $gp + 4*(x + y*width)
	mul	$t9, $a1, WIDTH   # y * WIDTH
	add	$t9, $t9, $a0	  # add X
	mul	$t9, $t9, 4	  # multiply by 4 to get word offset
	add	$t9, $t9, $gp	  # add to base address
	sw	$a2, ($t9)	  # store color at memory location
.end_macro 

.macro is_blue (%x, %y)
	add 	$a0, $0, %x    
	add 	$a1, $0, %y   
	
	# s1 = address = $gp + 4*(x + y*width)
	mul	$t9, $a1, WIDTH   # y * WIDTH
	add	$t9, $t9, $a0	  # add X
	mul	$t9, $t9, 4	  # multiply by 4 to get word offset
	add	$t9, $t9, $gp	  # add to base address
	lw	$t0, ($t9)
	addi 	$a2, $0, BLUE  
	beq	$a2, $t0, branch
	j	end_m
	
branch:	beq	$s1, 119, incr1 	# input w
	beq	$s1, 115, incr2 	# input s
	beq	$s1, 97, incr3  	# input a
	beq	$s1, 100, incr4		# input d
	
incr1:	# up	
	addi	$a1, $a1, 1
	addi 	$a2, $0, RED
	draw_pixel($a0, $a1, $a2)
	j	loop
	
incr2:	# down
	addi	$a1, $a1, -1
	addi 	$a2, $0, RED
	draw_pixel($a0, $a1, $a2)
	j	loop
	
incr3:	# left
	addi	$a0, $a0, 1
	addi 	$a2, $0, RED
	draw_pixel($a0, $a1, $a2)
	j	loop
	
incr4:	# right
	addi	$a0, $a0, -1
	addi 	$a2, $0, RED
	draw_pixel($a0, $a1, $a2)
	j	loop
	
end_m:	# do nothing
.end_macro
.macro is_finished (%x, %y)
	add 	$a0, $0, %x    
	add 	$a1, $0, %y   
	
	# s1 = address = $gp + 4*(x + y*width)
	mul	$t9, $a1, WIDTH   # y * WIDTH
	add	$t9, $t9, $a0	  # add X
	mul	$t9, $t9, 4	  # multiply by 4 to get word offset
	add	$t9, $t9, $gp	  # add to base address
	lw	$t0, ($t9)
	addi 	$a2, $0, GREEN 
	beq	$a2, $t0, exit
.end_macro

.macro	draw_horizontal (%x, %y, %c)
	add 	$a0, $0, %x    
	add 	$a1, $0, %y
	addi	$t0, $0, %c

looph:	addi	$a0, $a0, 1
	addi 	$a2, $0, BLUE
	draw_pixel($a0, $a1, $a2)
	addi	$t0, $t0, -1
	bnez	$t0, looph
	
.end_macro
