#include "../lib/hw.h"
#include "../lib/console.h"
#include "../inc/riscv.hpp"
#include "../inc/syscall_c.hpp"
#include "../inc/MemoryAllocator.hpp"
#include "../inc/TCB.hpp"
#include "../inc/KSemaphore.hpp"
#include "../inc/printing.hpp"

extern "C" void supervisor_trap_handler () {
    
    volatile uint64 sepc    = CSR::r_sepc    ();
    volatile uint64 scause  = CSR::r_scause  ();
    volatile uint64 sstatus = CSR::r_sstatus ();

    if ( scause == 0x08 || scause == 0x09 ) {
        // ecall from U-mode or S-mode
        
        sepc += 4; // increment pc to point to next instruction after ecall

        uint64 syscall_code = TrapFrame::r_user_reg ( A0 );

        switch ( syscall_code ) {
            case MEM_ALLOC: {
                size_t size = TrapFrame::r_user_reg ( A1 );
                
                void*  ptr  = MemoryAllocator::kmalloc ( size );

                TrapFrame::w_user_reg ( A0, ( uint64 ) ptr );
                break;
            }

            case MEM_FREE: {
                void* ptr = (void*) TrapFrame::r_user_reg ( A1 );

                int   ret = MemoryAllocator::kfree ( ptr );

                TrapFrame::w_user_reg ( A0, ( uint64 ) ret );
                break;
            }

            case THREAD_CREATE: {
                thread_t*   handle      = ( thread_t* )   TrapFrame::r_user_reg ( A1 );
                thread_body t_body      = ( thread_body ) TrapFrame::r_user_reg ( A2 );
                void*       arg         = ( void* )       TrapFrame::r_user_reg ( A3 );
                void*       stack_space = ( void* )       TrapFrame::r_user_reg ( A4 );

                if ( handle == nullptr ) {
                    TrapFrame::w_user_reg( A1, ( uint64 ) -1 );
                    break;
                }

                TCB* tcb = new TCB ( t_body, arg, stack_space );

                if ( tcb == nullptr ) {                          
                    TrapFrame::w_user_reg ( A0, ( uint64 ) -1 );
                    break;
                }

                *handle = tcb;
                TrapFrame::w_user_reg ( A0, ( uint64 ) 0 );
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
                sem_t*   handle   = ( sem_t* )   TrapFrame::r_user_reg ( A1 );
                unsigned init_val = ( unsigned ) TrapFrame::r_user_reg ( A2 );

                if ( handle == nullptr ) {
                    TrapFrame::w_user_reg( A0, ( uint64 ) -1 );
                    break;
                }

                KSemaphore* sem = new KSemaphore ( init_val );

                if ( sem == nullptr ) {
                    TrapFrame::w_user_reg ( A0, ( uint64 ) -1 );
                    break;
                }

                *handle = sem;
                TrapFrame::w_user_reg ( A0, ( uint64 ) 0 );
                break;
            }

            case SEM_CLOSE: {
                sem_t handle = ( sem_t ) TrapFrame::r_user_reg ( A1 );

                if ( handle == nullptr ) {
                    TrapFrame::w_user_reg( A0, ( uint64 ) -1 );
                    break;
                }

                delete handle;

                TrapFrame::w_user_reg ( A0, ( uint64 ) 0 );
                break;
            }

            case SEM_WAIT: { 
                sem_t id = ( sem_t ) TrapFrame::r_user_reg ( A1 );

                if ( id == nullptr ) {
                    TrapFrame::w_user_reg( A0, ( uint64 ) -1 );
                    break;
                }

                int ret = id->wait ();

                TrapFrame::w_user_reg ( A0, ( uint64 ) ret );
                break;
            }

            case SEM_SIGNAL: {
                sem_t id = ( sem_t ) TrapFrame::r_user_reg ( A1 );

                if ( id == nullptr ) {
                    TrapFrame::w_user_reg( A0, ( uint64 ) -1 );
                    break;
                }

                int ret = id->signal ();

                TrapFrame::w_user_reg ( A0, ( uint64 ) ret );
                break;
            }

            case SEM_WAIT_N: {
                sem_t    id = ( sem_t )    TrapFrame::r_user_reg ( A1 );
                unsigned n  = ( unsigned ) TrapFrame::r_user_reg ( A2 );

                if ( id == nullptr ) {
                    TrapFrame::w_user_reg( A0, ( uint64 ) -1 );
                    break;
                }

                int ret = id->wait ( n );
                
                TrapFrame::w_user_reg ( A0, ( uint64 ) ret );
                break;
            }

            case SEM_SIGNAL_N: {
                sem_t    id = ( sem_t )    TrapFrame::r_user_reg ( A1 );
                unsigned n  = ( unsigned ) TrapFrame::r_user_reg ( A2 );

                if ( id == nullptr ) {
                    TrapFrame::w_user_reg( A0, ( uint64 ) -1 );
                    break;
                }

                int ret = id->signal ( n );

                TrapFrame::w_user_reg ( A0, ( uint64 ) ret );
                break;
            }

            case TIME_SLEEP: {
                break; // not implemented
            }

            case CONSOLE_GETC: {
                char c = __getc ();
                TrapFrame::w_user_reg ( A0, ( uint64 ) c );
                break;
            }

            case CONSOLE_PUTC: {
                char c = ( char ) TrapFrame::r_user_reg ( A1 );
                __putc ( c );
                break;
            }

            default: {
                // unknown syscall
                print_str ( "Error: unknown syscall\n" );
                print_str ( "TRAP scause=" ); print_int ( scause );
                print_str ( " sepc=" );       print_int ( sepc, 16 );
                print_str ( " stval=" );      print_int ( CSR::r_stval () );
                print_str ( "\n" );

                *( ( uint32* ) 0x100000 ) = 0x5555; // halt the emulator
            }
        }
    } 
    else {
        print_str ( "Error: unknown trap\n" );
        print_str ( "TRAP scause=" ); print_int ( scause );
        print_str ( " sepc=" );       print_int ( sepc, 16 );
        print_str ( " stval=" );      print_int ( CSR::r_stval () );
        print_str ( "\n" );

        *( ( uint32* ) 0x100000 ) = 0x5555; // halt the emulator
    }

    CSR::w_sepc    ( sepc );
    CSR::w_sstatus ( sstatus );
}

extern "C" void timer_interrupt_handler () {
    // clear timer interrupt
    CSR::mc_sip ( CSR::SIP_SSIP );
}

extern "C" void console_interrupt_handler () {
    console_handler ();
}
