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
    TCB ( thread_body t_body, void* arg, void* stack_space );

    ~TCB ();

    static void  yield  ();

    static TCB*  running;  // static field indicating the running thread

    void* operator new      ( size_t size );
    void* operator new[]    ( size_t size );
    void  operator delete   ( void* ptr );
    void  operator delete[] ( void* ptr );
    
protected:
    static void  finish         ();
    static void  thread_wrapper ();

private:
    thread_body  body;      // routine to be executed by the thread
    void*        arg;       // argument passed to routine

    Context      context;   // thread's context

    uint64*      stack;     // stack memory start addr, aligned to 16B

    TCB*         next;      // points to next thread in list

    bool         finished;  // is thread finished

    friend class Scheduler; // so that Scheduler can access relevant fields
};

#endif
