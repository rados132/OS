#include "../inc/KSemaphore.hpp"

KSemaphore::KSemaphore (unsigned permits)
    : internal_val( permits ), blocked( nullptr )
{
}

KSemaphore::~KSemaphore () {
    
}
