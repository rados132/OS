#include "../lib/console.h"

void main () {

    char c;
    do {
        c = __getc ();
        __putc (c);
    } while (1);
    
}
