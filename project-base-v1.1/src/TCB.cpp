#include "../h/TCB.hpp"
#include "../h/Scheduler.hpp"
#include "../h/MemoryAllocator.hpp"

extern "C" void context_switch ( Context* ctx_old, Context* ctx_new );

TCB* TCB::running = nullptr;
TCB* TCB::dying   = nullptr;

TCB::TCB ( thread_body t_body, void* arg, void* stack_space )
    : body( t_body ), arg( arg ), stack( nullptr ), next( nullptr ), finished( false )
{ 
    if ( body != nullptr ) {
        this->stack = ( uint64* ) stack_space;

        this->context.ra = ( uint64 ) &TCB::wrapper;
        this->context.sp = ( uint64 ) (( char* ) stack_space + DEFAULT_STACK_SIZE - 256 ); 

        Scheduler::put ( this );
    }
}

TCB::~TCB () {
    if ( stack != nullptr ) {
        MemoryAllocator::get_instance ().k_free ( stack );
    }
}

void TCB::yield () {
    // let go of cpu
    // allow other thread to execute

    TCB* curr = TCB::running;

    if ( !curr->finished ) Scheduler::put ( curr );

    TCB::running = Scheduler::get ();

    context_switch ( &curr->context, &running->context );

    if ( TCB::dying ) {
        delete TCB::dying; // if previous thread was dying delete it
        TCB::dying = nullptr;
    }
}

void TCB::finish () {
    if ( TCB::dying ) {
        delete TCB::dying; // if there was a dying thread delete it
        TCB::dying = TCB::running; // set current as dying
    }
    TCB::running->finished = true; 
    yield ();
}

void TCB::wrapper () {
    TCB::running->body ( TCB::running->arg );
    finish ();
}

void* TCB::operator new ( size_t size ) {
    return MemoryAllocator::get_instance ().k_malloc ( size );
}

void TCB::operator delete ( void* ptr ) {
    MemoryAllocator::get_instance ().k_free ( ptr );
}
