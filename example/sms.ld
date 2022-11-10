SECTIONS {
  . = 0x817F0000;
  .init : { _start.o }
  .text : { *(.text) }
  .rodata : { *(.rodata) }
  .data : { *(.data) }
  .bss : { *(.bss) }
}

/** TODO version */
TMarioGamePad_read = 0x800fba58;
JUTGamePad_mPadStatus = 0x80400d50;

config = 0x817fc000;
