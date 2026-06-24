#include "printing.hpp"
#include "../lib/console.h"

void print_string(char const *string) {
    while (*string)
        __putc(*string++);
}

void print_int(int xx, int base, int sgn) {
    static const char digits[] = "0123456789abcdef";
    char buf[16];
    int i = 0;
    unsigned int x;

    if (sgn && xx < 0) {
        x = (unsigned int)(-xx);
    } else {
        x = (unsigned int)xx;
    }

    do {
        buf[i++] = digits[x % base];
    } while ((x /= base) != 0);

    if (sgn && xx < 0)
        buf[i++] = '-';

    while (--i >= 0)
        __putc(buf[i]);
}