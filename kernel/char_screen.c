void clear_line(int line) {
  char* video_memory = (char *) 0xb8000 + line * 80 * 2;
  for (int j = 0; j < 76; j++) {
    *video_memory = ' ';
    video_memory = video_memory + 2;
  }
}

void print_hex(char** video_memory, short value) {
  for (int j = 3; j >= 0; j--) {
    int val = value >> (j * 4);
    val = val & 0xf;

    if (val >= 10) {
      val = val + 7;
    }

    **video_memory = 48 + val;
    *video_memory = (*video_memory) + 2;
  }
}

char* select_line(int line) {
  return (char *) 0xb8000 + line * 80 * 2;
}

void hex_dump(short* addr, int lines) {
  for (int i = 0; i < 16; i++) {
    clear_line(i);

    // Print addr
    char* video_memory = select_line(i);
    print_hex(&video_memory, (int) addr);

    // print space
    *video_memory = ' ';
    video_memory = video_memory + 2;

    for (int j = 0; j < 8; j++) {
      // Print space
      *video_memory = ' ';
      video_memory = video_memory + 2;

      // Print value
      print_hex(&video_memory, *addr);
      addr++;
    }
  }
}