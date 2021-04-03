[bits 32]
[extern main]
[extern pit_loop]
section .text

mov edx, 0x20
mov al, 0x11
out dx, al
mov edx, 0xA0
mov al, 0x11
out dx, al

mov edx, 0x21
mov al, 0x20
out dx, al
mov edx, 0xA1
mov al, 0x28
out dx, al

mov edx, 0x21
mov al, 0x00
out dx, al
mov edx, 0xA1
mov al, 0x00
out dx, al

mov edx, 0x21
mov al, 0x01
out dx, al
mov edx, 0xA1
mov al, 0x01
out dx, al

mov edx, 0x21
mov al, 0xff
out dx, al
mov edx, 0xA1
mov al, 0xff
out dx, al

lidt [idt_descriptor]
sti

; PIT set 100Hz
mov edx, 0x43 ; Command Register
mov al, 0x36 ; 0b00110110 => |CNTR=0(Counter)|RW=3(LSB then MSB)|MODE=3(square wave mode)|BCD=0(false)|
out dx, al

mov edx, 0x40 ; Data register
mov al, (1193180 / 100) & 0xFF ; LSB
out dx, al

mov edx, 0x40 ; Data register
mov al, (1193180 / 100) >> 8 ; MSB
out dx, al

mov edx, 0x21
mov al, 0xFC
out dx, al

call main

jmp $

isr33:
  mov al, 'F'
  mov ah, 0x0f
  mov edx, 0xb8000
  mov [edx], ax
  mov edx, 0x20
  mov al, 0x20
  out dx, al
  iret

isr32:
  call pit_loop
  mov edx, 0x20
  mov al, 0x20
  out dx, al
  iret

global memcpy
memcpy:
  mov edi, [esp + 4]
  mov esi, [esp + 4 + 4]
  mov ecx, [esp + 4 + 4 + 4]
  cld
  rep movsd
  ret

%include "lib/idt.asm"
