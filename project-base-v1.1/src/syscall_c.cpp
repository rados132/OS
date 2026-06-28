#include "../h/syscall_c.hpp"

enum SysCallCode {
    MEM_ALLOC       = 0x01,
    MEM_FREE        = 0x02,
    THREAD_CREATE   = 0x11,
    THREAD_EXIT     = 0x12,
    THREAD_DISPATCH = 0x13,
};

uint64 sys_call ( uint64 code, uint64 arg1 = 0, uint64 arg2 = 0, uint64 arg3 = 0, uint64 arg4 = 0 ) {

    volatile uint64 ret;

    __asm__ volatile (
        "mv a0, %[a0]  \n"
        "mv a1, %[a1]  \n"
        "mv a2, %[a2]  \n"
        "mv a3, %[a3]  \n"
        "mv a4, %[a4]  \n"
        "ecall         \n"
        "mv %[ret], a0 \n"
        : [ret]  "=r"(ret)
        : [a0] "r"(code),
          [a1] "r"(arg1), [a2] "r"(arg2), [a3] "r"(arg3), [a4] "r"(arg4)
        : "a0", "a1", "a2", "a3", "a4", "memory"
    );

    return ret;
}

void* mem_alloc ( size_t size ) {
    return ( void* ) sys_call ( MEM_ALLOC, ( uint64 ) size ); // poravnanje na blokove?
}

int mem_free ( void* ptr ) {
    return ( int ) sys_call ( MEM_FREE, ( uint64 ) ptr );
}

int thread_create ( thread_t* handle, void ( *start_routine ) ( void* ), void* arg ) {
    // allocate memory for thread's stack
    void* stack_space = mem_alloc ( DEFAULT_STACK_SIZE );

    if ( stack_space == nullptr ) return -1; // if alloc fails return error code

    return ( int ) sys_call ( 
                                THREAD_CREATE, 
                                ( uint64 ) handle, 
                                ( uint64 ) start_routine, 
                                ( uint64 ) arg, 
                                ( uint64 ) stack_space 
                            );
}

int thread_exit () {
    return ( int ) sys_call ( THREAD_EXIT );
}

void thread_dispatch () {
    sys_call ( THREAD_DISPATCH );
}
