BUILDDIR = build
SOURCES = $(wildcard *.asm)
OBJ = $(patsubst %.asm,build/%.o,$(SOURCES))

all: clean build
	qemu-system-x86_64 $(BUILDDIR)/os-image.img

build: $(BUILDDIR)/os-image.img

clean:
	mkdir -p build
	-@rm build/* 2>/dev/null || true

# MAIN #
$(BUILDDIR)/%.bin: %.asm
	nasm $^ -o $@ -f bin

$(BUILDDIR)/%.img: $(BUILDDIR)/boot.bin $(BUILDDIR)/main.bin
	cat $^ > $@
	truncate -s 3k $@
