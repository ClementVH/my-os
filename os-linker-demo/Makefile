BUILDDIR = build
SOURCES = $(wildcard *.asm)
OBJ = $(patsubst %.asm,build/%.o,$(SOURCES))

all: $(BUILDDIR)/os-image.bin
	qemu-system-x86_64 $<

build: $(BUILDDIR)/os-image.bin

# MAIN #
$(BUILDDIR)/%.o: %.asm
	nasm $^ -o $@ -f elf32

# OS-IMAGE #
$(BUILDDIR)/%.elf: linker.ld $(OBJ)
	ld -melf_i386 --build-id=none -o $@ -T $^

$(BUILDDIR)/%.bin: $(BUILDDIR)/%.elf
	objcopy -O binary $^ $@
