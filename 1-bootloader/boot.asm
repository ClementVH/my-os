[bits 16]

jmp $

times 510 - ($-$$) db 0;
dw 0xaa55
