#ifndef SCHEDULER_HPP
#define SCHEDULER_HPP

#include "../lib/hw.h"

class TCB;

class Scheduler {
public:
    static void put ( TCB* tcb );

    static TCB* get ();

    static void put_to_sleep ( TCB* tcb, time_t time_to_sleep );

    static void update_sleeping ();

private:
    static TCB* ready_queue_head;
    static TCB* ready_queue_tail;
    static TCB* sleeping_queue;
};

#endif
