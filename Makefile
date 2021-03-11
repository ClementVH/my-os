BOOTDIR = boot
BUILDDIR = build

BOOTSOURCES = $(wildcard $(BOOTDIR)/**/*.asm)

SOURCEDIR = kernel
SOURCES = $(wildcard $(SOURCEDIR)/*.c)

all: run

$(BUILDDIR)/padding.bin: $(BOOTDIR)/padding.asm
	nasm $< -f bin -o $@

$(BUILDDIR)/boot_sect.bin: $(BOOTSOURCES)
	nasm $(BOOTDIR)/boot_sect.asm -f bin -o $@

$(BUILDDIR)/vesa/read_vesa.bin: $(BOOTSOURCES)
	nasm $(BOOTDIR)/read_vesa.asm -f bin -o $@

$(BUILDDIR)/main.bin: build/main.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 --oformat binary $<

$(BUILDDIR)/main.o: $(SOURCES)
	gcc -fno-pie -ffreestanding -m32 -c $^ -o $@

$(BUILDDIR)/os-image: $(BUILDDIR)/boot_sect.bin $(BUILDDIR)/read_vesa.bin $(BUILDDIR)/main.bin $(BUILDDIR)/padding.bin
	cat $^ > $@

run: $(BUILDDIR)/os-image
	qemu-system-x86_64 -m 2G $<

.PHONY: run