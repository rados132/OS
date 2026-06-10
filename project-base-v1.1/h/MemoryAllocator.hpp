#ifndef _MEMORY_ALLOCATOR_HPP_
#define _MEMORY_ALLOCATOR_HPP_

#include "../lib/hw.h"

struct FreeFragment {
    size_t        size;
    FreeFragment* next;
};

class MemoryAllocator {
public:
    static  MemoryAllocator& get_instance ();

    void*   k_malloc ( size_t size );

    int     k_free   ( void* ptr );

protected:
    void    try_to_merge ( FreeFragment* prev, FreeFragment* next );

private:
    MemoryAllocator ();

    MemoryAllocator            ( const MemoryAllocator& ) = delete;

    MemoryAllocator& operator= ( const MemoryAllocator& ) = delete;

    size_t        free_mem_size;
    FreeFragment* free_mem_head;
};

#endif
