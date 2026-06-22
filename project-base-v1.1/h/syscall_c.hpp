#ifndef SYS_CALL_C_HPP
#define SYS_CALL_C_HPP

#include "../lib/hw.h"

/*
 *  C API
 */


// memory allocation

void* mem_alloc ( size_t size );

int   mem_free  ( void* ptr );


// thread menagement

class _thread;

typedef _thread* thread_t;

int thread_create ( thread_t* handle, void ( *start_routine ) ( void* ), void* arg );

#endif
