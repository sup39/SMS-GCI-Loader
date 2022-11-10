.macro li32 reg val
  lis \reg, \val@h
  ori \reg, \reg, \val@l
.endm
