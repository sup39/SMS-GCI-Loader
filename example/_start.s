.include "./macros.s"

.macro .rwbl src dst
  li32 r3, \src
  li32 r4, \dst
  bl replace_with_bl
.endm

.globl _start
_start: # right after gci loaded into RAM
  mflr r11 # need to make sure r11 is not destroyed

## replace original instruction @src with `bl dst`
## TODO version
  .rwbl 0x800f9a10, _gameLoop
  .rwbl 0x800ecde0, _getQFSync

## return
  mtlr r11
  blr

/**
 * r3 = address of original code
 * r4 = address of practice code function
 */
replace_with_bl:
## bl from r3 to r4
  sub r4, r4, r3
  rlwinm r4, r4, 0, 6, 29
  oris r4, r4, 0x4800
  ori r4, r4, 0x1
  stw r4, 0(r3)
## invalidate cache
  dcbst 0, r3
  sync
  icbi 0, r3
  isync
  blr
