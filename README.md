char = 1 byte

DB = 1 byte = 8 bits => 0xFF = 0b1111|1111
DW = 2 bytes = 16 bits => 0xFFFF = 0b1111|1111|1111|1111
DD = 4 butes = 32 bits => 0xFFFFFFFF = 0b1111|1111|1111|1111|1111|1111|1111|1111

; SHARE data to kernel
mov edi, 0x100000
mov byte eax, [0x1400]
stosd   ; Put whats in eax at edi

dd if=build/os-image of=image.img bs=512 count=2K
echo "c" | bochs -f .bochsrc