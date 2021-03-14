char = 1 byte

DB = 1 byte = 8 bits => 0xFF = 0b1111|1111
DW = 2 bytes = 16 bits => 0xFFFF = 0b1111|1111|1111|1111
DD = 4 butes = 32 bits => 0xFFFFFFFF = 0b1111|1111|1111|1111|1111|1111|1111|1111

struct vbe_info_structure {
   char[4] signature = "VESA";   // must be "VESA" to indicate valid VBE support
   uint16 version;         // VBE version; high byte is major version, low byte is minor version
   uint32 oem;         // segment:offset pointer to OEM
   uint32 capabilities;      // bitfield that describes card capabilities
   uint32 video_modes;      // segment:offset pointer to list of supported video modes
   uint16 video_memory;      // amount of video memory in 64KB blocks
   uint16 software_rev;      // software revision
   uint32 vendor;         // segment:offset to card vendor string
   uint32 product_name;      // segment:offset to card model name
   uint32 product_rev;      // segment:offset pointer to product revision
   char reserved[222];      // reserved for future expansion
   char oem_data[256];      // OEM BIOSes store their strings in this area
} __attribute__ ((packed));# my-os

struct vbe_mode_info_structure {
	uint16 attributes;		// deprecated, only bit 7 should be of interest to you, and it indicates the mode supports a linear frame buffer.
	uint8 window_a;			// deprecated
	uint8 window_b;			// deprecated
	uint16 granularity;		// deprecated; used while calculating bank numbers
	uint16 window_size;
	uint16 segment_a;
	uint16 segment_b;
	uint32 win_func_ptr;		// deprecated; used to switch banks from protected mode without returning to real mode
	uint16 pitch;			// number of bytes per horizontal line
	uint16 width;			// width in pixels
	uint16 height;			// height in pixels
	uint8 w_char;			// unused...
	uint8 y_char;			// ...
	uint8 planes;
	uint8 bpp;			// bits per pixel in this mode
	uint8 banks;			// deprecated; total number of banks in this mode
	uint8 memory_model;
	uint8 bank_size;		// deprecated; size of a bank, almost always 64 KB but may be 16 KB...
	uint8 image_pages;
	uint8 reserved0;

	uint8 red_mask;
	uint8 red_position;
	uint8 green_mask;
	uint8 green_position;
	uint8 blue_mask;
	uint8 blue_position;
	uint8 reserved_mask;
	uint8 reserved_position;
	uint8 direct_color_attributes;

	uint32 framebuffer;		// physical address of the linear frame buffer; write here to draw to the screen
	uint32 off_screen_mem_off;
	uint16 off_screen_mem_size;	// size of memory in the framebuffer but not being displayed on the screen
	uint8 reserved1[206];
} __attribute__ ((packed));




; SHARE data to kernel
mov edi, 0x100000
mov byte eax, [0x1400]
stosd   ; Put whats in eax at edi