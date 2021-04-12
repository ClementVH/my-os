#include "../../kernel.h"
#include "memory.h"
#define START_ADDR 0x100000

struct MemoryBlock {
  uint size;
  unsigned char free;
  struct MemoryBlock* next_block;
} __attribute__((__packed__));

struct MemoryBlock* end_block = (struct MemoryBlock*) START_ADDR;

void* malloc(size_t size) {
  // Start at the begining of the addr space
  struct MemoryBlock* current_block = (struct MemoryBlock*) START_ADDR;

  // Loop through memory blocks
  while (1) {
    // We have reached the end, stop
    if (current_block == end_block) {
      break;
    }

    // We have reach a memory block that fits our needs
    if (current_block->free && current_block->size >= size) {

      // Check if there is enough space to insert a memory block
      if (current_block->size > size + (uint) sizeof(struct MemoryBlock)) {
        // Insert new block after
        struct MemoryBlock* new_block = (uint) current_block + (uint) sizeof(struct MemoryBlock) + size;
        new_block->size = current_block->size - size;
        new_block->free = 1;
        new_block->next_block = current_block->next_block;
        current_block->next_block = new_block;
      }

      current_block->free = 0;
      current_block->size = size;

      return (uint) current_block + (uint) sizeof(struct MemoryBlock);
    }

    // Switchto next block
    current_block = current_block->next_block;
  }

  // Set new block header infos
  current_block->size = size;
  current_block->free = 0;
  current_block->next_block = (uint) current_block + (uint) sizeof(struct MemoryBlock) + size;

  // Move end block to the end
  end_block = current_block->next_block;

  // Return the start of the block
  return (void*) ((unsigned int) current_block + sizeof(struct MemoryBlock));
}


void free(void* ptr) {
  uint addr = (uint) ptr;
  struct MemoryBlock* block = (struct MemoryBlock*) (addr - sizeof(struct MemoryBlock));

  block->free = 1;
}
