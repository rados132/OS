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
    SEM_OPEN        = 0x21,
    SEM_CLOSE       = 0x22,
    SEM_WAIT        = 0x23,
    SEM_SIGNAL      = 0x24,
    SEM_WAIT_N      = 0x25,
    SEM_SIGNAL_N    = 0x26,
    TIME_SLEEP      = 0x31,
    CONSOLE_GETC    = 0x41,
    CONSOLE_PUTC    = 0x42,
};


/* Memory allocation */
void* mem_alloc ( size_t size );

int   mem_free  ( void* ptr );


/* Thread management */
class   TCB;
typedef TCB* thread_t;

int  thread_create   ( thread_t* handle, void ( *start_routine ) ( void* ), void* arg );

int  thread_exit     ();

void thread_dispatch ();


/* Sempahore */
class   KSemaphore;
typedef KSemaphore* sem_t;

int sem_open     ( sem_t* handle, unsigned init );

int sem_close    ( sem_t handle );

int sem_wait     ( sem_t id );

int sem_signal   ( sem_t id );

int sem_wait_n   ( sem_t id, unsigned n );

int sem_signal_n ( sem_t id, unsigned n );


/* sleep */
typedef unsigned long time_t;

int time_sleep ( time_t );


/* Console */
const int EOF = -1;

char getc ();

void putc ( char );

#endif
