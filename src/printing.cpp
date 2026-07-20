#include "../inc/printing.hpp"
#include "../inc/syscall_c.hpp"

void print_str ( char const* string ) {
    while ( *string ) putc ( *string++ );
}

void print_int (int xx, int base, int sgn ) {
    static const char digits[] = "0123456789abcdef";
    char buf[16];
    int i = 0;
    unsigned int x;

    if ( sgn && xx < 0 ) {
        x = ( unsigned int ) ( -xx );
    } else {
        x = ( unsigned int ) xx;
    }

    do {
        buf[i++] = digits[x % base];
    } while ( ( x /= base ) != 0) ;

    if ( sgn && xx < 0 ) buf[i++] = '-';

    if ( base == 16 ) {
        putc ( '0' );
        putc ( 'x' );
    }

    while ( --i >= 0 ) putc ( buf[i] );
}
