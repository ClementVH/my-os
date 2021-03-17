#include "./main.h"

extern void keyboard_handler(void);
extern char read_port(unsigned short port);
extern void write_port(unsigned short port, unsigned char data);
extern void load_idt(unsigned int idt_ptr);

struct idt_entry {
  unsigned short offset_low;
  unsigned short segment_selector;
  unsigned char reserved;
  unsigned char attr;
  unsigned short offset_high;
} __attribute__((__packed__)) IDT[256];

struct idt_descriptor {
  unsigned short limit;
  unsigned int base;
} __attribute__((__packed__)) IDT_DESCRIPTOR;

void idt_init(void) {
  unsigned int toto = keyboard_handler;
  IDT[0x21].offset_low = (unsigned short)(((unsigned int)&keyboard_handler & 0x0000ffff));
  IDT[0x21].offset_high = (unsigned short)(((unsigned int)&keyboard_handler & 0xffff0000) >> 16);
  IDT[0x21].reserved = 0;
  IDT[0x21].segment_selector = 0x08;
  IDT[0x21].attr = 0x8e;

  /* ICW1 - begin initialization */
  write_port(0x20 , 0x11);
  write_port(0xA0 , 0x11);

  /* ICW2 - remap offset address of IDT */
  /*
  * In x86 protected mode, we have to remap the PICs beyond 0x20 because
  * Intel have designated the first 32 interrupts as "reserved" for cpu exceptions
  */
  write_port(0x21 , 0x20);
  write_port(0xA1 , 0x28);

  /* ICW3 - setup cascading */
  write_port(0x21 , 0x00);
  write_port(0xA1 , 0x00);

  /* ICW4 - environment info */
  write_port(0x21 , 0x01);
  write_port(0xA1 , 0x01);

  /* mask interrupts */
  write_port(0x21 , 0xff);
  write_port(0xA1 , 0xff);

  IDT_DESCRIPTOR.limit = (sizeof (struct idt_entry) * 256) - 1;
  IDT_DESCRIPTOR.base = &IDT;

  load_idt((unsigned int) &IDT_DESCRIPTOR);
  write_port(0x21 , 0xFD);
}

void keyboard_handler_main(void) {
  struct VBE_MODE_INFO* modeInfo = (struct VBE_MODE_INFO*) 0x1800;

  char* framebuffer = (char*) modeInfo->framebuffer;
  for (int x = 350; x < 450; x++) {
    for (int y = 250; y < 350; y ++) {
      int color = 0xFF0000;
      unsigned where = x * 3 + y * 2400;
      framebuffer[where] = color & 255;              // BLUE
      framebuffer[where + 1] = (color >> 8) & 255;   // GREEN
      framebuffer[where + 2] = (color >> 16) & 255;  // RED
    }
  }
}

void main() {
  idt_init();

  struct VBE_MODE_INFO* modeInfo = (struct VBE_MODE_INFO*) 0x1800;

  char* framebuffer = (char*) modeInfo->framebuffer;
  for (int x = 350; x < 450; x++) {
    for (int y = 250; y < 350; y ++) {
      int color = 0xFFFFFF;
      unsigned where = x * 3 + y * 2400;
      framebuffer[where] = color & 255;              // BLUE
      framebuffer[where + 1] = (color >> 8) & 255;   // GREEN
      framebuffer[where + 2] = (color >> 16) & 255;  // RED
    }
  }

}
