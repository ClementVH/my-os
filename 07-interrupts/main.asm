[bits 32]
[org 0x2000]

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
mov al, 0xFD
out dx, al

jmp $

isr33:
  mov al, 'F'
  mov ah, 0x0f
  mov edx, 0xb8000
  mov [edx], ax
  ret

%include "idt.asm"

times 4096 - ($-$$) db 0;
