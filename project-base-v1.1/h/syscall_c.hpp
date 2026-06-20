#ifndef _SYS_CALL_C_HPP_
#define _SYS_CALL_C_HPP_

#include "../lib/hw.h"

void* mem_alloc ( size_t size );

int   mem_free  ( void* ptr );

#endif
