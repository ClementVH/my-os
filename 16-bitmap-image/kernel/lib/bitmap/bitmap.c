#include "../../kernel.h"
#include "bitmap.h"

struct BitmapHeader {
  unsigned short header_field;
  uint size;
  uint reserved;
  uint pixel_array_offset;
} __attribute__((__packed__));

extern struct BitmapHeader _binary_strawberry_bmp_start;

struct BitmapInfoHeader {
  int size;
  int width;
  int height;
  short color_planes;
  short bpp;
} __attribute__((__packed__));

void bitmap_draw(int x, int y) {
  struct BitmapInfoHeader* info_header = (uint) (&_binary_strawberry_bmp_start) + 0x0E;

  int width = info_header->width;
  int height = info_header->height;

  char outside_screen = clamp_to_screen(&x, &y, &width, &height);
  if (outside_screen) {
    return;
  }

  uint pixel_array_offset = (uint) (&_binary_strawberry_bmp_start) + _binary_strawberry_bmp_start.pixel_array_offset;
  // Begining of last row
  char* current_image_row = (char*) (pixel_array_offset + 3 * width * height - width * 3);
  // Begining of first row
  char* current_buffer_row = (char*) (3 * (x + y * modeInfo->width) + buffer);

  for (int i = 0; i < height; i++) {
    memcpy(current_buffer_row, current_image_row, width * 3 / 4);
    current_buffer_row += 3 * modeInfo->width;
    current_image_row -= 3 * width;
  }

}