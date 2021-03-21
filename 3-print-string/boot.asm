[bits 16]

; set DS register to where we are loaded in memory
mov ax, 0x07C0
mov ds, ax

mov bx, HELLO_WORLD
call print_string

jmp $


print_char:
  mov ah, 0x0e
  int 0x10
  ret

print_string:
  mov al, [bx]
  call print_char

  add bx, 1
  cmp byte[bx], 0
  jne print_string

  ret


; Variables
HELLO_WORLD: db 'Hello World', 0

times 510 - ($-$$) db 0;
dw 0xaa55
