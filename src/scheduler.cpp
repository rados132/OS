#include "../inc/Scheduler.hpp"
#include "../inc/TCB.hpp"

TCB* Scheduler::tcb_list_head = nullptr;
TCB* Scheduler::tcb_list_tail = nullptr;

void Scheduler::put ( TCB* tcb ) {
    // add this thread to end of FIFO queue
    tcb->next = nullptr;

    if ( tcb_list_tail ) tcb_list_tail->next = tcb;
    else                 tcb_list_head       = tcb;

    tcb_list_tail = tcb;
}

TCB* Scheduler::get () {
    // get the next thread form queue 
    if ( !tcb_list_head ) return nullptr;

    TCB* ret = tcb_list_head;

    tcb_list_head = tcb_list_head->next;

    if ( !tcb_list_head ) tcb_list_tail = nullptr;

    return ret;
}
