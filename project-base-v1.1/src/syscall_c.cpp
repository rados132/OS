#include "../h/syscall_c.hpp"

uint64 sys_call ( uint64 syscall, uint64 arg ) {

    uint64 ret;

    __asm__ volatile (
        "mv a0, %[a0] \n"
        "mv a1, %[a1] \n"
        "ecall          \n"
        "mv %[ret], a0  \n"
        : [ret]  "=r"(ret)
        : [a0] "r"(syscall), [a1] "r"(arg)
        : "a0", "a1", "memory"
    );

    return ret;
}

void* mem_alloc ( size_t size ) {
    return ( void* ) sys_call ( 0x01, size ); // poravnanje na blokove?
}

int mem_free ( void* ptr ) {
    return ( int ) sys_call ( 0x02, ( uint64 ) ptr );
}
