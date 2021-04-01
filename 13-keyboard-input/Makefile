BUILDDIR = build

all: $(BUILDDIR)/os-image.img
	qemu-system-x86_64 -m 1G $(BUILDDIR)/os-image.img

# IMAGE #
$(BUILDDIR)/%.img: bootloader kernel video-modes
	cat bootloader/build/bootloader.img \
		video-modes/build/video-modes.img \
		kernel/build/kernel.img \
		> $@
	truncate -s 1m $@

bootloader:
	make -C bootloader

kernel:
	make -C kernel

video-modes:
	make -C video-modes

.PHONY: bootloader kernel video-modes
