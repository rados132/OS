#ifndef TCB_H
#define TCB_H

#include "../lib/hw.h"

struct Context {
    uint64 ra;
    uint64 sp;
    uint64 s0;
    uint64 s1;
    uint64 s2;
    uint64 s3;
    uint64 s4;
    uint64 s5;
    uint64 s6;
    uint64 s7;
    uint64 s8;
    uint64 s9;
    uint64 s10;
    uint64 s11;
};

struct SemInfo {
    bool blocked = false;
    bool closed  = false;
    uint waiting = 0;
};

typedef void ( *thread_body ) ( void* );

class TCB {
public:
    TCB ( thread_body t_body = 0, void* arg = 0, void* stack_space = 0 );
   ~TCB ();

    static void  yield  (); // allow other thread to execute

    static void  finish (); // finish execution of current thread

    static TCB*   running;  // static field indicating the running thread

    static time_t cpu_time; // for how long did current thread had the cpu
    
    void* operator new      ( size_t size ) noexcept;
    void  operator delete   ( void* ptr );
    
protected:
    static void  wrapper ();

private:
    thread_body  body;       // routine to be executed by the thread
    void*        arg;        // argument passed to routine

    Context      context;    // thread's context

    uint64*      stack;      // stack memory start addr, aligned to 16B

    TCB*         next;       // points to next thread in list
    
    bool         finished;   // is thread finished

    time_t       sleep_time; // how long will thread sleep

    SemInfo      sem;        // semaphore info for synchronization

    static TCB*  dying;      // pointer to dying thread

    friend class Scheduler;  // so that Scheduler can access relevant fields
    friend class KSemaphore; // so that Semaphore can access relevant fields
};

#endif
