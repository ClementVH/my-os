[bits 32]

[extern main]
[extern keyboard_handler_main]

global read_port
global write_port
global load_idt
global keyboard_handler
global IDT

call main

jmp $

read_port:
  mov edx, [esp + 4]
  in al, dx
  ret

write_port:
  mov edx, [esp + 4]
  mov al, [esp + 4 + 4]
  out dx, al
  ret

load_idt:
  mov edx, [esp + 4]
  lidt [edx]
  sti
  ret

times 512 -($-$$) db 0

keyboard_handler:
  pushad
  cli
  call keyboard_handler_main
  sti
  popad
  iretd

IDT:
  times 256 dw 0
  times 256 dw 0
  times 256 db 0
  times 256  db 0
  times 256  dw 0

  ; dw 0x2800 + 0x200
  ; dw 0x8
  ; db 0
  ; db 0x8e
  ; dw 0

  ; times 256 - 0x22 dw 0
  ; times 256 - 0x22 dw 0
  ; times 256 - 0x22 db 0
  ; times 256 - 0x22  db 0
  ; times 256 - 0x22  dw 0