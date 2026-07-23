#include "../inc/KConsole.hpp"
#include "../inc/MemoryAllocator.hpp"
#include "../inc/riscv.hpp"

BoundedBuffer* KConsole::out_buffer          = nullptr;
KSemaphore*    KConsole::out_item_available  = nullptr;
KSemaphore*    KConsole::out_space_available = nullptr;
BoundedBuffer* KConsole::in_buffer           = nullptr;
KSemaphore*    KConsole::in_item_available   = nullptr;

void KConsole::init () {
    out_buffer          = new BoundedBuffer ();
    out_item_available  = new KSemaphore ( 0 );
    out_space_available = new KSemaphore ( BUFFER_SIZE );

    in_buffer           = new BoundedBuffer ();
    in_item_available   = new KSemaphore ( 0 );

    void* writer_stack = MemoryAllocator::kmalloc ( DEFAULT_STACK_SIZE );
    new TCB ( &writer_body, nullptr, writer_stack, true );
}

int KConsole::putc_in ( char c ) {
    if ( in_buffer->full () ) return 1;

    in_buffer->put ( c );
    in_item_available->signal ();

    return 0;
}

void KConsole::putc_out ( char c ) {
    out_space_available->wait ();
    out_buffer->put ( c );
    out_item_available->signal ();
}

void KConsole::flush_out_buffer () {
    p_reg console_status  = ( p_reg ) CONSOLE_STATUS;
    p_reg console_tx_data = ( p_reg ) CONSOLE_TX_DATA;

    mask_interrupts (); // disable interrupts
    char c;
    while ( !out_buffer->empty () ) {
        out_buffer->get ( &c );
        while ( !( *console_status & CONSOLE_TX_STATUS_BIT ) ); // spin wait
        *console_tx_data = c;
    }
}

char KConsole::getc () {
    in_item_available->wait ();

    char c;
    in_buffer->get ( &c );

    return c;
}

void KConsole::writer_body ( void* ) {    
    p_reg console_status  = ( p_reg ) CONSOLE_STATUS;
    p_reg console_tx_data = ( p_reg ) CONSOLE_TX_DATA;

    char c;
    while ( true ) {
        mask_interrupts (); // disable interrupts
        out_item_available->wait ();
        out_buffer->get ( &c );
        out_space_available->signal ();
        unmask_interrupts (); // enable interrupts

        while ( !( *console_status & CONSOLE_TX_STATUS_BIT ) ); // spin wait
        *console_tx_data = c;
    }
}
