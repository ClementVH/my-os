SECTIONS
{
  . = 0x7c00;
  .rom : {
    KEEP(*(.boottext))

    . = 0x1FE;
    SHORT(0xAA55)

    . = ALIGN(512);
  }

  __main_start = .;
  .main : {
    *(.text)
    *(.data)

    . = ALIGN(512 * 20);
  }

}
