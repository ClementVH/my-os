SECTIONS
{
  . = 0x2000;
  .text : {
    *(.text)
    *(.data)
    *(.bss)

    . = ALIGN(512 * 8);
  }
}