#include "../lib/hw.h"
#include "../inc/MemoryAllocator.hpp"
#include "../inc/riscv.hpp"
#include "../inc/syscall_c.hpp"
#include "../inc/TCB.hpp"
#include "../inc/KSemaphore.hpp"
#include "../inc/printing.hpp"
#include "../inc/KConsole.hpp"

extern "C" void trap_handler ();

extern void userMain ();

static void idle_body         ( void* );
static void user_main_wrapper ( void* );

volatile static bool user_main_done = false;

void main () {

    // install trap handler routine in vectored mode
    CSR::w_stvec ( ( uint64 ) &trap_handler | 1 );

    MemoryAllocator::init (); // initialize memory allocator

    KConsole::init (); // initialize console

    TCB::running = new TCB (); // initialize the main thread

    // initialize idle thread
    void* idle_stack = MemoryAllocator::kmalloc ( DEFAULT_STACK_SIZE );
    new TCB ( &idle_body, nullptr, idle_stack );

    // initialize user thread
    void* user_stack = MemoryAllocator::kmalloc ( DEFAULT_STACK_SIZE );
    new TCB ( &user_main_wrapper, nullptr, user_stack );

    while ( !user_main_done ) thread_dispatch (); // wait for user thread to finish

    print_str ( "\nKernel shutting down\n\n" );
    
    KConsole::flush_out_buffer (); // flush the console output buffer

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
