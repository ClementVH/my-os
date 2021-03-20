SECTIONS
{
  . = 0x7c00;
  .text : {
    *(.boottext)

    . = 0x1FE;
    SHORT(0xAA55)

    . = ALIGN(512);
  }

  . = 0x8c00;
  __main_start = .;
  .main : {
    *(.text)
    *(.data)

    . = ALIGN(512 * 20);
  }

}
