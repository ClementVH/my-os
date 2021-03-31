#include "kernel.h"

struct Position {
  int x;
  int y;
};

struct Position* pos = (struct Position*) 0x5000;

void main() {
  pos->x = 0;
  pos->y = 0;
}

void draw_rect(int color, int x, int y, int width, int height) {
  struct VBE_MODE_INFO* modeInfo = (struct VBE_MODE_INFO*) 0x1C00;

  // Start at the top left corner of the rectangle
  char* begin_row = 3 * (x + y * modeInfo->width) + modeInfo->framebuffer;

  for (int i = y; i < y + height; i ++) {
    char* current_column = begin_row;
    for (int j = x; j < x + width; j++) {
      *(current_column) = color & 255;              // BLUE
      *(current_column + 1) = (color >> 8) & 255;   // GREEN
      *(current_column + 2) = (color >> 16) & 255;  // RED
      // Move to next column
      current_column += 3;
    }
    // Move to next row
    begin_row += 3 * modeInfo->width;
  }
}

void pit_loop() {
  struct VBE_MODE_INFO* modeInfo = (struct VBE_MODE_INFO*) 0x1C00;
  draw_rect(0x000000, 0, 0, modeInfo->width, modeInfo->height);
  draw_rect(0xFFFFFF, pos->x, pos->x, 100, 100);

  pos->x++;
  pos->y++;
}
