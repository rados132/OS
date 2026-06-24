#include "../h/TCB.hpp"

TCB* TCB::running = nullptr;

TCB::TCB (thread_body t_body, void* arg, void* stack) :
    body( t_body ),
    arg( arg ),
    context( {0, 0} ),
    stack( ( uint64* ) stack),
    next( nullptr ),
    finished( false )
{ }
