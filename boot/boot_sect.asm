[bits 16]
section .text
  ; mov ax, 0x0
  ; mov cs, ax
  ; mov ds, ax
  ; mov ss, ax

  mov al, 'F'
  mov ah, 0x0e
  int 0x10

  mov [BOOT_DRIVE], dl        ; BIOS stores the boot drive in dl

  mov bp, 0x9000              ; Setup the stack
  mov sp, bp

  mov bx, MSG_REAL_MODE
  call print_string           ; print MSG_REAL_MODE

  mov bx, 0x1000              ; load vesa info sectors to memory addr 0x1000
  mov dh, 10                  ; load 10 sectors
  mov cl, 0x02                ; start from sector 2 (exclude 1st sector ie: boot sector)
  call disk_load              ; call disk load routine

  ; mov ax, 0x0
  ; mov ds, ax
  ; call [ds:0x8c00]

  mov dx, 0xFACE
  call print_hex

  mov al, 'F'
  mov ah, 0x0e
  int 0x10

  jmp $

; KERNEL_OFFSET equ 0x2800
; load_kernel:
;   mov bx, NEW_LINE
;   call print_string           ; print new line

;   mov bx, MSG_LOAD_KERNEL     ; Print a message to say we are loading the kernel
;   call  print_string

;   mov bx, KERNEL_OFFSET       ; Load kernel at memory addr KERNEL_OFFSET ( 0x1000 )
;   mov dh, 15                  ; read 15 sectors
;   mov cl, 0x06                ; read from sector 4 ( exclude boot sector & vbe info sector )
;   call  disk_load             ; call disk_load routine

;   call switch_to_pm           ; Switch to protected mode

;   jmp $                       ; Never return

%include "boot/disk/disk_load.asm"
%include "boot/print/print_string.asm"
%include "boot/print/print_hex.asm"
; %include "boot/print/print_string_pm.asm"
; %include "boot/protected-mode/gdt.asm"
; %include "boot/protected-mode/switch_to_pm.asm"

; [bits 32]
; ; Arrive here after switching and initializing pm
; BEGIN_PM:
;   mov ebx, MSG_PROT_MODE
;   call print_string_pm        ; print success protected mode message

;   call KERNEL_OFFSET          ; call kernel entry point

;   jmp $                       ; hang

[bits 16]
section .data
BOOT_DRIVE: db 1
HELLO: db "Hello", 0
MSG_REAL_MODE: db "Started  in 16-bit  Real  Mode", 0
MSG_PROT_MODE: db "Successfully  landed  in 32-bit  Protected  Mode", 0
MSG_LOAD_KERNEL:  db "Loading  kernel  into  memory.", 0
NEW_LINE: db 0xa, 0xd, 0

; times 510-($-$$) db 0

; dw 0xaa55
