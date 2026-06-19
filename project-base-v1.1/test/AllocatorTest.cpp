#include "../lib/hw.h"
#include "../lib/console.h"
#include "../h/MemoryAllocator.hpp"

// =====================================================================
//  Pomocne funkcije
// =====================================================================

static int g_failures = 0;

static void put_str ( const char* s ) {
    while ( *s ) __putc ( *s++ );
}

// Ispisuje oznaku SAMO kada provera ne prodje. Tako svaki red izlaza
// jednoznacno pokazuje koji uslov je pukao (npr. "FAIL: T4.best_fit_3").
static void check ( bool ok, const char* tag ) {
    if ( !ok ) {
        put_str ( "FAIL: " );
        put_str ( tag );
        __putc ( '\n' );
        g_failures++;
    }
}

// Velicina zahteva (u bajtovima) koja zauzme TACNO k blokova:
//   needed = align_up(k*B - header + header) = align_up(k*B) = k*B
static size_t request_for_blocks ( size_t k ) {
    return k * MEM_BLOCK_SIZE - sizeof ( header_t );
}

// Poravnata, stvarno upotrebljiva velicina hipa (onako kako je vidi
// alokator: align_up(start) .. align_down(end)). DeterminisIcki, ne
// zavisi od poravnanja sirovih HEAP adresa.
static size_t usable_heap_size () {
    size_t s = ((( size_t ) HEAP_START_ADDR + MEM_BLOCK_SIZE - 1 ) / MEM_BLOCK_SIZE ) * MEM_BLOCK_SIZE;
    size_t e = (( size_t ) HEAP_END_ADDR / MEM_BLOCK_SIZE ) * MEM_BLOCK_SIZE;
    return e - s;
}

// Invarijanta posle svakog testa: hip mora biti SAV slobodan i potpuno
// spojen u jedan blok. Ako test nije sve oslobodio ili koalescencija nije
// potpuna, alokacija celog hipa ne uspeva i tag pokazuje POSLE kog testa
// je nastao problem.
static void assert_heap_whole ( MemoryAllocator& a, const char* tag ) {
    void* whole = a.k_malloc ( usable_heap_size () - sizeof ( header_t ) );
    check ( whole != nullptr, tag );
    if ( whole ) a.k_free ( whole );
}

// =====================================================================
//  Testovi
//  Pretpostavka: pri ulasku je hip kompletno slobodan (jedan blok).
// =====================================================================

int memory_allocator_test ( MemoryAllocator& allocator ) {

    g_failures = 0;

    // TEST 1: osnovni ciklus alokacija - upis - citanje - oslobadjanje -----
    {
        const int n = 10;
        char* arr = ( char* ) allocator.k_malloc ( n * sizeof ( char ) );
        check ( arr != nullptr, "T1.alloc" );

        if ( arr ) {
            for ( int i = 0; i < n; i++ ) arr[i] = 'k';
            bool ok = true;
            for ( int i = 0; i < n; i++ ) if ( arr[i] != 'k' ) ok = false;
            check ( ok, "T1.content" );
            check ( allocator.k_free ( arr ) == 0, "T1.free" );
        }
    }
    assert_heap_whole ( allocator, "T1.leak" );

    // TEST 2: out-of-memory i potpun povracaj -----------------------------
    {
        // Zauzmi ceo hip u jednom bloku.
        char* big = ( char* ) allocator.k_malloc ( usable_heap_size () - sizeof ( header_t ) );
        check ( big != nullptr, "T2.alloc_whole" );

        // Sad nema vise mesta ni za jedan bajt.
        char* none = ( char* ) allocator.k_malloc ( 1 );
        check ( none == nullptr, "T2.oom_when_full" );

        // Oslobodi veliki blok (pazi: drzimo handle u zasebnoj promenljivoj!).
        check ( allocator.k_free ( big ) == 0, "T2.free_whole" );

        // Posle oslobadjanja alokacija opet radi.
        char* again = ( char* ) allocator.k_malloc ( 1 );
        check ( again != nullptr, "T2.realloc_after_free" );
        if ( again ) allocator.k_free ( again );
    }
    assert_heap_whole ( allocator, "T2.leak" );

    // TEST 3: oslobadjanje nullptr (mora vratiti 0, bez pada) -------------
    {
        check ( allocator.k_free ( nullptr ) == 0, "T3.free_null" );
    }
    assert_heap_whole ( allocator, "T3.leak" );

    // TEST 4: best-fit bira NAJMANJU dovoljnu rupu ------------------------
    {
        // Raspored (po rastucoj adresi):  a(2) b(1) c(3) d(1) e(2) [rep]
        char* a = ( char* ) allocator.k_malloc ( request_for_blocks ( 2 ) );
        char* b = ( char* ) allocator.k_malloc ( request_for_blocks ( 1 ) );
        char* c = ( char* ) allocator.k_malloc ( request_for_blocks ( 3 ) );
        char* d = ( char* ) allocator.k_malloc ( request_for_blocks ( 1 ) );
        char* e = ( char* ) allocator.k_malloc ( request_for_blocks ( 2 ) );
        check ( a && b && c && d && e, "T4.setup" );

        // Rupe: a=2blk, c=3blk, e=2blk (+ veliki rep).
        allocator.k_free ( a );
        allocator.k_free ( c );
        allocator.k_free ( e );

        // Zahtev za 2 bloka -> mora uzeti prvu 2-blok rupu (a), ne rep.
        char* x2 = ( char* ) allocator.k_malloc ( request_for_blocks ( 2 ) );
        check ( x2 == a, "T4.best_fit_2" );

        // Zahtev za 3 bloka -> jedina 3-blok rupa je c.
        char* x3 = ( char* ) allocator.k_malloc ( request_for_blocks ( 3 ) );
        check ( x3 == c, "T4.best_fit_3" );

        // Ciscenje (e je vec slobodno; x2==a regija, x3==c regija).
        allocator.k_free ( x2 );
        allocator.k_free ( b );
        allocator.k_free ( x3 );
        allocator.k_free ( d );
    }
    assert_heap_whole ( allocator, "T4.leak" );

    // TEST 5: koalescencija sa OBA suseda (trostruko spajanje) ------------
    {
        // p1(2) p2(2) p3(2) sep(1) [rep] ; sep drzi rep odvojeno od p3.
        char* p1  = ( char* ) allocator.k_malloc ( request_for_blocks ( 2 ) );
        char* p2  = ( char* ) allocator.k_malloc ( request_for_blocks ( 2 ) );
        char* p3  = ( char* ) allocator.k_malloc ( request_for_blocks ( 2 ) );
        char* sep = ( char* ) allocator.k_malloc ( request_for_blocks ( 1 ) );
        check ( p1 && p2 && p3 && sep, "T5.setup" );

        allocator.k_free ( p1 );
        allocator.k_free ( p3 );
        allocator.k_free ( p2 );   // mora se spojiti i levo (p1) i desno (p3)

        // Sada postoji spojena rupa od 6 blokova koja pocinje na p1.
        char* merged = ( char* ) allocator.k_malloc ( request_for_blocks ( 6 ) );
        check ( merged == p1, "T5.coalesce_3way" );

        allocator.k_free ( merged );
        allocator.k_free ( sep );
    }
    assert_heap_whole ( allocator, "T5.leak" );

    // TEST 6: vise malih blokova - bez preklapanja (integritet sadrzaja) --
    {
        const int N = 16;
        char* blocks[16];

        bool alloc_ok = true;
        for ( int i = 0; i < N; i++ ) {
            blocks[i] = ( char* ) allocator.k_malloc ( N * sizeof ( char ) );
            if ( blocks[i] == nullptr ) alloc_ok = false;
        }
        check ( alloc_ok, "T6.alloc_all" );

        // Jedinstven sadrzaj po bloku.
        for ( int i = 0; i < N; i++ )
            if ( blocks[i] )
                for ( int j = 0; j < N; j++ ) blocks[i][j] = ( char ) ( 'A' + i );

        // Ako se blokovi preklapaju, neki bajt nece imati ocekivanu vrednost.
        bool intact = true;
        for ( int i = 0; i < N; i++ )
            if ( blocks[i] )
                for ( int j = 0; j < N; j++ )
                    if ( blocks[i][j] != ( char ) ( 'A' + i ) ) intact = false;
        check ( intact, "T6.no_overlap" );

        bool free_ok = true;
        for ( int i = 0; i < N; i++ )
            if ( blocks[i] && allocator.k_free ( blocks[i] ) != 0 ) free_ok = false;
        check ( free_ok, "T6.free_all" );
    }
    assert_heap_whole ( allocator, "T6.leak" );

    // TEST 7: granicni ulazi ----------------------------------------------
    {
        // Veci od celog hipa -> nullptr (i hip ostaje netaknut).
        char* too_big = ( char* ) allocator.k_malloc ( usable_heap_size () + MEM_BLOCK_SIZE );
        check ( too_big == nullptr, "T7.oversize" );

        // Nula bajtova -> nullptr (provera size <= 0 u k_malloc).
        char* zero = ( char* ) allocator.k_malloc ( 0 );
        check ( zero == nullptr, "T7.zero_size" );
    }
    assert_heap_whole ( allocator, "T7.leak" );

    // Rezime --------------------------------------------------------------
    if ( g_failures == 0 ) put_str ( "ALL TESTS OK\n" );
    else                   put_str ( "SOME TESTS FAILED\n" );

    return g_failures;
}
