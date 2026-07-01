#include "../lib/hw.h"
#include "../inc/MemoryAllocator.hpp"
#include "../inc/RISC_V.hpp"
#include "../inc/syscall_c.hpp"
#include "../inc/TCB.hpp"
#include "../inc/KSemaphore.hpp"
#include "../inc/printing.hpp"

extern "C" void trap_handler ();

static void idle_body ( void* ) {
    while ( true ) thread_dispatch ();
}

void main () {

    // install trap_handler (stvec -> trap_handler)
    RISC_V::w_stvec ( ( uint64 ) &trap_handler );

    TCB::running = new TCB (); // initialize the main thread

    void* idle_stack  = MemoryAllocator::get_instance ().k_malloc( DEFAULT_STACK_SIZE );
    TCB*  idle_thread = new TCB ( &idle_body, nullptr, idle_stack );

    while ( true ) thread_dispatch();

    delete idle_thread;

    print_str ( "main end. \n" );

    *( ( uint32* ) 0x100000 ) = 0x5555; // halt the emulator
}
