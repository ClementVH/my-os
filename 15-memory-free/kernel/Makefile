BUILDDIR = build
OBJ_ASM = $(patsubst %.asm,build/%.bin,$(wildcard *.asm))
OBJ_C = $(patsubst %.c,build/%.bin,$(wildcard *.c))
SRC = $(shell find . -name '*.c')

all: $(BUILDDIR)/kernel.img

# BOOT #
$(BUILDDIR)/%.bin: %.asm
	nasm $^ -o $@ -f elf32

# KERNEL #
$(BUILDDIR)/%.bin: %.c $(SRC)
	gcc -fno-pie -ffreestanding -m32 -c $< -o $@

$(BUILDDIR)/%.elf: linker.ld $(OBJ_ASM) $(OBJ_C)
	ld -melf_i386 --build-id=none -o $@ -T $^

$(BUILDDIR)/%.img: $(BUILDDIR)/%.elf
	objcopy -O binary $^ $@
