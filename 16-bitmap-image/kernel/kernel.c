#include "kernel.h"
#include "lib/idt/idt.c"
#include "lib/memory/memory.c"
#include "lib/bitmap/bitmap.c"

void main() {
  idt_start[32].addr_low    =   (unsigned short) (((uint) isr32 & 0x0000FFFF));
  idt_start[32].addr_high   =   (unsigned short) (((uint) isr32 & 0xFFFF0000) >> 16);
  idt_start[33].addr_low    =   (unsigned short) (((uint) isr33 & 0x0000FFFF));
  idt_start[33].addr_high   =   (unsigned short) (((uint) isr33 & 0xFFFF0000) >> 16);

  load_idt();

  buffer = (char*) malloc((uint) sizeof(char) * (uint) modeInfo->width * (uint) modeInfo->height * (uint) 3);
  pos = (struct Position*) malloc((uint) sizeof(struct Position));
  controls = (struct Controls*) malloc((uint) sizeof(struct Controls));

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

  // prevent drawing outside buffer
  if (x < 0) {
    width = width + x;
    x = 0;
  }

  if (x + width > modeInfo->width) {
    width = modeInfo->width - x;
  }

  if (y < 0) {
    height = height + y;
    y = 0;
  }

  if (y + height > modeInfo->height) {
    height = modeInfo->height - y;
  }

  if (width <= 0 || height <= 0) {
    return;
  }

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
  for (int i = 0; i < height; i++) {
    memcpy(current_row, first_row, width * 3 / 4);
    current_row += 3 * modeInfo->width;
  }
}

void draw() {
  int color = bitmap_draw();
  draw_rect(0x000000, 0, 0, modeInfo->width, modeInfo->height);
  draw_rect(color, pos->x, pos->y, 100, 100);
}

void swap() {
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
  if (status & 0x01) {
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
}
