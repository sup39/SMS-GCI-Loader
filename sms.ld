SECTIONS {
  . = 0x80000000;  /* TODO: Determine Address */
  .text : { *(.text) }
  .rodata : { *(.rodata) }
  .data : { *(.data) }
  .bss : { *(.bss) }
  .sdata : { *(.sdata) }
}

mount_ = 0x80107b50;
open_ = 0x801072f4;
CARDOpen = 0x800a3cac;
CARDRead = 0x800a4640;
CARDClose = 0x800a3e24;
foobar = 0x810a4e90;
