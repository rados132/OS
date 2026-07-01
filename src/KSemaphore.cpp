#include "../inc/KSemaphore.hpp"
#include "../inc/MemoryAllocator.hpp"

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

void* KSemaphore::operator new ( size_t size ) {
    return MemoryAllocator::get_instance ().k_malloc ( size );
}

void KSemaphore::operator delete ( void* ptr ) {
    MemoryAllocator::get_instance ().k_free ( ptr );
}
