BUILDDIR = build
SOURCES = $(wildcard *.asm)
OBJ = $(patsubst %.asm,build/%.o,$(SOURCES))

all: clean build
	qemu-system-x86_64 $(BUILDDIR)/os-image.img

build: $(BUILDDIR)/os-image.img

clean:
	mkdir -p build
	-@rm build/* 2>/dev/null || true

# KERNEL #
$(BUILDDIR)/%.o: %.c
	gcc -fno-pie -ffreestanding -m32 -c $^ -o $@

# KERNEL_ENTRY #
$(BUILDDIR)/kernel_entry.o: kernel_entry.asm
	nasm $^ -f elf -o $@

# MAIN #
$(BUILDDIR)/main.bin: $(BUILDDIR)/kernel_entry.o $(BUILDDIR)/kernel.o
	ld -m elf_i386 -o $@ -Ttext 0x2000 --oformat binary $^

# BOOT #
$(BUILDDIR)/%.bin: %.asm
	nasm $^ -o $@ -f bin

# IMAGE #
$(BUILDDIR)/%.img: $(BUILDDIR)/boot.bin $(BUILDDIR)/main.bin
	cat $^ > $@
	truncate -s 3k $@
