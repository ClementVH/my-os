SECTIONS
{
  . = 0x1000;
  .text : {
    *(.text)

    . = ALIGN(512 * 8);
  }
}