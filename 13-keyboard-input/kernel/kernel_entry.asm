[bits 32]
[extern main]
[extern handle_keyboard]
[extern pit_loop]
section .text

mov edx, 0x20
mov al, 0x11
out dx, al
mov edx, 0xA0
mov al, 0x11
out dx, al

mov edx, 0x21
mov al, 0x20
out dx, al
mov edx, 0xA1
mov al, 0x28
out dx, al

mov edx, 0x21
mov al, 0x00
out dx, al
mov edx, 0xA1
mov al, 0x00
out dx, al

mov edx, 0x21
mov al, 0x01
out dx, al
mov edx, 0xA1
mov al, 0x01
out dx, al

mov edx, 0x21
mov al, 0xff
out dx, al
mov edx, 0xA1
mov al, 0xff
out dx, al

lidt [idt_descriptor]
sti

mov edx, 0x21
mov al, 0xFC
out dx, al

call main

jmp $

isr33:
	pusha

  in al, 0x64
  in al, 0x60
  call handle_keyboard

	popa
  mov edx, 0x20
  mov al, 0x20
  out dx, al
	iret

isr32:
  call pit_loop
  mov edx, 0x20
  mov al, 0x20
  out dx, al
  iret

global memcpy
memcpy:
  mov edi, [esp + 4]
  mov esi, [esp + 4 + 4]
  mov ecx, [esp + 4 + 4 + 4]
  cld
  rep movsd
  ret




; isr33:
; 	pusha			; Pushes edi, esi, ebp, esp, ebx, edx, ecx, eax

;   ; mov ax, ds		; Lower 16 bits of eax = ds.
; 	; push eax		; save the data segment descriptor

; 	; mov ax, 0x10		; load the kernel data segment descriptor.
; 	; mov ds, ax
; 	; mov es, ax
; 	; mov fs, ax
; 	; mov gs, ax

; 	call handle_keyboard

; 	; pop ebx			; reload the original data segment descriptor
; 	; mov ds, bx
; 	; mov es, bx
; 	; mov fs, bx
; 	; mov gs, bx

; 	popa			    ; Pops edi, esi, ebp, esp, ebx, edx, ecx, eax
; 	add esp, 8		; Cleans up the pushed error code and pushed IRS number
;   ; sti
; 	iret			    ; pops 5 things at once: CS, EIP, EFLAGS, SS, and ESP

; isr33:
;   pusha

;   ; mov ax, ds		; Lower 16 bits of eax = ds.
; 	; push eax		; save the data segment descriptor

; 	; mov ax, 0x10		; load the kernel data segment descriptor.
; 	; mov ds, ax
; 	; mov es, ax
; 	; mov fs, ax
; 	; mov gs, ax


;   in al, 0x64
;   in al, 0x60
;   call handle_keyboard

; 	; pop ebx			; reload the original data segment descriptor
; 	; mov ds, bx
; 	; mov es, bx
; 	; mov fs, bx
; 	; mov gs, bx

;   popa
;   ; add esp, 8
;   ; sti
;   iretd

%include "lib/idt.asm"
