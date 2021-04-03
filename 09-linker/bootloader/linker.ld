SECTIONS
{
  . = 0x7c00;
  .text : {
    *(.text)

    . = 0x1FE;
    SHORT(0xAA55)

    . = ALIGN(512);
  }
}