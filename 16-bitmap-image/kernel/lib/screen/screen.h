#ifndef SCREEN
#define SCREEN

char clamp_to_screen(int* x, int* y, int* width, int* height);
void draw_rect(int color, int x, int y, int width, int height);
void swap();

#endif