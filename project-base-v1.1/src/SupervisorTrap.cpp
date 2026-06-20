#include "../lib/hw.h"
#include "../h/RiscV.hpp"
#include "../h/MemoryAllocator.hpp"

extern "C" void supervisor_trap_handler () {
    
    volatile uint64 sepc    = RiscV::r_sepc    ();
    volatile uint64 scause  = RiscV::r_scause  ();
    volatile uint64 sstatus = RiscV::r_sstatus ();

    if ( scause == 0x08 || scause == 0x09 ) {
        // ecall from U-mode or S-mode
        sepc += 4;

        uint64 syscall = RiscV::r_user_reg ( A0 );

        switch ( syscall ) {
            case 0x01: {
                // mem_alloc
                size_t size = RiscV::r_user_reg ( A1 );
                void*  ptr  = MemoryAllocator::get_instance ().k_malloc ( size );
                RiscV::w_user_reg ( A0, ( uint64 ) ptr );
                break;
            }

            case 0x02: {
                // mem_free
                void* ptr = (void*) RiscV::r_user_reg ( A1 );
                int   ret = MemoryAllocator::get_instance ().k_free ( ptr );
                RiscV::w_user_reg ( A0, ( uint64 ) ret );
                break;
            }
        }
        
    } else {
        // unknown trap
        *( ( uint32* ) 0x100000 ) = 0x5555; // halt the emulator
    }

    RiscV::w_sepc    ( sepc );
    RiscV::w_sstatus ( sstatus );
}
