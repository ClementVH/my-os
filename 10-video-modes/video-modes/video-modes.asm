[bits 16]
section .text

mov bx, VBE_INFO_LABELS           ; load_vesa_bios_info to memory addr VBE_INFO_LABELS
mov di, bx                        ; ES:DI buffer location for vesa info
mov ax, 0x4f00                    ; function load_vesa_bios_info
int 0x10                          ; interrupt call

cmp ax, 0x004f                    ; on success ax should be 0x004f
jne error                         ; if success jump to success

load_video_modes:
  mov ax, [VIDEO_MODES_OFFSET]    ; Save offset value
  mov [VM_OFFSET], ax
  mov ax, [VIDEO_MODES_SEGMENT]   ; Save segment value
  mov [VM_SEGMENT], ax

  print_mode:
    mov ax, [VM_SEGMENT]          ; Load segment in fs
    mov fs, ax
    mov si, [VM_OFFSET]           ; Load offset in si

    mov dx, [fs:si]               ; Load value at segment:offset in dx
    add si, 2
    mov [VM_OFFSET], si           ; Increment offset
    mov [VM_MODE], dx             ; Save mode
    ; call print_hex                ; Print mode number

    mov ax, 0x4f01
    mov di, VBE_MODE_INFO_LABELS
    mov cx, [VM_MODE]
    int 0x10                      ; Load mode infos at VBE_MODE_INFO_LABELS

    cmp ax, 0x004f
    jne error                     ; Check for success code in ax

    cmp word[VM_MODE], 0x115      ; 800x600x24
    jne print_mode                ; Stop abritrarily at mode 0x115

    mov ax, 0x4F02
    mov bx, [VM_MODE]
    or bx, 0x4000                 ; Enable LFB
    mov di, 0
    int 0x10                      ; Switch to video mode 0x115

    cmp ax, 0x4F
    jne error                     ; Check error

end:
  ret

error:
  mov bx, ERROR_VBE
  call print_string
  jmp $                         ; Error !

ERROR_VBE: db "Error VBE", 0
VESA_INFO_SUCCESS: db "VESA INFO SUCCESS", 0
NEW_LINE: db 0xa, 0xd, 0
VERSION: db "VERSION: ", 0
VIDEO_MODES_STR: db "VIDEO MODES: ", 0
COLON: db ":", 0

VM_SEGMENT: dw 0
VM_OFFSET: dw 0
VM_MODE: dw 0
VM_MODE_PITCH: dw 0
VM_MODE_WIDTH: dw 0
VM_MODE_HEIGHT: dw 0

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

%include "lib/print-hex.asm"

section .mode-infos

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
