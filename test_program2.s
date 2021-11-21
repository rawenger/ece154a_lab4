# test2.asm
#Assembly Code
main:
	ori	$t0, $0,  0x8000	# $t0 = 0x00008000
	addi	$t1, $0,  -32768	# $t1 = 0xffff8000
	ori	$t2, $t0, 0x8001	# $t2 = 0x00008001
	beq	$t0, $t1, there		# not taken
	slt	$t3, $t1, $t0		# $t3 = 1
	bne	$t3, $0, here		# taken
	j	there	    # doesn't execute
here:
	sub	$t2, $t2, $t0		# $t2 = 1
	ori	$t0, $t0, 0xFF		# $t0 = 0x000080ff
there:	
	add	$t3, $t3, $t2		# $t3 = 2
	sub	$t0, $t2, $t0		# $t0 = 0xffff7f00
	sw	$t0, 82($t3)		# [0x54] = 0xffff7f02