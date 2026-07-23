#include "../lib/hw.h"
#include "../lib/console.h"
#include "../inc/riscv.hpp"
#include "../inc/syscall_c.hpp"
#include "../inc/MemoryAllocator.hpp"
#include "../inc/TCB.hpp"
#include "../inc/Scheduler.hpp"
#include "../inc/KSemaphore.hpp"
#include "../inc/printing.hpp"
#include "../inc/KConsole.hpp"

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

            case TIME_SLEEP: {
                time_t time_to_sleep = ( time_t ) TrapFrame::r_user_reg ( A1 );

                if ( time_to_sleep == 0 ) {
                    TrapFrame::w_user_reg ( A0, ( uint64 ) 0 );
                    break;
                }

                Scheduler::put_to_sleep ( TCB::running, time_to_sleep );
                TCB::yield ();

                TrapFrame::w_user_reg ( A0, ( uint64 ) 0 );
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

            case CONSOLE_GETC: {
                char c = KConsole::getc ();
                TrapFrame::w_user_reg ( A0, ( uint64 ) c );
                break;
            }

            case CONSOLE_PUTC: {
                char c = ( char ) TrapFrame::r_user_reg ( A1 );
                KConsole::putc_out ( c );
                break;
            }

            default: {
                // unknown syscall
                print_str ( "Error: unknown syscall\n" );
                print_str ( "TRAP scause=" ); print_int ( scause );
                print_str ( " sepc=" );       print_int ( sepc, 16 );
                print_str ( " stval=" );      print_int ( CSR::r_stval () );
                print_str ( "\n" );

                KConsole::flush_out_buffer (); // flush the console output buffer

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

        KConsole::flush_out_buffer (); // flush the console output buffer

        *( ( uint32* ) 0x100000 ) = 0x5555; // halt the emulator
    }

    CSR::w_sepc    ( sepc );
    CSR::w_sstatus ( sstatus );
}

extern "C" void timer_interrupt_handler () {
    /* save pc and status regs */
    volatile uint64 sepc    = CSR::r_sepc    ();
    volatile uint64 sstatus = CSR::r_sstatus ();

    CSR::mc_sip ( CSR::SIP_SSIP ); // clear timer interrupt

    /* update sleeping threads */
    Scheduler::update_sleeping ();

    /* yield if current thread has exceeded its time slice */
    if ( ++TCB::cpu_time >= DEFAULT_TIME_SLICE ) {
        TCB::yield ();
    }

    /* restore pc and status regs */
    CSR::w_sepc    ( sepc );
    CSR::w_sstatus ( sstatus );
}

extern "C" void console_interrupt_handler () {

    int irq = plic_claim (); // accept irq

    if ( irq == CONSOLE_IRQ )
        plic_complete ( irq ); // if irq is from console mark it as served
    else {
        print_str ( "Error: unknown interrupt\n" );
        print_str ( "TRAP scause=" ); print_int ( CSR::r_scause () );
        print_str ( " sepc=" );       print_int ( CSR::r_sepc (), 16 );
        print_str ( " stval=" );      print_int ( CSR::r_stval () );
        print_str ( "\n" );

        KConsole::flush_out_buffer (); // flush the console output buffer

        *( ( uint32* ) 0x100000 ) = 0x5555; // halt the emulator
    }

    p_reg console_status  = ( p_reg ) CONSOLE_STATUS;
    p_reg console_rx_data = ( p_reg ) CONSOLE_RX_DATA;

    uint8 max_chars = 8;
    char c;
    while ( ( *console_status & CONSOLE_RX_STATUS_BIT ) && max_chars-- ) {
        c = ( char ) *console_rx_data;
        int full = KConsole::putc_in ( c );
        if ( full ) break;
    }
}
