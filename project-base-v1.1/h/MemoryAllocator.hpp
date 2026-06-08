#ifndef _MEMORY_ALLOCATOR_HPP_
#define _MEMORY_ALLOCATOR_HPP_

#include "../lib/hw.h"

struct FreeBlock {
    size_t      size;
    FreeBlock*  next;
};

class MemoryAllocator {
public:
    static  MemoryAllocator& getInstance ();

    void*   k_malloc (size_t size);

    int     k_free (void* ptr);

private:
    MemoryAllocator ();

    MemoryAllocator (const MemoryAllocator&) = delete;

    MemoryAllocator& operator= (const MemoryAllocator&) = delete;
};

#endif
