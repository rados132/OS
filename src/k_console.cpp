#include "../inc/k_console.hpp"
#include "../inc/MemoryAllocator.hpp"

BoundedBuffer* KConsole::out_buffer = nullptr;
KSemaphore* KConsole::out_item_available = nullptr;

void KConsole::init () {
    out_buffer = new BoundedBuffer ();
    out_item_available = new KSemaphore ( 0 );
    
    void* writer_stack = MemoryAllocator::kmalloc ( DEFAULT_STACK_SIZE );
    new TCB ( &writer_body, nullptr, writer_stack, true );
}

void KConsole::putc ( char c ) {
    int full = out_buffer->put ( c );
    if ( !full ) out_item_available->signal ();
}

void KConsole::writer_body ( void* ) {    
    p_reg console_status  = ( p_reg ) CONSOLE_STATUS;
    p_reg console_tx_data = ( p_reg ) CONSOLE_TX_DATA;

    char c;
    while ( true ) {
        out_item_available->wait ();
        out_buffer->get ( &c );
        while ( !( *console_status & CONSOLE_TX_STATUS_BIT ) );
        *console_tx_data = c;
    }
}
