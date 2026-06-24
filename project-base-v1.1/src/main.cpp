#include "../lib/hw.h"
#include "../lib/console.h"
#include "../h/MemoryAllocator.hpp"
#include "../h/RiscV.hpp"
#include "../h/syscall_c.hpp"

extern "C" void trap_handler ();

static void printStr ( const char* s ) {
    while ( *s ) __putc ( *s++ );
}

void main () {

    // 1) instaliraj prekidnu rutinu (stvec -> trap_handler)
    RiscV::w_stvec ( ( uint64 ) &trap_handler );

    printStr ( "=== TEST START ===\n" );

    // 2) alokacija (100 bajtova -> C API zaokružuje na blokove)
    char* p = ( char* ) mem_alloc ( 100 );
    if ( p == nullptr ) {
        printStr ( "alloc: FAILED (nullptr)\n" );
        *( ( uint32* ) 0x100000 ) = 0x5555;
    }
    printStr ( "alloc: OK\n" );

    // 3) upiši pa pročitaj nazad -> potvrda da je prostor stvarno upotrebljiv
    for ( int i = 0; i < 100; i++ ) p[i] = ( char ) ( i & 0xFF );
    bool ok = true;
    for ( int i = 0; i < 100; i++ )
        if ( p[i] != ( char ) ( i & 0xFF ) ) ok = false;
    printStr ( ok ? "write/read: OK\n" : "write/read: FAILED\n" );

    // 4) oslobađanje
    int r = mem_free ( p );
    printStr ( r == 0 ? "free: OK\n" : "free: FAILED\n" );

    printStr ( "=== TEST DONE ===\n" );

    *( ( uint32* ) 0x100000 ) = 0x5555; // halt the emulator
}
