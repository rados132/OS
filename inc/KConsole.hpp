#ifndef K_CONSOLE_HPP
#define K_CONSOLE_HPP

#include "../inc/tcb.hpp"
#include "../inc/bounded_buffer.hpp"
#include "../inc/KSemaphore.hpp"

typedef volatile uint8* p_reg;

class KConsole {
public:
    static void init ();

    static int  putc_in  ( char c );
    static void putc_out ( char c );

    static char getc ();

    static void flush_out_buffer ();

protected:
    static void writer_body ( void* );

private:
    static BoundedBuffer* out_buffer;
    static KSemaphore*    out_item_available;
    static KSemaphore*    out_space_available;

    static BoundedBuffer* in_buffer;
    static KSemaphore*    in_item_available;
};

#endif
