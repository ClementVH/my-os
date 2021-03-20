[bits 16]
section .boottext

mov bp, 0x9000              ; Setup the stack
mov sp, bp

mov al, 'S'
mov ah, 0x0e
int 0x10

mov bx, 0x1000        ; load vesa info sectors to memory addr 0x1000
mov dh, 10                  ; load 10 sectors
mov cl, 0x02                ; start from sector 2 (exclude 1st sector ie: boot sector)
call disk_load              ; call disk load routine[bits 16]

call 0x1000

mov al, 'E'
mov ah, 0x0e
int 0x10

jmp $

%include "lib/disk_load.asm"
%include "lib/print_string.asm"

; Variables
BOOT_DRIVE: db 1
