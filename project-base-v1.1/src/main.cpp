#include "../lib/hw.h"
#include "../lib/console.h"
#include "../h/MemoryAllocator.hpp"

extern int memory_allocator_test ( MemoryAllocator& allocator );

void main() {

    memory_allocator_test ( MemoryAllocator::get_instance () );
    
}
