#include "../h/TCB.hpp"
#include "../h/Scheduler.hpp"

extern "C" void context_switch ( Context* ctx_old, Context* ctx_new );

TCB* TCB::running = nullptr;

TCB::TCB ( thread_body t_body, void* arg, void* stack_space )
    : body( t_body ), arg( arg ), stack( nullptr ), next( nullptr ), finished( false )
{ 
    if ( body != nullptr ) {
        this->stack = ( uint64* ) (( char* ) stack_space + DEFAULT_STACK_SIZE ); // must be aligned to 16B
    }

    Scheduler::put ( this );
}

void TCB::yield () {
    // let go of cpu
    // allow other thread to execute

    TCB* curr = TCB::running;

    if ( !curr->finished ) Scheduler::put ( curr );

    TCB::running = Scheduler::get ();

    context_switch ( &curr->context, &running->context );
}

void TCB::finish () { TCB::running->finished = true; }
