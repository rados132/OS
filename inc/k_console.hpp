#ifndef K_CONSOLE_HPP
#define K_CONSOLE_HPP

#include "../inc/tcb.hpp"
#include "../inc/bounded_buffer.hpp"
#include "../inc/KSemaphore.hpp"

typedef uint8* p_reg;

class KConsole {
public:
    static void init ();
    static void putc ( char c );

protected:
    static void writer_body ( void* );

private:
    static BoundedBuffer* out_buffer;
    static KSemaphore* out_item_available;
};

#endif
