/**
 * There seems to be an alignment issue
 * addr of GCTDST.code may need to be a multiple of 0x200 or something?
 * The address should be sync with the value set in GCI Generator
 */
GCTDST = 0x817F1800 - 8;

SECTIONS {
  . = 0x817FD800;  /* TODO: Determine Best Address */
  .text : { *(.text) }
  .rodata : { *(.rodata) }
  .data : { *(.data) }
  .bss : { *(.bss) }
  .sdata : { *(.sdata) }
}
