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

    void* operator new    ( size_t size ) noexcept;
    void  operator delete ( void* ptr );

protected:
    void block   ();
    void unblock ();

    void enqueue ( TCB* blocked );
    TCB* dequeue ();

private:
    uint  val;     
    TCB*  blocked_head;
    TCB*  blocked_tail;
};

#endif
