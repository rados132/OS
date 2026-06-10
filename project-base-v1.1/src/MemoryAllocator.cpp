#include "../h/MemoryAllocator.hpp"

MemoryAllocator::MemoryAllocator () {
    // Initialization of the memory allocator
    free_mem_size  = (size_t) HEAP_END_ADDR - (size_t) HEAP_START_ADDR;

    free_mem_head  = (FreeFragment*) HEAP_START_ADDR;

    free_mem_head->size = free_mem_size;
    free_mem_head->next = nullptr;
}

MemoryAllocator& MemoryAllocator::get_instance () {
    // Get the singleton instance of MemoryAllocator
    static MemoryAllocator instance;
    return instance;
}

void* MemoryAllocator::k_malloc (size_t size) {
    // implemented to best fit
    FreeFragment* prev = nullptr;
    FreeFragment* curr = free_mem_head;
    
    return nullptr;
}

int MemoryAllocator::k_free (void* ptr) {
    return 0;
}

void MemoryAllocator::try_to_merge (FreeFragment* prev, FreeFragment* next) {
}
