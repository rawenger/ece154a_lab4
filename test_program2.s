# test2.asm
#Assembly Code
main:
	ori	$t0, $0,  0x8000	# $t0 = 0x8000
	addi	$t1, $0,  -32768	# $t1 = 0xfffff332
	ori	$t2, $t0, 0x8001	# $t2 = 0xfffff332
	beq	$t0, $t1, there		# not taken
	slt	$t3, $t1, $t0		# $t3 = 1
	bne	$t3, $0, here		# taken
	j	there	    # doesn't execute
here:
	sub	$t2, $t2, $t0		# $t2 = 0xffff7332
	ori	$t0, $t0, 0xFF		# $t0 = 0x000080ff
there:	
	add	$t3, $t3, $t2		# $t3 = 0xffff7333
	sub	$t0, $t2, $t0		# $t0 = 0xffff7233
	sw	$t0, 82($t3)		# [0xffff7385] = 0xffff7233