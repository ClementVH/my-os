BOOTDIR = boot
BUILDDIR = build

all: $(BUILDDIR)/os-image.bin
	qemu-system-x86_64 $<

build: clean $(BUILDDIR)/os-image.bin

clean:
	-rm build/*

BOOTSOURCES = $(wildcard $(BOOTDIR)/**/*.asm) $(wildcard $(BOOTDIR)/*.asm)

# BOOT SECTOR #
$(BUILDDIR)/boot_sect.o: $(BOOTSOURCES)
	nasm $(BOOTDIR)/boot_sect.asm -o $@ -f elf32

$(BUILDDIR)/boot_sect.elf: $(BOOTDIR)/boot.ld $(BUILDDIR)/boot_sect.o
	ld -melf_i386 --build-id=none -o $@ -T $^

$(BUILDDIR)/boot_sect.bin: $(BUILDDIR)/boot_sect.elf
	objcopy -O binary $^ $@

# VESA #
$(BUILDDIR)/read_vesa.o: $(BOOTSOURCES)
	nasm $(BOOTDIR)/vesa/read_vesa.asm -o $@ -f elf32

$(BUILDDIR)/read_vesa.elf: $(BOOTDIR)/vesa/vesa.ld $(BUILDDIR)/read_vesa.o
	ld -melf_i386 --build-id=none -o $@ -T $^

$(BUILDDIR)/read_vesa.bin: $(BUILDDIR)/read_vesa.elf
	objcopy -O binary $^ $@

# OS-IMAGE #
$(BUILDDIR)/os-image.bin: $(BUILDDIR)/boot_sect.bin $(BUILDDIR)/read_vesa.bin
	cat $^ > $@
