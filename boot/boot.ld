SECTIONS
{
  . = 0x7c00;
  .rom : {
    *(.text)
    *(.data)

    . = 0x1FE;
    SHORT(0xAA55)

    . = ALIGN(512);
  }

}
