#include "../lib/hw.h"
#include "../inc/RISC_V.hpp"
#include "../inc/syscall_c.hpp"
#include "../inc/MemoryAllocator.hpp"
#include "../inc/TCB.hpp"
#include "../test/printing.hpp"

extern "C" void supervisor_trap_handler () {
    
    volatile uint64 sepc    = RISC_V::r_sepc    ();
    volatile uint64 scause  = RISC_V::r_scause  ();
    volatile uint64 sstatus = RISC_V::r_sstatus ();

    if ( scause == 0x08 || scause == 0x09 ) {
        // ecall from U-mode or S-mode
        
        sepc += 4; // increment pc to point to next instruction after ecall

        uint64 syscall_code = RISC_V::r_user_reg ( A0 );

        switch ( syscall_code ) {
            case MEM_ALLOC: {
                size_t size = RISC_V::r_user_reg ( A1 );
                void*  ptr  = MemoryAllocator::get_instance ().k_malloc ( size );
                RISC_V::w_user_reg ( A0, ( uint64 ) ptr );
                break;
            }

            case MEM_FREE: {
                void* ptr = (void*) RISC_V::r_user_reg ( A1 );
                int   ret = MemoryAllocator::get_instance ().k_free ( ptr );
                RISC_V::w_user_reg ( A0, ( uint64 ) ret );
                break;
            }

            case THREAD_CREATE: {
                thread_t*   handle      = ( thread_t* )   RISC_V::r_user_reg ( A1 );
                thread_body t_body      = ( thread_body ) RISC_V::r_user_reg ( A2 );
                void*       arg         = ( void* )       RISC_V::r_user_reg ( A3 );
                void*       stack_space = ( void* )       RISC_V::r_user_reg ( A4 );

                TCB* tcb = new TCB ( t_body, arg, stack_space );

                if ( tcb == nullptr ) {                          
                    RISC_V::w_user_reg ( A0, ( uint64 ) -1 );
                    break;
                }

                *handle = tcb;
                RISC_V::w_user_reg ( A0, ( uint64 ) 0 );
                break;
            }

            case THREAD_EXIT: {
                TCB::finish ();
                break;
            }

            case THREAD_DISPATCH: {
                TCB::yield ();
                break;
            }

            case SEM_OPEN: {
                // TODO: Implement semaphore open
                break;
            }

            case SEM_CLOSE: {
                // TODO: Implement semaphore close
                break;
            }

            case SEM_WAIT: { 
                // TODO: Implement semaphore wait
                break;
            }

            case SEM_SIGNAL: {
                // TODO: Implement semaphore signal
                break;
            }

            case SEM_WAIT_N: {
                // TODO: Implement semaphore wait_n
                break;
            }

            case SEM_SIGNAL_N: {
                // TODO: Implement semaphore signal_n
                break;
            }

            default: {
                // unknown trap
                print_str ( "Error: unknown trap \n" );
                print_str ( "TRAP scause=" ); print_int ( scause );
                print_str ( " sepc=" );       print_int ( sepc, 16 );
                print_str ( " stval=" );      print_int ( RISC_V::r_stval () );
                print_str ( "\n" );

                *( ( uint32* ) 0x100000 ) = 0x5555; // halt the emulator
            }
        }
        
    } else {
        print_str ( "Error: non ecall trap \n" );
        print_str ( "TRAP scause=" ); print_int ( scause );
        print_str ( " sepc=" );       print_int ( sepc, 16 );
        print_str ( " stval=" );      print_int ( RISC_V::r_stval () );
        print_str ( "\n" );

        *( ( uint32* ) 0x100000 ) = 0x5555; // halt the emulator
    }

    RISC_V::w_sepc    ( sepc );
    RISC_V::w_sstatus ( sstatus );
}
