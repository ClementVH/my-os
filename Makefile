BOOTDIR = boot
BUILDDIR = build

BOOTSOURCES = $(wildcard $(BOOTDIR)/**/*.asm) $(wildcard $(BOOTDIR)/*.asm)

SOURCEDIR = kernel
SOURCES = $(wildcard $(SOURCEDIR)/*.c)

all: run
build: $(BUILDDIR)/os.img

$(BUILDDIR)/padding.bin: $(BOOTDIR)/padding.asm
	nasm $< -f bin -o $@

$(BUILDDIR)/boot_sect.bin: $(BOOTSOURCES)
	nasm $(BOOTDIR)/boot_sect.asm -f bin -o $@

$(BUILDDIR)/read_vesa.bin: $(BOOTSOURCES)
	nasm $(BOOTDIR)/vesa/read_vesa.asm -f bin -o $@

$(BUILDDIR)/main.bin: $(BUILDDIR)/kernel_entry.o $(BUILDDIR)/main.o
	ld -m elf_i386 -o $@ -Ttext 0x2800 --oformat binary $^
	ld -m elf_i386 -o $(BUILDDIR)/main.elf -Ttext 0x2800 $^

$(BUILDDIR)/main.o: $(SOURCEDIR)/main.c
	gcc -fno-pie -ggdb -O0 -ffreestanding -m32 -c $^ -o $@

$(BUILDDIR)/os-image: $(BUILDDIR)/boot_sect.bin $(BUILDDIR)/read_vesa.bin $(BUILDDIR)/main.bin $(BUILDDIR)/padding.bin
	cat $^ > $@

$(BUILDDIR)/kernel_entry.o: $(BOOTDIR)/kernel_entry.asm
	nasm $< -f elf -o $@

$(BUILDDIR)/os.img: $(BUILDDIR)/os-image
	dd if=$< of=$@ bs=512 count=500K

run: build
	qemu-system-i386 \
		-m	 4m \
		-d int \
		-no-shutdown -no-reboot \
		build/os.img

clean:
	rm build/*

.PHONY: run clean