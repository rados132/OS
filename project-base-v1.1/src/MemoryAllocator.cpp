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
    
    if ( size == 0 ) return nullptr;

    // needed size of memory is requested size + header size aligned up to block size
    size_t needed_size = align_up( size + sizeof( header ) );

    FreeFragment* prev = nullptr;
    FreeFragment* curr = free_mem_head;

    FreeFragment* best      = nullptr;
    FreeFragment* best_prev = nullptr;

    // iterate through free mem list and find the best fit fragment
    for ( ; curr != nullptr; prev = curr, curr = curr->next ) {
        if ( curr->size >= needed_size ) {
            if ( best == nullptr || curr->size < best->size ) {
                best      = curr;
                best_prev = prev;
            }
        }
    }

    if ( best == nullptr ) return nullptr;  // should never happen

    size_t remainder_size = best->size - needed_size; // calculate the size of leftover fragment

    if ( remainder_size >= MEM_BLOCK_SIZE ) {
        // if remainder is at least one block of mem make it a new free fragment
        FreeFragment* remainder = ( FreeFragment* ) ( ( char* ) best + needed_size );

        remainder->size = remainder_size;
        remainder->next = best->next;

        if ( best_prev ) best_prev->next = remainder;
        else             free_mem_head   = remainder;   // best was head
    }
    else {
        // remainder is less then one block, add it to allocated fragment
        needed_size = best->size;

        if ( best_prev ) best_prev->next = best->next;
        else             free_mem_head   = best->next;
    }

    *(( header* ) best ) = needed_size; // write size of allocated block in the header

    return ( void* ) ( ( char* ) best + sizeof ( header ) ); // return address of first byte after header
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
