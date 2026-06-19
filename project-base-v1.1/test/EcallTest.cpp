#include "../h/RiscV.hpp"
#include "../lib/console.h"

extern "C" void trap_handler ();

int ecall_test () {

    RiscV::w_stvec ( ( uint64 ) &trap_handler );

    __putc ( 'A' );

    __asm__ volatile ( "ecall" );

    __putc ( 'B' );

    __putc ( '\n' );
    __putc ( '\n' );
    
    return 0;
}
