[bits 16]
[org 0x7c00]

mov al, 'H'
mov ah, 0x0e
int 0x10

jmp $

times 510 - ($-$$) db 0;
dw 0xaa55
