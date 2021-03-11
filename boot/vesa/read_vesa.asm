[org 0x1000]

load_vesa_bios_info:
  pusha

  mov bx, 0x1400              ; load_vesa_bios_info to memory addr 0x1000 ( where we loaded the previous sector )
  mov di, bx                  ; ES:DI buffer location for vesa info
  mov ax, 0x4f00              ; function load_vesa_bios_info
  int 0x10                    ; interrupt call

  cmp ax, 0x004f              ; on success 0x should be 0x004f
  je load_vesa_info_success   ; if success jump to success

  mov bx, ERROR_VBE
  call print_string           ; print error message

load_vesa_info_success:
  mov bx, NEW_LINE
  call print_string           ; print new line

  mov bx, 0x1400
  call print_string           ; print string at start of vesa_bios_info buffer ( VESA )

  mov bx, NEW_LINE
  call print_string           ; print new line

  mov bx, VERSION
  call print_string           ; print "VERSION: "

  mov dx, [0x1404]
  call print_hex              ; version (3.0)

  mov bx, NEW_LINE
  call print_string           ; print new line

  popa
  ret

%include "boot/print/print_string.asm"
%include "boot/print/print_hex.asm"

ERROR_VBE: db "Error VBE", 0
VESA_INFO_SUCCESS: db "VESA INFO SUCCESS", 0
NEW_LINE: db 0xa, 0xd, 0
VERSION: db "VERSION: ", 0

times 1024-($-load_vesa_bios_info) db 0

vbe_info_structure:
  signature: db "VBE2"      ; indicate support for VBE 2.0+
  table_data: resb 512-4    ; reserve space for the table below

times 1024-($-vbe_info_structure) db 0

