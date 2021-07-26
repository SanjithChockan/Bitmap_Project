# set up some constants
# width of screen in pixels
# 256 / 8 = 32
.eqv WIDTH 64
# height of screen in pixels
.eqv HEIGHT 32

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

.macro is_finished (%x, %y)
	add 	$a0, $0, %x    
	add 	$a1, $0, %y   
	
	# s1 = address = $gp + 4*(x + y*width)
	mul	$t9, $a1, WIDTH   # y * WIDTH
	add	$t9, $t9, $a0	  # add X
	mul	$t9, $t9, 4	  # multiply by 4 to get word offset
	add	$t9, $t9, $gp	  # add to base address
	lw	$t0, ($t9)
	addi 	$a2, $0, GREEN  # a2 = red (ox00RRGGBB)
	beq	$a2, $t0, exit
.end_macro