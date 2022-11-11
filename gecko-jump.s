.set gpApplication, 0x803e6000 # TODO version
.set dst, 0x817fb000

## TODO prevent softlock: check app state >= 4
  lis r5, gpApplication+8@ha
  lbz r5, gpApplication+8@l(r5)
  cmplwi r5, 4
  bltlr
## r5 = 00D0C0DE
  lis r5, 0x00D0
  ori r5, r5, 0xC0DE
## check if code is loaded (check header)
  lis r3, dst@ha
### first 00D0C0DE
### r3 = &dst
  lwzu r0, dst@l(r3)
  cmplw r0, r5
  bnelr
### second 00D0C0DE
  lwz r0, 4(r3)
  cmplw r0, r5
  bnelr
## backup r15 (pointer to current gecko instruction) at dst-4
  add r0, r15, r4
  stw r0, -4(r3)
## update r15 = dst + 8(header) - r4(this C0 code size)
  addi r15, r3, 8
  sub r15, r15, r4
  blr
