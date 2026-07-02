#ifndef MEMORY_ALLOCATOR_HPP
#define MEMORY_ALLOCATOR_HPP

#include "../lib/hw.h"

struct FreeFragment {
    size_t        size;
    FreeFragment* next;
};

typedef size_t header_t; // header of allocated block

class MemoryAllocator {
public:
    static void  init ();

    static void* kmalloc ( size_t size );

    static int   kfree   ( void* ptr );

protected:
  static inline constexpr size_t align_up   ( size_t addr );
  static inline constexpr size_t align_down ( size_t addr );

  static void try_to_merge ( FreeFragment* prev, FreeFragment* curr );

private:
    static size_t        mem_start_addr;
    static size_t        mem_end_addr;
    static size_t        free_mem_size;
    static FreeFragment* free_mem_head;
};

#endif
