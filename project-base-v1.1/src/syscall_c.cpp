#include "../h/syscall_c.hpp"

uint64 sys_call ( uint64 syscall, uint64 arg1 ) {

    uint64 ret;

    __asm__ volatile (
        "mv a0, %[code] \n"
        "mv a1, %[arg1] \n"
        "ecall          \n"
        "mv %[ret], a0  \n"
        : [ret]  "=r"(ret)
        : [code] "r"(syscall), [arg1] "r"(arg1)
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
