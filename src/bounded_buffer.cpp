#include "../inc/bounded_buffer.hpp"

BoundedBuffer::BoundedBuffer () : head( 0 ), tail( 0 ), count( 0 )
{
}

int BoundedBuffer::put ( char c ) {
    if ( full () ) return 1;

    data[tail] = c;
    tail = ( tail + 1 ) % BUFFER_SIZE;
    count++;

    return 0;
}

int BoundedBuffer::get ( char* c ) {
    if ( empty () ) return 1;

    *c = data[head];
    head = ( head + 1 ) % BUFFER_SIZE;
    count--;

    return 0;
}

bool BoundedBuffer::full () const {
    return count == BUFFER_SIZE;
}

bool BoundedBuffer::empty () const {
    return count == 0;
}
