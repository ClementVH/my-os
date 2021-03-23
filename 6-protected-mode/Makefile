BUILDDIR = build
SOURCES = $(wildcard *.asm)
OBJ = $(patsubst %.asm,build/%.o,$(SOURCES))

all: clean build
	qemu-system-x86_64 $(BUILDDIR)/os-image.bin

build: $(BUILDDIR)/os-image.bin

clean:
	-rm build/*

# MAIN #
$(BUILDDIR)/%.o: %.asm
	nasm $^ -o $@ -f bin

$(BUILDDIR)/%.bin: $(BUILDDIR)/boot.o $(BUILDDIR)/main.o
	cat $^ > $@
	truncate -s 3k $@
