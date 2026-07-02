#include "../lib/hw.h"
#include "../inc/MemoryAllocator.hpp"
#include "../inc/RISC_V.hpp"
#include "../inc/syscall_c.hpp"
#include "../inc/TCB.hpp"
#include "../inc/KSemaphore.hpp"
#include "../inc/printing.hpp"

extern "C" void ivtp ();

extern void userMain ();

static void idle_body         ( void* );
static void user_main_wrapper ( void* );

volatile static bool user_main_done = false;

void main () {

    // install interrupt vector table
    RISC_V::w_stvec ( ( uint64 ) &ivtp | 1 );

    TCB::running = new TCB (); // initialize the main thread

    // initialize idle thread
    void* idle_stack = MemoryAllocator::get_instance ().k_malloc ( DEFAULT_STACK_SIZE );
    new TCB ( &idle_body, nullptr, idle_stack );

    // initialize user thread
    void* user_stack = MemoryAllocator::get_instance ().k_malloc ( DEFAULT_STACK_SIZE );
    new TCB ( &user_main_wrapper, nullptr, user_stack );

    while ( !user_main_done ) thread_dispatch (); // wait for user thread to finish

    print_str ( "\nKernel shutting down\n\n" );

    *( ( uint32* ) 0x100000 ) = 0x5555; // halt the emulator
}

static void idle_body ( void* ) {
    while ( true ) {
        thread_dispatch ();
    }
}

static void user_main_wrapper ( void* ) {
    userMain ();
    user_main_done = true;
}
