#ifndef SCHEDULER_HPP
#define SCHEDULER_HPP

class TCB;

class Scheduler {
public:
    static void put ( TCB* tcb );

    static TCB* get ();

private:
    static TCB* tcb_list_head;
    static TCB* tcb_list_tail;
};

#endif
