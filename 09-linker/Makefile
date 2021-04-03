BUILDDIR = build

all: $(BUILDDIR)/os-image.img
	qemu-system-x86_64 $(BUILDDIR)/os-image.img

# IMAGE #
$(BUILDDIR)/%.img: bootloader kernel
	cat bootloader/build/bootloader.img kernel/build/kernel.img > $@
	truncate -s 1m $@

bootloader:
	make -C bootloader

kernel:
	make -C kernel

.PHONY: bootloader kernel
