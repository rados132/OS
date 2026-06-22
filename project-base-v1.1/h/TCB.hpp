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

private:
    thread_body  body;
    void*        arg;

    Context      context; // thread's context

    uint64*      stack;

    TCB*         next;

    static TCB*  running; // static field indicating the running thread

    bool         finished; // is thread finished

    friend class Scheduler;
};

#endif
