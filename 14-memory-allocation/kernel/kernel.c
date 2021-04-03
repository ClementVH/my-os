#include "kernel.h"

extern char inb(unsigned short port);
extern void* memcpy(void* dest, void* src, unsigned int);

char* buffer = (char*) 0xA00000;

void draw();
void swap();

void main() {
  pos->x = 0;
  pos->y = 0;
  controls->top = 0;
  controls->right = 0;
  controls->bottom = 0;
  controls->left = 0;

  while(1) {
    draw();
    swap();
  }
}

void draw_rect(int color, int x, int y, int width, int height) {
  struct VBE_MODE_INFO* modeInfo = (struct VBE_MODE_INFO*) 0x1C00;

  // Start at the top left corner of the rectangle
  char* first_row = (char*) (3 * (x + y * modeInfo->width) + buffer);

  // Draw first row
  char* current_column = first_row;
  for (int j = x; j < x + width; j++) {
    *(current_column) = color & 255;              // BLUE
    *(current_column + 1) = (color >> 8) & 255;   // GREEN
    *(current_column + 2) = (color >> 16) & 255;  // RED
    // Move to next column
    current_column += 3;
  }

  char* current_row = first_row;
  for (int i = 0; i < width; i++) {
    memcpy(current_row, first_row, width * 3 / 4);
    current_row += 3 * modeInfo->width;
  }
}

void draw() {
  struct VBE_MODE_INFO* modeInfo = (struct VBE_MODE_INFO*) 0x1C00;
  draw_rect(0x000000, 0, 0, modeInfo->width, modeInfo->height);
  draw_rect(0xFFFFFF, pos->x, pos->y, 100, 100);
}

void swap() {
  struct VBE_MODE_INFO* modeInfo = (struct VBE_MODE_INFO*) 0x1C00;
  memcpy(modeInfo->framebuffer, buffer, modeInfo->width * modeInfo->height * 3 / 4);
}

void pit_loop() {
  if (controls->left) {
    pos->x-=10;
  }
  if (controls->right) {
    pos->x+=10;
  }
  if (controls->top) {
    pos->y-=10;
  }
  if (controls->bottom) {
    pos->y+=10;
  }
}

void handle_keyboard() {
  short status = inb(0x64);
  short code = inb(0x60);
  char pressed = 1;

  if ((code & 128) == 128) {
    pressed = 0;
    code = code & 0x7F;
  }

  switch (code) {
    case 75:
      controls->left = pressed;
      break;
    case 77:
      controls->right = pressed;
      break;
    case 72:
      controls->top = pressed;
      break;
    case 80:
      controls->bottom = pressed;
      break;
    default:
      break;
  }
}
