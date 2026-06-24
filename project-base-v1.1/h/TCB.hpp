#ifndef TCB_H
#define TCB_H

#include "../lib/hw.h"

typedef void ( *thread_body ) ( void* );

struct Context {
    uint64 ra;
    uint64 sp;
};

class TCB {
public:
    TCB ( thread_body t_body, void* arg, void* stack );

    static TCB*  running;  // static field indicating the running thread

private:
    thread_body  body;
    void*        arg;

    Context      context;  // thread's context

    uint64*      stack;    // thread's stack

    TCB*         next;     // points to next thread in list

    bool         finished; // is thread finished

    friend class Scheduler;
};

#endif
