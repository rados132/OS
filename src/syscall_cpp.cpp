#include "../inc/syscall_cpp.hpp"

void* operator new ( size_t size ) {
    return mem_alloc ( size );
}

void operator delete ( void* ptr ) {
    mem_free ( ptr );
}

Thread::Thread ( void ( *body ) ( void* ), void* arg )
    : myHandle ( 0 ), body ( body ), arg ( arg )
{
}

Thread::Thread ()
    : myHandle ( 0 ), body ( nullptr ), arg ( nullptr )
{
}

Thread::~Thread () {}

void Thread::wrapper ( void* thread ) {
    Thread* self = ( Thread* ) thread;
    if ( self->body )
        self->body ( self->arg );
    else
        self->run ();
}

int Thread::start () {
    return thread_create ( &myHandle, &wrapper, this );
}

void Thread::dispatch () {
    thread_dispatch ();
}

int Thread::sleep ( time_t time ) {
    return time_sleep ( time );
}

PeriodicThread::PeriodicThread ( time_t period )
    : Thread(), period( period )
{
}

void PeriodicThread::terminate () {
    period = ( time_t ) -1;
}

void PeriodicThread::run () {
    time_t myPeriod = period;
    do {
        periodicActivation ();
        Thread::sleep ( myPeriod );
    }
    while ( period != ( time_t ) -1 );
}

Semaphore::Semaphore ( unsigned init )
    : myHandle ( 0 )
{
    sem_open ( &myHandle, init );
}

Semaphore::~Semaphore () {
    sem_close ( myHandle );
}

int Semaphore::wait () {
    return sem_wait ( myHandle );
}

int Semaphore::signal () {
    return sem_signal ( myHandle );
}

char Console::getc () {
    return ::getc ();
}

void Console::putc ( char c ) {
    ::putc ( c );
}
