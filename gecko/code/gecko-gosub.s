## check status
### r3 = GCTDST
  lis r3, GCTDST@ha
  lwzu r0, GCTDST@l(r3)
### return if not DONE(2)
  cmpwi r0, 2
  bnelr

## backup r15 (pointer to current gecko instruction)
  add r0, r15, r4
  stw r0, 4(r3)
## update r15 = dst + 8(GCTDST.code-r3) - r4(this C0 code size)
  addi r15, r3, 8
  sub r15, r15, r4
  blr
