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

  mov bx, VBE_INFO_LABELS
  call print_string           ; print string at start of vesa_bios_info buffer ( VESA )

  mov bx, NEW_LINE
  call print_string           ; print new line

  mov bx, VERSION
  call print_string           ; print "VERSION: "

  mov dx, [VESA_VERSION]
  call print_hex              ; version (3.0)

  mov bx, NEW_LINE
  call print_string           ; print new line

  mov bx, VIDEO_MODES_STR
  call print_string

  mov ax, [VIDEO_MODES_OFFSET]
  mov [VM_OFFSET], ax
  mov ax, [VIDEO_MODES_SEGMENT]
  mov [VM_SEGMENT], ax

  mov dx, [VM_SEGMENT]
  call print_hex

  print_mode:
    mov ax, [VM_SEGMENT]
    mov fs, ax
    mov si, [VM_OFFSET]

    mov dx, [fs:si]
    add si, 2
    mov [VM_OFFSET], si
    mov [VM_MODE], dx
    mov ax, 0
    mov fs, ax
    call print_hex

    mov ax, 0x4f01
    mov di, VBE_MODE_INFO_LABELS
    mov cx, [VM_MODE]
    int 0x10

    cmp ax, 0x004f
    je load_vbe_mode_info_success

    mov bx, ERROR_VBE
    call print_string

  load_vbe_mode_info_success:

    mov dx, [WIDTH]
    call print_hex              ; version (3.0)

    mov dx, [HEIGHT]
    call print_hex              ; version (3.0)

    cmp word[VM_MODE], 0x0115
    jne print_mode

    push es
    mov ax, 0x4F02
    mov bx, [VM_MODE]
    or bx, 0x4000      ; enable LFB
    mov di, 0
    int 0x10
    pop es

    cmp ax, 0x4F
    jne .error

  popa
  ret

  .error
    mov bx, ERROR_VBE
    call print_string
    jmp $

%include "boot/print/print_string.asm"
%include "boot/print/print_hex.asm"

ERROR_VBE: db "Error VBE", 0
VESA_INFO_SUCCESS: db "VESA INFO SUCCESS", 0
NEW_LINE: db 0xa, 0xd, 0
VERSION: db "VERSION: ", 0
VIDEO_MODES_STR: db "VIDEO MODES: ", 0
COLON: db ":", 0

times 1024-($-load_vesa_bios_info) db 0

; 0x1400
VBE_INFO_LABELS:
  SIGNATURE: db "VBE2"
  VESA_VERSION: dw 0
  OEM_SEGMENT: dw 0
  OEM_OFFSET: dw 0
  OEM_CAPABILITIES_HIGH: dw 0
  OEM_CAPABILITIES_LOW: dw 0
  VIDEO_MODES_OFFSET: dw 0
  VIDEO_MODES_SEGMENT: dw 0
  VIDEO_MEMORY: dw 0
  SOFTWARE_REVISION: dw 0
  VENDOR_SEGMENT: dw 0
  VENDOR_OFFSET: dw 0
  PRODUCT_NAME_SEGMENT: dw 0
  PRODUCT_NAME_OFFSET: dw 0
  PRODUCT_REVISION_SEGMENT: dw 0
  PRODUCT_REVISION_OFFSET: dw 0
  .RESERVED: resb 512-($-VBE_INFO_LABELS)

times 1024-($-VBE_INFO_LABELS) db 0

; 0x1800

VBE_MODE_INFO_LABELS:
  ATTRIBUTES: dw 0
  WINDOW_A: db 0
  WINDOW_B: db 0
  GRANULARITY: dw 0
  WINDOW_SIZE: dw 0
  SEGMENT_A: dw 0
  SEGMENT_B: dw 0
  WIN_FUNC_PTR_HIGH: dw 0
  WIN_FUNC_PTR_LOW: dw 0
  PITCH: dw 0
  WIDTH: dw 0
  HEIGHT: dw 0
  W_CHAR: db 0
  Y_CHAR: db 0
  PLANES: db 0
  BPP: db 0
  .RESERVED: resb 512-($-VBE_MODE_INFO_LABELS)

VM_SEGMENT: dw 0
VM_OFFSET: dw 0
VM_MODE: dw 0
VM_MODE_PITCH: dw 0
VM_MODE_WIDTH: dw 0
VM_MODE_HEIGHT: dw 0

times 3072-($-VM_SEGMENT) db 0
