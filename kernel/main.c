struct VBE_MODE_INFO {
  unsigned short attributes;
  unsigned char window_a;
  unsigned char window_b;
  unsigned short granularity;
  unsigned short window_size;
  unsigned short segment_a;
  unsigned short segment_b;
  unsigned short win_func_ptr_high;
  unsigned short win_func_ptr_low;

  unsigned short pitch;
  unsigned short width;
  unsigned short height;

  unsigned char x_char;
  unsigned char y_char;
  unsigned char planes;

  unsigned char bpp;

  unsigned char banks;
  unsigned char memory_model;
  unsigned char bank_size;
  unsigned char image_pages;
  unsigned char reverved0;

  unsigned char red_mask;
  unsigned char red_position;
  unsigned char green_mask;
  unsigned char green_position;
  unsigned char blue_mask;
  unsigned char blue_position;
  unsigned char reserved_mask;
  unsigned char reserved_position;
  unsigned char direct_color_attributes;

  unsigned int framebuffer;
};

extern void keyboard_handler(void);
extern char read_port(unsigned short port);
extern void write_port(unsigned short port, unsigned char data);
extern void load_idt(unsigned int *idt_ptr);

struct IDT_entry{
  unsigned short offset_low;
  unsigned short segment_selector;
  unsigned char reserved;
  unsigned char attr;
  unsigned short offset_high;
};

extern void* IDT;

void idt_init(void)
{
  unsigned int keyboard_address;
  unsigned int idt_address;
  unsigned int idt_ptr[2];

  struct IDT_entry* IDT_PTR = IDT;

  /* populate IDT entry of keyboard's interrupt */
  // keyboard_address = (unsigned int) keyboard_handler;
  IDT_PTR[0x21].offset_low = (unsigned short)(((unsigned int)keyboard_handler & 0x0000ffff));
  IDT_PTR[0x21].offset_high = (unsigned short)(((unsigned int)keyboard_handler & 0xffff0000) >> 16);
  IDT_PTR[0x21].reserved = 0;
  IDT_PTR[0x21].segment_selector = 0x08;
  IDT_PTR[0x21].attr = 0x8e;

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

  // /* ICW4 - environment info */
  write_port(0x21 , 0x01);
  write_port(0xA1 , 0x01);
  /* Initialization finished */

  /* mask interrupts */
  write_port(0x21 , 0xff);
  write_port(0xA1 , 0xff);

  /* fill the IDT descriptor */
  idt_address = (unsigned int) IDT;
  idt_ptr[0] = (sizeof (struct IDT_entry) * 256) - 1;
  idt_ptr[1] = idt_address;

  load_idt(idt_ptr);
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
