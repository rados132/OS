#include "../inc/TCB.hpp"
#include "../inc/Scheduler.hpp"
#include "../inc/MemoryAllocator.hpp"
#include "../inc/syscall_c.hpp"

extern "C" void pop_spp_spie   ();
extern "C" void context_switch ( Context* ctx_old, Context* ctx_new );

TCB* TCB::running = nullptr;
TCB* TCB::dying   = nullptr;

TCB::TCB ( thread_body t_body, void* arg, void* stack_space )
    : body( t_body ), arg( arg ), stack( nullptr ), next( nullptr ), finished( false )
{ 
    if ( body != nullptr ) {
        this->stack = ( uint64* ) stack_space;

        this->context.ra = ( uint64 ) &wrapper; // set inital ret addr to wrapper function
        this->context.sp = ( uint64 ) (( char* ) stack_space + DEFAULT_STACK_SIZE ); 

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

    if ( !curr->finished && !curr->sem.blocked )
        Scheduler::put ( curr );

    TCB::running = Scheduler::get ();

    context_switch ( &curr->context, &running->context );

    if ( TCB::dying ) {
        delete TCB::dying; // if previous thread was dying delete it
        TCB::dying = nullptr;
    }
}

void TCB::finish () {
    // mark current thread as finished
    TCB::running->finished = true; 

    // set dying pointer to current thread
    TCB::dying = TCB::running;
    
    yield (); // let go of cpu
}

void TCB::wrapper () {
    // clear spp and spie, return to U-mode
    pop_spp_spie (); 

    // run thred body with given arg
    TCB::running->body ( TCB::running->arg );

    thread_exit (); // kill thread after it's done
}

void* TCB::operator new ( size_t size ) noexcept {
    return MemoryAllocator::kmalloc ( size );
}

void TCB::operator delete ( void* ptr ) {
    MemoryAllocator::kfree ( ptr );
}
