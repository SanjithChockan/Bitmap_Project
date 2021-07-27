# Bitmap Project
# Sanjith Chockan
# July 26, 2021

# Program Description:
# The program is a game where the character goes through a 
# random generated maze to the end to complete the game. 
# The character is represented by a red pixel, which starts from the top left. 
# It is controlled by the user to take it to the end, which is at the bottom right represented by a green pixel. 
# Upon the completion of the game, you should receive a congratulating message on the console.

# Instructions: 
#   Connect bitmap display:
#         set pixel dim to 8x8
#         set display dim to 256x256
#	use $gp as base address
#   Connect keyboard and run
#	use w (up), s (down), a (left), d (right), space (exit)
#	all other keys are ignored
#   Get the red pixel all the way to the green pixel (at the bottom right)
#   to complete the game

.include	"macro_file.asm"

# set up some constants
# width of screen in pixels
# 256 / 8 = 32
.eqv WIDTH 32
# height of screen in pixels
.eqv HEIGHT 32
# colors
.eqv	RED 	0x00FF0000
.eqv	GREEN 	0x0000FF00
.eqv	BLUE	0x000000FF
.eqv	BLACK	0x00000000

	.text
main:	print_str("Start program\n")
	# draw margin
	draw_vertical(0,-1,32)
	draw_vertical(31,-1,31)
	draw_horizontal(0, 0, 32)
	
	li	$t1, 2	# y variable to draw horizontal lines
	
draw:	# sets up the maze with horizontal lines
	draw_horizontal(0, $t1, 30)
	
	# generate random number for path from 0 - 29 inclusive
	li	$v0, 42
	li	$a0, 1
	li	$a1, 30
	syscall
	
	addi	$a0, $a0, 1	# increment by 1 to ensure it doesn't store a zero
	draw_pixel($a0, $t1, BLACK)	# black the pixel to make a path
	
	addi	$t1, $t1, 2	# increment to draw next line
	ble	$t1, 32, draw	# draw until y <= 32
	
init:	# set up end point (bottom right, GREEN)
	draw_pixel(31, 31, GREEN)
	# load this for start values to draw the red character
	li	$a0, 1
	li	$a1, 1
	addi 	$a2, $0, RED
loop:	# draw a red  pixel 
	draw_pixel($a0, $a1, $a2)
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
up:	
	li	$a2, 0		# black out the pixel
	draw_pixel($a0, $a1, $a2)
	addi	$a1, $a1, -1
	is_finished($a0, $a1)	# check if at green pixel
	is_blue($a0, $a1)	# check if it is colliding with the wall
	addi 	$a2, $0, RED
	draw_pixel($a0, $a1, $a2)
	j	loop

down:	
	li	$a2, 0		# black out the pixel
	draw_pixel($a0, $a1, $a2)
	addi	$a1, $a1, 1
	is_finished($a0, $a1)	# check if at green pixel
	is_blue($a0, $a1)	# check if it is colliding with the wall
	addi 	$a2, $0, RED
	draw_pixel($a0, $a1, $a2)
	j	loop
	
left:	
	li	$a2, 0		# black out the pixel
	draw_pixel($a0, $a1, $a2)
	addi	$a0, $a0, -1
	is_finished($a0, $a1)	# check if at green pixel
	is_blue($a0, $a1)	# check if it is colliding with the wall
	addi 	$a2, $0, RED
	draw_pixel($a0, $a1, $a2)
	j	loop
	
right:	
	li	$a2, 0		# black out the pixel
	draw_pixel($a0, $a1, $a2)
	addi	$a0, $a0, 1
	is_finished($a0, $a1)	# check if at green pixel
	is_blue($a0, $a1)	# check if it is colliding with the wall
	addi 	$a2, $0, RED
	draw_pixel($a0, $a1, $a2)
	j	loop
		
exit:	# exiting the program
	print_str("Congrats on completing the game! \n")
	li	$v0, 10
	syscall