[bits 16]
section .text
print_hex:
  pusha                   ; store registers on the stack
  mov cx, 0x4             ; init counter to 4

start:
  dec cx                  ; decrement the counter

  mov ax, 0xf             ; 0b1111
  and ax, dx              ; mask ax and dx
                          ; leaving last number of dx in ax

  mov bx, HEX_OUT         ;
  add bx, cx
  add bx, 0x2

  cmp ax, 0xa
  jl insert
  add ax, 0x7

insert:
  mov byte [bx], '0'
  add byte [bx], al

  shr dx, 0x4

  cmp dx, 0
  je done

  jmp start

done:
  mov bx, HEX_OUT
  call print_string

  popa
  ret

section .data
HEX_OUT: db '0x0000 ', 0