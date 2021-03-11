char = 1 byte



DB = 1 byte = 8 bits
DW = 2 bytes = 16 bits
DD = 4 butes = 32 bits

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
