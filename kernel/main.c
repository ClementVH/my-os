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

void _start() {
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
