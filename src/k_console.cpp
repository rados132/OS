#include "../inc/k_console.hpp"
#include "../inc/MemoryAllocator.hpp"
#include "../inc/riscv.hpp"

BoundedBuffer* KConsole::out_buffer         = nullptr;
KSemaphore*    KConsole::out_item_available = nullptr;
KSemaphore*    KConsole::out_space_available = nullptr;

void KConsole::init () {
    out_buffer          = new BoundedBuffer ();
    out_item_available  = new KSemaphore ( 0 );
    out_space_available = new KSemaphore ( BUFFER_SIZE );

    void* writer_stack = MemoryAllocator::kmalloc ( DEFAULT_STACK_SIZE );
    new TCB ( &writer_body, nullptr, writer_stack, true );
}

void KConsole::putc ( char c ) {
    out_space_available->wait ();
    out_buffer->put ( c );
    out_item_available->signal ();
}

void KConsole::writer_body ( void* ) {    
    p_reg console_status  = ( p_reg ) CONSOLE_STATUS;
    p_reg console_tx_data = ( p_reg ) CONSOLE_TX_DATA;

    char c;
    while ( true ) {
        out_item_available->wait ();

        CSR::mc_sstatus ( CSR::SSTATUS_SIE ); // disable interrupts
        out_buffer->get ( &c );
        CSR::ms_sstatus ( CSR::SSTATUS_SIE ); // enable interrupts

        out_space_available->signal ();

        while ( !( *console_status & CONSOLE_TX_STATUS_BIT ) );
        *console_tx_data = c;
    }
}
