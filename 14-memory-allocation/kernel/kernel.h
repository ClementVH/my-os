#pragma once

struct Position {
  int x;
  int y;
};

struct Position* pos = (struct Position*) 0x5000;

struct Controls {
  char top;
  char right;
  char bottom;
  char left;
};

struct Controls* controls = (struct Controls*) 0x6000;

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