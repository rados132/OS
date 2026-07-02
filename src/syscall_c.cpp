#include "../inc/syscall_c.hpp"
#include "../lib/console.h"

uint64 sys_call ( uint64 code, uint64 arg1 = 0, uint64 arg2 = 0, uint64 arg3 = 0, uint64 arg4 = 0 ) {

    volatile uint64 ret;

    __asm__ volatile (
        "mv a0, %[code]  \n"
        "mv a1, %[arg1]  \n"
        "mv a2, %[arg2]  \n"
        "mv a3, %[arg3]  \n"
        "mv a4, %[arg4]  \n"
        "ecall           \n"
        "mv %[ret], a0   \n"
        : [ret]  "=r"(ret)
        : [code] "r"(code),
          [arg1] "r"(arg1), [arg2] "r"(arg2), [arg3] "r"(arg3), [arg4] "r"(arg4)
        : "a0", "a1", "a2", "a3", "a4", "memory"
    );

    return ret;
}

void* mem_alloc ( size_t size ) {
    return ( void* ) sys_call ( MEM_ALLOC, ( uint64 ) size );
}

int mem_free ( void* ptr ) {
    return ( int ) sys_call ( MEM_FREE, ( uint64 ) ptr );
}

int thread_create ( thread_t* handle, void ( *start_routine ) ( void* ), void* arg ) {
    // allocate memory for thread's stack
    void* stack_space = mem_alloc ( DEFAULT_STACK_SIZE );

    if ( stack_space == nullptr ) return -1; // if alloc fails return error code

    int ret = ( int ) sys_call ( 
                                THREAD_CREATE, 
                                ( uint64 ) handle, 
                                ( uint64 ) start_routine, 
                                ( uint64 ) arg, 
                                ( uint64 ) stack_space 
                            );
    if ( ret < 0 ) mem_free ( stack_space ); // if thread_create fails, free stack mem
    return ret;
}

int thread_exit () {
    return ( int ) sys_call ( THREAD_EXIT );
}

void thread_dispatch () {
    sys_call ( THREAD_DISPATCH );
}

int sem_open ( sem_t* handle, unsigned init ) {
    return ( int ) sys_call ( SEM_OPEN, ( uint64 ) handle, ( uint64 ) init );
}

int sem_close ( sem_t handle ) {
    return ( int ) sys_call ( SEM_CLOSE, ( uint64 ) handle );
}

int sem_wait ( sem_t id ) {
    return ( int ) sys_call ( SEM_WAIT, ( uint64 ) id );
}

int sem_signal ( sem_t id ) {
    return ( int ) sys_call ( SEM_SIGNAL, ( uint64 ) id );
}

int sem_wait_n ( sem_t id, unsigned n ) {
    return ( int ) sys_call ( SEM_WAIT_N, ( uint64 ) id, ( uint64 ) n );
}

int sem_signal_n ( sem_t id, unsigned n ) {
    return ( int ) sys_call ( SEM_SIGNAL_N, ( uint64 ) id, ( uint64 ) n );
}

int time_sleep ( time_t time ) {
    return ( int ) sys_call ( TIME_SLEEP, ( uint64 ) time );
}

char getc () {
    return ( char ) sys_call ( CONSOLE_GETC );
}

void putc ( char c ) {
    sys_call ( CONSOLE_PUTC, ( uint64 ) c );
}
