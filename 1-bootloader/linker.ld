SECTIONS
{
  . = 0x7c00;
  .boottext : {
    *(.boottext)

    . = 0x1FE;
    SHORT(0xAA55)

    . = ALIGN(512);
  }

}
