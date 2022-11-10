.globl _getQFSync
_getQFSync:
  lis r12, 0x8180
  lwz r12, -0x4000(r12)
  rlwinm. r12, r12, 2, 0x3
  li r3, 600
  slw r3, r3, r12
  blr
