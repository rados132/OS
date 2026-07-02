#include "../lib/hw.h"
#include "../inc/MemoryAllocator.hpp"
#include "../inc/RISC_V.hpp"
#include "../inc/syscall_c.hpp"
#include "../inc/TCB.hpp"
#include "../inc/KSemaphore.hpp"
#include "../inc/printing.hpp"

extern "C" void ivtp ();

extern void userMain ();

volatile static bool user_main_done = false;

static void user_main_wrapper ( void* ) {
    userMain ();
    user_main_done = true;
}

static void idle_body ( void* ) {
    while ( true ) {
        thread_dispatch ();
    }
}

void main () {

    // install trap_handler (stvec -> trap_handler)
    RISC_V::w_stvec ( ( uint64 ) &ivtp | 1 );

    TCB::running = new TCB (); // initialize the main thread

    void* idle_stack = MemoryAllocator::get_instance ().k_malloc ( DEFAULT_STACK_SIZE );
    new TCB ( &idle_body, nullptr, idle_stack );

    void* user_stack = MemoryAllocator::get_instance ().k_malloc ( DEFAULT_STACK_SIZE );
    new TCB ( &user_main_wrapper, nullptr, user_stack );

    while ( !user_main_done ) thread_dispatch ();

    print_str ( "main end. \n" );

    *( ( uint32* ) 0x100000 ) = 0x5555; // halt the emulator
}
