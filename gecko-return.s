.set dst, 0x817fa800

## restore r15 (pointer to current gecko instruction) from dst-4
  lis r3, dst-4@ha
  lwz r15, dst-4@l(r3)
## update r15 = restored r15 - r4(this C0 code size)
  sub r15, r15, r4
  blr
