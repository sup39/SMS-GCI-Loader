/**
 * There seems to be an alignment issue
 * addr of GCTDST.code may need to be a multiple of 0x200 or something?
 */
GCTDST = 0x817F1800 - 8;

SECTIONS {
  . = 0x817FE800;  /* TODO: Determine Best Address */
  .text : { *(.text) }
  .rodata : { *(.rodata) }
  .data : { *(.data) }
  .bss : { *(.bss) }
  .sdata : { *(.sdata) }
}
