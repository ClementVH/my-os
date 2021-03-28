SECTIONS
{
  . = 0x1000;
  .text : {
    *(.text)

    . = 0xC00;
    *(.mode-infos)

    . = ALIGN(512 * 8);
  }
}