.set dst, 0x817fa800

## backup r15 (pointer to current gecko instruction) at dst-4
  add r0, r15, r4
  lis r3, dst-4@ha
  stwu r0, dst-4@l(r3)
## update r15 = dst + 8(header) - r4(this C0 code size)
  addi r15, r3, 4+8
  sub r15, r15, r4
  blr
