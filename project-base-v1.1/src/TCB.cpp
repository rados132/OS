#include "../h/TCB.hpp"
#include "../h/RiscV.hpp"
#include "../h/Scheduler.hpp"

extern "C" void context_switch ( Context* old_ctx, Context* new_ctx );

TCB* TCB::running = nullptr;

TCB::TCB (thread_body t_body, void* arg, void* stack) :
    body( t_body ),
    arg( arg ),
    context( { ( uint64 ) body, ( uint64 ) (( char* ) stack + DEFAULT_STACK_SIZE ) } ),
    stack( ( uint64* ) stack ),
    next( nullptr ),
    finished( false )
{ 
    Scheduler::put ( this );
}

void TCB::yield () {

    RiscV::push_user_regs ();

    dispatch ();

    RiscV::pop_user_regs ();

}

void TCB::dispatch () {
    TCB* old = TCB::running;

    if ( !old->finished ) Scheduler::put ( old );

    TCB::running = Scheduler::get ();

    context_switch ( &old->context, &running->context );
}
