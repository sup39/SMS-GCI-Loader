	.file	"ReadFile.c"
	.machine ppc
	.section	".text"
	.globl onReadOptionBlock
	.type	onReadOptionBlock, @function
onReadOptionBlock:
.LFB0:
	stwu 1,-32(1)
	#mflr 0
	stmw 27,12(1)
	lis 29,0x817f
	ori 29,29,0xe800
	lis 28,0xabcd
	lwz 9,0(29)
	ori 28,28,0x1234
	#stw 0,36(1)
	mr 30,3
	cmpw 0,9,28
	mr 31,4
	beq- 0,.L3
	lis 9,mount_@ha
	li 4,1
	la 9,mount_@l(9)
	mtctr 9
	bctrl
	cmpwi 0,3,0
	bne- 0,.L3
	lis 9,CARDOpen@ha
	la 9,CARDOpen@l(9)
	lwz 3,0(30)
	mr 5,31
	bl .LC0
	.string	"gct"
	.section	".text"
	.align 2
.LC0: mflr 4
	mtctr 9
	bctrl
	cmpwi 0,3,0
	bne- 0,.L3
	lis 27,0x817f
	lis 9,CARDRead@ha
	la 9,CARDRead@l(9)
	ori 27,27,0xa800
	li 6,0
	li 5,16384
	mr 4,27
	mr 3,31
	mtctr 9
	bctrl
	cmpwi 0,3,0
	bne- 0,.L5
	lwz 9,0(27)
	xoris 10,9,0xff2f
	cmpwi 0,10,-16162
	bne 0,.L5
	lis 10,0x817f
	ori 10,10,0xa804
	lwz 10,0(10)
	cmpw 0,10,9
	bne+ 0,.L5
	stw 28,0(29)
.L5:
	lis 9,CARDClose@ha
	mr 3,31
	la 9,CARDClose@l(9)
	mtctr 9
	bctrl
.L3:
	lis 9,open_@ha
	mr 4,31
	la 9,open_@l(9)
	mr 3,30
	mtctr 9
	bctrl
	lmw 27,12(1)
	addi 1,1,32
.LFE0:
	.size	onReadOptionBlock, .-onReadOptionBlock
	.ident	"GCC: (devkitPPC release 41) 12.1.0"
