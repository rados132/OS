#include "../inc/TCB.hpp"
#include "../inc/Scheduler.hpp"
#include "../inc/MemoryAllocator.hpp"
#include "../inc/syscall_c.hpp"
#include "../inc/riscv.hpp"

extern "C" void pop_spp_spie   ();
extern "C" void context_switch ( Context* ctx_old, Context* ctx_new );

TCB*   TCB::running  = nullptr;
TCB*   TCB::dying    = nullptr;
time_t TCB::cpu_time = 0;

TCB::TCB ( thread_body t_body, void* arg, void* stack_space, bool priveleged )
    : body( t_body ), arg( arg ), stack( nullptr ), next( nullptr ), finished( false ), sleep_time( 0 )
{ 
    if ( body != nullptr ) {
        this->stack      = ( uint64* ) stack_space;
        this->context.sp = ( uint64 ) (( char* ) stack_space + DEFAULT_STACK_SIZE );

        if ( priveleged )
            this->context.ra = ( uint64 ) &privileged_wrapper;
        else
            this->context.ra = ( uint64 ) &user_wrapper;

        Scheduler::put ( this );
    }
}

TCB::~TCB () {
    if ( stack != nullptr ) {
        MemoryAllocator::kfree ( stack );
    }
}

void TCB::yield () {
    TCB* curr = TCB::running;

    if ( !curr->finished && !curr->sem.blocked && curr->sleep_time == 0 )
        Scheduler::put ( curr );

    TCB::running = Scheduler::get ();

    context_switch ( &curr->context, &running->context );

    /* if previous thread was dying delete it */
    if ( TCB::dying ) {
        delete TCB::dying;
        TCB::dying = nullptr;
    }

    TCB::cpu_time = 0; // reset the cpu time for new thread
}

void TCB::finish () {
    // mark current thread as finished
    TCB::running->finished = true; 

    // set dying pointer to current thread
    TCB::dying = TCB::running;
    
    yield (); // let go of cpu
}

void TCB::user_wrapper () {
    TCB::cpu_time = 0; // reset the cpu time for new thread

    pop_spp_spie (); // return to U mode, enable interrupts

    // run thread body with given arg
    TCB::running->body ( TCB::running->arg );

    thread_exit (); // kill thread after it's done
}

void TCB::privileged_wrapper () {
    TCB::cpu_time = 0; // reset the cpu time for new thread

    __asm__ volatile ("csrs sstatus, %[mask]" : : [mask] "r"( CSR::SSTATUS_SIE )); // enable interrupts

    // run thread body with given arg
    TCB::running->body ( TCB::running->arg );

    thread_exit (); // kill thread after it's done
}

void* TCB::operator new ( size_t size ) noexcept {
    return MemoryAllocator::kmalloc ( size );
}

void TCB::operator delete ( void* ptr ) {
    MemoryAllocator::kfree ( ptr );
}
