BUILDDIR = build
SOURCES = $(wildcard *.asm)
OBJ = $(patsubst %.asm,build/%.bin,$(SOURCES))

all: $(BUILDDIR)/video-modes.img

# BOOT #
$(BUILDDIR)/%.bin: %.asm
	nasm $^ -o $@ -f elf32

$(BUILDDIR)/%.elf: linker.ld $(OBJ)
	ld -melf_i386 --build-id=none -o $@ -T $^

$(BUILDDIR)/%.img: $(BUILDDIR)/%.elf
	objcopy -O binary $^ $@
