SECTIONS
{
  . = 0x8c00;
  .rom : {
    *(.text)

    . = ALIGN(10 * 512);
  }

}
