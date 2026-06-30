#ifndef SYS_CALL_C_HPP
#define SYS_CALL_C_HPP

#include "../lib/hw.h"


/*==============================================*
 *                    C API                     *
 *==============================================*/


enum SysCallCode {
    MEM_ALLOC       = 0x01,
    MEM_FREE        = 0x02,
    THREAD_CREATE   = 0x11,
    THREAD_EXIT     = 0x12,
    THREAD_DISPATCH = 0x13,
};


/* Memory allocation */
void* mem_alloc ( size_t size );

int   mem_free  ( void* ptr );


/* Thread management */
class   TCB;
typedef TCB _thread;

typedef _thread* thread_t;

int  thread_create   ( thread_t* handle, void ( *start_routine ) ( void* ), void* arg );

int  thread_exit     ();

void thread_dispatch ();

#endif
