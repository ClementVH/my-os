SECTIONS
{
  . = 0x2000;
  .text : {
    *(.text)

    . = ALIGN(512 * 8);
  }
}