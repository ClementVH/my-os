[bits 32]
[extern main]
[extern handle_keyboard]
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

mov edx, 0x21
mov al, 0xFC
out dx, al

call main

jmp $

isr33:
	pusha

  call handle_keyboard

	popa
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

global inb
inb:
  mov edx, [esp + 4]
  in al, dx
  ret

%include "lib/idt.asm"
