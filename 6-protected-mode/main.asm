[bits 32]
[org 0x1000]

mov al, 'F'
mov ah, 0x0f
mov edx, 0xb8000
mov [edx], ax

jmp $

times 512 - ($-$$) db 0;
