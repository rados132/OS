#include "../inc/KSemaphore.hpp"
#include "../inc/MemoryAllocator.hpp"
#include "../inc/TCB.hpp"
#include "../inc/Scheduler.hpp"

KSemaphore::KSemaphore ( unsigned permits )
    : val( permits ), blocked_head( nullptr ), blocked_tail( nullptr )
{
}

KSemaphore::~KSemaphore () {
    while ( blocked_head ) {
        blocked_head->sem.closed = true;
        unblock ();
    }
}

int KSemaphore::wait ( unsigned n ) {
    if ( val >= n ) {
        val -= n;
        return 0;
    }

    TCB::running->sem.waiting = n - val;

    val = 0;

    block ();

    if ( TCB::running->sem.closed )
        return -1;
    else
        return  0;
}

int KSemaphore::signal ( unsigned n ) {
    val += n;

    while ( blocked_head && val > 0 ) {
        if ( blocked_head->sem.waiting <= val ) {
            val -= blocked_head->sem.waiting;
            unblock ();
        }
        else {
            blocked_head->sem.waiting -= val;
            val = 0;
        }
    }

    return 0;
}

void KSemaphore::block () {
    TCB::running->sem.blocked = true;

    enqueue ( TCB::running );

    TCB::yield ();
}

void KSemaphore::unblock () {
    TCB* unblocked = dequeue ();

    unblocked->sem.blocked = false;
    unblocked->sem.waiting = 0;

    Scheduler::put ( unblocked );
}

void KSemaphore::enqueue ( TCB* blocked ) {
    blocked->next = nullptr;

    if ( blocked_tail ) blocked_tail->next = blocked;
    else                blocked_head       = blocked;

    blocked_tail = blocked;
}

TCB* KSemaphore::dequeue () {
    TCB* ret = blocked_head;
    
    if ( blocked_head && blocked_head->next )
        blocked_head = blocked_head->next;
    else
        blocked_head = blocked_tail = nullptr;
    
    ret->next = nullptr;
    return ret;
}

void* KSemaphore::operator new ( size_t size ) noexcept {
    return MemoryAllocator::kmalloc ( size );
}

void KSemaphore::operator delete ( void* ptr ) {
    MemoryAllocator::kfree ( ptr );
}
