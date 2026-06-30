#include "../inc/MemoryAllocator.hpp"
#include "../inc/RISC_V.hpp"
#include "../inc/syscall_c.hpp"
#include "../lib/hw.h"
#include "../test/printing.hpp"
#include "../inc/TCB.hpp"

extern "C" void trap_handler ();

static const int NUM = 5;
static volatile int done = 0;       // cooperative => inkrement bez yield-a je bezbjedan

// --- nit koja se završava PADOM SA KRAJA body-ja (wrapper -> finish) ---
static void worker_return ( void* arg ) {
    uint64 id = ( uint64 ) arg;
    for ( uint64 i = 0; i < id + 1; i++ ) {            // razne dužine -> završavaju se u raznim trenucima
        print_str ( "  nit " ); print_int ( id );
        print_str ( " ciklus " ); print_int ( i ); print_str ( "\n" );
        thread_dispatch ();
    }
    print_str ( "  nit " ); print_int ( id ); print_str ( " ZAVRSAVA (return)\n" );
    done++;
}

// --- nit koja se završava EKSPLICITNO preko thread_exit (syscall 0x12) ---
static void worker_exit ( void* arg ) {
    uint64 id = ( uint64 ) arg;
    print_str ( "  nit " ); print_int ( id ); print_str ( " radi pa zove thread_exit\n" );
    thread_dispatch ();
    done++;
    thread_exit ();                                    // odavde se NIKAD ne vraća
    print_str ( "!!! GRESKA: thread_exit se vratio !!!\n" );  // ne smije se ispisati
}

// --- minimalna nit za fazu 2 (samo se kreira i odmah završi) ---
static void worker_short ( void* arg ) {
    done++;
    thread_exit ();
}

void main () {

    // install trap_handler (stvec -> trap_handler)
    RISC_V::w_stvec ( ( uint64 ) &trap_handler );

    TCB::running = new TCB ();

    // ================= FAZA 1: uredno gašenje (return + thread_exit) =================
    print_str ( "=== FAZA 1 ===\n" );
    thread_t t[NUM];
    thread_create ( &t[0], worker_return, ( void* ) 1 );
    thread_create ( &t[1], worker_return, ( void* ) 2 );
    thread_create ( &t[2], worker_exit,   ( void* ) 3 );
    thread_create ( &t[3], worker_return, ( void* ) 4 );
    thread_create ( &t[4], worker_exit,   ( void* ) 5 );

    while ( done < NUM ) { thread_dispatch (); }        // glavna nit čeka da se SVE završe

    print_str ( "FAZA 1 OK, done=" ); print_int ( done ); print_str ( "\n" );

    // ================= FAZA 2: dokaz da reaper OSLOBADJA memoriju =================
    // Serijski kreiramo daleko više niti nego što ih staje u hip ODJEDNOM —
    // svaka se završi PRIJE sljedeće. Ako reaper ne vraća stek/TCB, mem_alloc
    // će na kraju vratiti nullptr i thread_create pasti (negativan povratak).
    print_str ( "=== FAZA 2 (100 niti serijski) ===\n" );
    int prev = done;
    for ( int n = 0; n < 100; n++ ) {
        thread_t h;
        int ret = thread_create ( &h, worker_short, ( void* ) ( uint64 ) n );
        if ( ret < 0 ) {
            print_str ( "thread_create PAO na n=" ); print_int ( n );
            print_str ( "  => reaper NE oslobadja memoriju!\n" );
            break;
        }
        while ( done == prev ) { thread_dispatch (); }  // sačekaj da se baš ta nit reapuje
        prev = done;
    }
    print_str ( "FAZA 2 OK: 100 niti kreirano i oslobodjeno, done=" );
    print_int ( done ); print_str ( "\n" );

    print_str ( "main end. \n" );

    *( ( uint32* ) 0x100000 ) = 0x5555; // halt the emulator
}
