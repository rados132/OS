#include "../inc/Scheduler.hpp"
#include "../inc/TCB.hpp"

TCB* Scheduler::ready_queue_head = nullptr;
TCB* Scheduler::ready_queue_tail = nullptr;
TCB* Scheduler::sleeping_queue   = nullptr;

void Scheduler::put ( TCB* tcb ) {
    // add this thread to end of FIFO queue
    tcb->next = nullptr;

    if ( ready_queue_tail )
        ready_queue_tail->next = tcb;
    else
        ready_queue_head = tcb;

    ready_queue_tail = tcb;
}

TCB* Scheduler::get () {
    // get the next thread form queue 
    if ( !ready_queue_head ) return nullptr;

    TCB* ret = ready_queue_head;

    ready_queue_head = ready_queue_head->next;

    if ( !ready_queue_head ) ready_queue_tail = nullptr;

    return ret;
}

void Scheduler::put_to_sleep ( TCB * tcb, time_t time_to_sleep ) {
    tcb->sleep_time = time_to_sleep;

    TCB* curr = sleeping_queue;
    TCB* prev = nullptr;
    for ( ; curr != nullptr; prev = curr, curr = curr->next ) {
        if ( tcb->sleep_time < curr->sleep_time ) break;
    }

    if ( prev == nullptr ) {
        tcb->next = sleeping_queue;
        sleeping_queue = tcb;
    }
    else {
        tcb->next  = curr;
        prev->next = tcb;
    }
}

void Scheduler::update_sleeping () {
    TCB* curr = sleeping_queue;
    TCB* prev = nullptr;

    while ( curr != nullptr ) {
        if ( --curr->sleep_time == 0 ) {
            TCB* to_wake = curr;

            if ( prev == nullptr )
                sleeping_queue = curr->next;
            else
                prev->next = curr->next;

            curr = curr->next;

            put ( to_wake );
        }
        else {
            prev = curr;
            curr = curr->next;
        }
    }
}
