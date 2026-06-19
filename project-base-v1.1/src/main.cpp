#include "../lib/hw.h"
#include "../lib/console.h"
#include "../h/MemoryAllocator.hpp"
#include "../h/RiscV.hpp"
#include "../test/tests.hpp"

void main () {

    // memory_allocator_test ( MemoryAllocator::get_instance () );

    ecall_test ();

    *( ( uint32* ) 0x100000 ) = 0x5555; // halt the emulator
}
