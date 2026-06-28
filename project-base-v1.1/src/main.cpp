#include "../h/MemoryAllocator.hpp"
#include "../h/RiscV.hpp"
#include "../h/syscall_c.hpp"
#include "../lib/console.h"
#include "../lib/hw.h"
#include "../test/printing.hpp"

extern "C" void trap_handler ();

void main () {

    // 1) instaliraj prekidnu rutinu (stvec -> trap_handler)
    RISC_V::w_stvec ((uint64)&trap_handler);

    print_str ("=== TEST START ===\n");

    // 2) alokacija (100 bajtova -> C API zaokružuje na blokove)
    char* p = (char*)mem_alloc (100);
    if (p == nullptr) {
        print_str ("alloc: FAILED (nullptr)\n");
        *((uint32*)0x100000) = 0x5555;
    }
    print_str ("alloc: OK\n");

    // 3) upiši pa pročitaj nazad -> potvrda da je prostor stvarno upotrebljiv
    for (int i = 0; i < 100; i++)
        p[i] = (char)(i & 0xFF);
    bool ok = true;
    for (int i = 0; i < 100; i++)
        if (p[i] != (char)(i & 0xFF))
            ok = false;
    print_str (ok ? "write/read: OK\n" : "write/read: FAILED\n");

    // 4) oslobađanje
    int r = mem_free (p);
    print_str (r == 0 ? "free: OK\n" : "free: FAILED\n");

    print_str ("=== TEST DONE ===\n");

    *((uint32*)0x100000) = 0x5555; // halt the emulator
}
