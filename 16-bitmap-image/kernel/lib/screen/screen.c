#include "../../kernel.h"
#include "screen.h"

char clamp_to_screen(int* x, int* y, int* width, int* height) {

  // prevent drawing outside buffer
  if (*x < 0) {
    *width = *width + *x;
    *x = 0;
  }

  if (*x + *width > modeInfo->width) {
    *width = modeInfo->width - *x;
  }

  if (y < 0) {
    *height = *height + *y;
    *y = 0;
  }

  if (*y + *height > modeInfo->height) {
    *height = modeInfo->height - *y;
  }

  if (*width <= 0 || *height <= 0) {
    return 1;
  }

  return 0;
}

void draw_rect(int color, int x, int y, int width, int height) {

  char outside_screen = clamp_to_screen(&x, &y, &width, &height);
  if (outside_screen) {
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

void swap() {
  memcpy(modeInfo->framebuffer, buffer, modeInfo->width * modeInfo->height * 3 / 4);
}
