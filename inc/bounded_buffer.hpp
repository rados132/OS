#ifndef BOUNDED_BUFFER_HPP
#define BOUNDED_BUFFER_HPP

#include "../lib/hw.h"

#define BUFFER_SIZE 512

class BoundedBuffer {
public:
    BoundedBuffer ();

    bool put ( char c );
    bool get ( char* c );

    bool full  () const;
    bool empty () const;

private:
    char data[BUFFER_SIZE];
    size_t head, tail, count;
};

#endif // BOUNDED_BUFFER_HPP
