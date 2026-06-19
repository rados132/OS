#include "../lib/hw.h"
#include "../lib/console.h"
#include "../h/MemoryAllocator.hpp"
#include "../h/RiscV.hpp"

extern int memory_allocator_test ( MemoryAllocator& allocator );

extern "C" void trap_handler ();

void main() {

    // memory_allocator_test ( MemoryAllocator::get_instance () );

    RiscV::w_stvec ( ( uint64 ) &trap_handler );

    __putc ( 'A' );

    __asm__ volatile ( "ecall" );

    __putc ( 'B' );

    __putc ( '\n' );
    __putc ( '\n' );

    *( ( uint32 * ) 0x100000 ) = 0x5555; // halt the emulator
}
