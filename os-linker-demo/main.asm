[bits 16]
pusha

mov al, ' '
mov ah, 0x0e
int 0x10

mov al, 'M'
mov ah, 0x0e
int 0x10

mov al, 'A'
mov ah, 0x0e
int 0x10

mov al, 'I'
mov ah, 0x0e
int 0x10

mov al, 'N'
mov ah, 0x0e
int 0x10

mov al, ' '
mov ah, 0x0e
int 0x10

popa
ret

section .data
HELLO_WORLD: db 'HELLO_WORLD', 0
