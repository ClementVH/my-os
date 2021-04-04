#include "memory.h"

#define START_ADDR 0x100000

int next_addr = START_ADDR;

void* malloc(int size) {
  int addr = next_addr;
  next_addr += size;
  return (void*) addr;
}
