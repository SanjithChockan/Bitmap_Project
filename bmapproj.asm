# Bitmap Demo Program 2
# Sanjith Chockan
# July 26, 2021

# Instructions: 
#   Connect bitmap display:
#         set pixel dim to 8x8
#         set display dim to 512x256
#	use $gp as base address
#   Connect keyboard and run
#	use w (up), s (down), a (left), d (right), space (exit)
#	all other keys are ignored

# set up some constants
# width of screen in pixels
# 256 / 8 = 32
.eqv WIDTH 64
# height of screen in pixels
.eqv HEIGHT 32
# colors
.eqv	RED 	0x00FF0000
.eqv	GREEN 	0x0000FF00
.eqv	BLUE	0x000000FF
.eqv	WHITE	0x00FFFFFF
.eqv	YELLOW	0x00FFFF00
.eqv	CYAN	0x0000FFFF
.eqv	MAGENTA	0x00FF00FF

.text
main:
	addi 	$a0, $0, 63    # a0 = X = 0
	addi 	$a1, $0, 31   # a1 = Y = 0
	addi 	$a2, $0, GREEN  # a2 = red (ox00RRGGBB)
	jal	draw_pixel
	# set up starting position (top left)
	addi 	$a0, $0, 1    # a0 = X = 0
	addi 	$a1, $0, 0   # a1 = Y = 0
	addi 	$a2, $0, RED  # a2 = red (ox00RRGGBB)
	
loop:	# draw a red  pixel 
	jal 	draw_pixel
	
	# check for input
	lw $t0, 0xffff0000  #t1 holds if input available
    	beq $t0, 0, loop   #If no input, keep displaying
	
	# process input
	lw 	$s1, 0xffff0004
	beq	$s1, 32, exit	# input space
	beq	$s1, 119, up 	# input w
	beq	$s1, 115, down 	# input s
	beq	$s1, 97, left  	# input a
	beq	$s1, 100, right	# input d
	# invalid input, ignore
	j	loop
	
	# process valid input
	
up:	li	$a2, 0		# black out the pixel
	jal	draw_pixel
	addi	$a1, $a1, -1
	jal	is_finished
	addi 	$a2, $0, RED
	jal	draw_pixel
	j	loop

down:	li	$a2, 0		# black out the pixel
	jal	draw_pixel
	addi	$a1, $a1, 1
	jal	is_finished
	addi 	$a2, $0, RED
	jal	draw_pixel
	j	loop
	
left:	li	$a2, 0		# black out the pixel
	jal	draw_pixel
	addi	$a0, $a0, -1
	jal	is_finished
	addi 	$a2, $0, RED
	jal	draw_pixel
	j	loop
	
right:	li	$a2, 0		# black out the pixel
	jal	draw_pixel
	addi	$a0, $a0, 1
	jal	is_finished
	addi 	$a2, $0, RED
	jal	draw_pixel
	j	loop
		
exit:	li	$v0, 10
	syscall

#################################################
# subroutine to draw a pixel
# $a0 = X
# $a1 = Y
# $a2 = color
is_finished:
	# s1 = address = $gp + 4*(x + y*width)
	mul	$t9, $a1, WIDTH   # y * WIDTH
	add	$t9, $t9, $a0	  # add X
	mul	$t9, $t9, 4	  # multiply by 4 to get word offset
	add	$t9, $t9, $gp	  # add to base address
	lw	$t0, ($t9)
	addi 	$a2, $0, GREEN  # a2 = red (ox00RRGGBB)
	beq	$a2, $t0, exit
	jr	$ra
	

draw_pixel:
	# s1 = address = $gp + 4*(x + y*width)
	mul	$t9, $a1, WIDTH   # y * WIDTH
	add	$t9, $t9, $a0	  # add X
	mul	$t9, $t9, 4	  # multiply by 4 to get word offset
	add	$t9, $t9, $gp	  # add to base address
	sw	$a2, ($t9)	  # store color at memory location
	jr 	$ra