#ifndef K_SEMAPHORE_H
#define K_SEMAPHORE_H

class TCB;

class KSemaphore {
public:
     KSemaphore ( unsigned permits = 1 );
    ~KSemaphore ();

    int wait   ( unsigned n = 1 );
    int signal ( unsigned n = 1 );

private:
    int  internal_val; // internal semaphore value
    TCB* blocked;      // threads blocked on semaphore
};

#endif
