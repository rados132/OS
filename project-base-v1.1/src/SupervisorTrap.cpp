#include "../lib/hw.h"
#include "../h/RISC_V.hpp"
#include "../h/MemoryAllocator.hpp"

extern "C" void supervisor_trap_handler () {
    
    volatile uint64 sepc    = RISC_V::r_sepc    ();
    volatile uint64 scause  = RISC_V::r_scause  ();
    volatile uint64 sstatus = RISC_V::r_sstatus ();

    if ( scause == 0x08 || scause == 0x09 ) {
        // ecall from U-mode or S-mode
        
        sepc += 4; // increment pc to point to next instruction after ecall

        uint64 syscall_code = RISC_V::r_user_reg ( A0 );

        switch ( syscall_code ) {
            case 0x01: {
                // mem_alloc
                size_t size = RISC_V::r_user_reg ( A1 );
                void*  ptr  = MemoryAllocator::get_instance ().k_malloc ( size );
                RISC_V::w_user_reg ( A0, ( uint64 ) ptr );
                break;
            }

            case 0x02: {
                // mem_free
                void* ptr = (void*) RISC_V::r_user_reg ( A1 );
                int   ret = MemoryAllocator::get_instance ().k_free ( ptr );
                RISC_V::w_user_reg ( A0, ( uint64 ) ret );
                break;
            }
        }
        
    } else {
        // unknown trap
        *( ( uint32* ) 0x100000 ) = 0x5555; // halt the emulator
    }

    RISC_V::w_sepc    ( sepc );
    RISC_V::w_sstatus ( sstatus );
}
