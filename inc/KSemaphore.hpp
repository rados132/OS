#ifndef K_SEMAPHORE_H
#define K_SEMAPHORE_H

#include "../lib/hw.h"

class TCB;

class KSemaphore {
public:
     KSemaphore ( unsigned permits = 1 );
    ~KSemaphore ();

    int wait   ( unsigned n = 1 );
    int signal ( unsigned n = 1 );

    void* operator new    ( size_t size );
    void  operator delete ( void* ptr );

private:
    int  internal_val; // internal semaphore value
    TCB* blocked;      // threads blocked on semaphore
};

#endif
