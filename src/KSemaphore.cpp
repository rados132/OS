#include "../inc/KSemaphore.hpp"

KSemaphore::KSemaphore ( unsigned permits )
    : internal_val( permits ), blocked( nullptr )
{
}

KSemaphore::~KSemaphore () {
    
}

int KSemaphore::wait ( unsigned n ) {
    if ( internal_val - n < 0 ) {
        
    }
}

int KSemaphore::signal ( unsigned n ) {
    return 0;
}
