[bits 16]

; set DS register to where we are loaded in memory
mov ax, 0x07C0
mov ds, ax

mov [BOOT_DRIVE], dl        ; BIOS stores the boot drive in dl

mov ax, 0x08C0              ; Load sectors to '0x08C0:0x0000'
mov es, ax
mov bx, 0x0000

mov ah, 0x02                ; Select function 'Read sectors'
mov al, 0x01                ; Read 1 sector
mov ch, 0x00                ; Select cylinder 0
mov cl, 0x02                ; Select sector 2
mov dh, 0x00                ; Select head 0

int 0x13                    ; Call interrupt 'disk load'

jmp 0x08C0:0x0000           ; Far jump

; Variables
BOOT_DRIVE: db 1

times 510 - ($-$$) db 0;
dw 0xaa55
