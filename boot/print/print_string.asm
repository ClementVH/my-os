[bits 16]
section .text
print_char:
  pusha
  mov ah, 0x0e
  int 0x10
  popa
  ret

print_string:
  pusha

begin:
  mov al, [bx]

  cmp al, 0
  je end

  call print_char

  add bx, 1

  jmp begin

end:
  popa
  ret
