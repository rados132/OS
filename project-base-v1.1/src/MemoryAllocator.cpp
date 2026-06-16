#include "../h/MemoryAllocator.hpp"

MemoryAllocator::MemoryAllocator () {
    // Initialization of the memory allocator
    mem_start_addr = align_up( ( size_t ) HEAP_START_ADDR );    // Align start addr to block
    mem_end_addr   = align_down( ( size_t ) HEAP_END_ADDR );    // Align end addr to block

    free_mem_head  = ( FreeFragment* ) mem_start_addr;

    free_mem_size  = mem_end_addr - mem_start_addr;

    free_mem_head->size = free_mem_size;
    free_mem_head->next = nullptr;
}

MemoryAllocator& MemoryAllocator::get_instance () {
    // Get the singleton instance of MemoryAllocator
    static MemoryAllocator instance;
    return instance;
}

void* MemoryAllocator::k_malloc ( size_t size ) {
    // implemented to best fit
    FreeFragment* prev = nullptr;
    FreeFragment* curr = free_mem_head;
    
    return nullptr;
}

int MemoryAllocator::k_free ( void* ptr ) {
    return 0;
}

inline constexpr size_t MemoryAllocator::align_up (size_t addr) {
    return ( ( addr + MEM_BLOCK_SIZE - 1 ) / MEM_BLOCK_SIZE ) * MEM_BLOCK_SIZE;
}

inline constexpr size_t MemoryAllocator::align_down (size_t addr) {
    return ( addr / MEM_BLOCK_SIZE ) * MEM_BLOCK_SIZE;
}

void MemoryAllocator::try_to_merge (FreeFragment* prev, FreeFragment* next) {
}
