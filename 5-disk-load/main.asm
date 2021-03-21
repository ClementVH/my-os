[bits 16]

; Set DS register to where we are loaded in memory
mov ax, 0x08C0
mov ds, ax

mov bx, HELLO_WORLD
call print_string

mov dx, 0x1234
call print_hex

mov dx, 0xF96E
call print_hex

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

print_hex:
  mov cx, 4

.loop:
  dec cx

  mov ax, 0xF
  and ax, dx

  cmp ax, 0x9
  jle .insert_char
  add ax, 0x7

.insert_char:
  add ax, '0'

  mov bx, HEX_OUT
  add bx, 2
  add bx, cx

  mov byte[bx], al

  shr dx, 0x4
  cmp cx, 0x0
  jne .loop

  mov bx, HEX_OUT
  call print_string

  ret

; Variables
HELLO_WORLD: db 'Hello World', 0
HEX_OUT: db '0x0000 ', 0

times 512 - ($-$$) db 0;
