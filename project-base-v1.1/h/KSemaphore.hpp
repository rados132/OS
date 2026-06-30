#ifndef K_SEMAPHORE_H
#define K_SEMAPHORE_H

class TCB;

class KSemaphore {
public:
     KSemaphore ( unsigned permits = 1 );
    ~KSemaphore ();

private:
    int  internal_val;
    TCB* blocked;
};

#endif
