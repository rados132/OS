#include "../inc/bounded_buffer.hpp"

BoundedBuffer::BoundedBuffer () : head( 0 ), tail( 0 ), count( 0 )
{
}

bool BoundedBuffer::put ( char c ) {
    if ( full () ) return false;

    data[tail] = c;
    tail = ( tail + 1 ) % BUFFER_SIZE;
    count++;

    return true;
}

bool BoundedBuffer::get ( char* c ) {
    if ( empty () ) return false;

    *c = data[head];
    head = ( head + 1 ) % BUFFER_SIZE;
    count--;

    return true;
}

bool BoundedBuffer::full () const {
    return count == BUFFER_SIZE;
}

bool BoundedBuffer::empty () const {
    return count == 0;
}
