## restore r15 (pointer to current gecko instruction)
  lis r3, GCTDST+4@ha
  lwz r15, GCTDST+4@l(r3)
## update r15 = restored r15 - r4(this C0 code size)
  sub r15, r15, r4
  blr
