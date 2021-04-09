#include "bitmap.h"

struct BitmapHeader {
  unsigned short header_field;
  uint size;
  uint reserved;
  uint pixel_array_offset;
} __attribute__((__packed__));

extern struct BitmapHeader _binary_strawberry_bmp_start;

int bitmap_draw() {

  int color = 0XFFFFFF;
  if (_binary_strawberry_bmp_start.header_field == (unsigned short) 0x4D42) {
    color = 0xFF0000;
  }
  return color;

}