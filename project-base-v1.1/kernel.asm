
kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00004117          	auipc	sp,0x4
    80000004:	62013103          	ld	sp,1568(sp) # 80004620 <_GLOBAL_OFFSET_TABLE_+0x10>
    80000008:	00001537          	lui	a0,0x1
    8000000c:	f14025f3          	csrr	a1,mhartid
    80000010:	00158593          	addi	a1,a1,1
    80000014:	02b50533          	mul	a0,a0,a1
    80000018:	00a10133          	add	sp,sp,a0
    8000001c:	3d1010ef          	jal	ra,80001bec <start>

0000000080000020 <spin>:
    80000020:	0000006f          	j	80000020 <spin>
	...

0000000080001000 <trap_handler>:
.align 4
.global trap_handler
trap_handler:
    addi sp, sp, -16
    80001000:	ff010113          	addi	sp,sp,-16
    sd   t0, 0(sp)
    80001004:	00513023          	sd	t0,0(sp)
    csrr t0, sepc
    80001008:	141022f3          	csrr	t0,sepc
    addi t0, t0, 4
    8000100c:	00428293          	addi	t0,t0,4
    csrw sepc, t0
    80001010:	14129073          	csrw	sepc,t0
    ld   t0, 0(sp)
    80001014:	00013283          	ld	t0,0(sp)
    addi sp, sp, 16
    80001018:	01010113          	addi	sp,sp,16
    sret
    8000101c:	10200073          	sret
    80001020:	0000                	unimp
	...

0000000080001024 <_ZL18request_for_blocksm>:
    }
}

// Velicina zahteva (u bajtovima) koja zauzme TACNO k blokova:
//   needed = align_up(k*B - header + header) = align_up(k*B) = k*B
static size_t request_for_blocks ( size_t k ) {
    80001024:	ff010113          	addi	sp,sp,-16
    80001028:	00813423          	sd	s0,8(sp)
    8000102c:	01010413          	addi	s0,sp,16
    return k * MEM_BLOCK_SIZE - sizeof ( header_t );
    80001030:	00651513          	slli	a0,a0,0x6
}
    80001034:	ff850513          	addi	a0,a0,-8 # ff8 <_entry-0x7ffff008>
    80001038:	00813403          	ld	s0,8(sp)
    8000103c:	01010113          	addi	sp,sp,16
    80001040:	00008067          	ret

0000000080001044 <_ZL16usable_heap_sizev>:

// Poravnata, stvarno upotrebljiva velicina hipa (onako kako je vidi
// alokator: align_up(start) .. align_down(end)). DeterminisIcki, ne
// zavisi od poravnanja sirovih HEAP adresa.
static size_t usable_heap_size () {
    80001044:	ff010113          	addi	sp,sp,-16
    80001048:	00813423          	sd	s0,8(sp)
    8000104c:	01010413          	addi	s0,sp,16
    size_t s = ((( size_t ) HEAP_START_ADDR + MEM_BLOCK_SIZE - 1 ) / MEM_BLOCK_SIZE ) * MEM_BLOCK_SIZE;
    80001050:	00003797          	auipc	a5,0x3
    80001054:	5c87b783          	ld	a5,1480(a5) # 80004618 <_GLOBAL_OFFSET_TABLE_+0x8>
    80001058:	0007b783          	ld	a5,0(a5)
    8000105c:	03f78793          	addi	a5,a5,63
    80001060:	fc07f793          	andi	a5,a5,-64
    size_t e = (( size_t ) HEAP_END_ADDR / MEM_BLOCK_SIZE ) * MEM_BLOCK_SIZE;
    80001064:	00003717          	auipc	a4,0x3
    80001068:	5cc73703          	ld	a4,1484(a4) # 80004630 <_GLOBAL_OFFSET_TABLE_+0x20>
    8000106c:	00073503          	ld	a0,0(a4)
    80001070:	fc057513          	andi	a0,a0,-64
    return e - s;
}
    80001074:	40f50533          	sub	a0,a0,a5
    80001078:	00813403          	ld	s0,8(sp)
    8000107c:	01010113          	addi	sp,sp,16
    80001080:	00008067          	ret

0000000080001084 <_ZL7put_strPKc>:
static void put_str ( const char* s ) {
    80001084:	fe010113          	addi	sp,sp,-32
    80001088:	00113c23          	sd	ra,24(sp)
    8000108c:	00813823          	sd	s0,16(sp)
    80001090:	00913423          	sd	s1,8(sp)
    80001094:	02010413          	addi	s0,sp,32
    80001098:	00050493          	mv	s1,a0
    while ( *s ) __putc ( *s++ );
    8000109c:	0004c503          	lbu	a0,0(s1)
    800010a0:	00050a63          	beqz	a0,800010b4 <_ZL7put_strPKc+0x30>
    800010a4:	00148493          	addi	s1,s1,1
    800010a8:	00003097          	auipc	ra,0x3
    800010ac:	c04080e7          	jalr	-1020(ra) # 80003cac <__putc>
    800010b0:	fedff06f          	j	8000109c <_ZL7put_strPKc+0x18>
}
    800010b4:	01813083          	ld	ra,24(sp)
    800010b8:	01013403          	ld	s0,16(sp)
    800010bc:	00813483          	ld	s1,8(sp)
    800010c0:	02010113          	addi	sp,sp,32
    800010c4:	00008067          	ret

00000000800010c8 <_ZL5checkbPKc>:
    if ( !ok ) {
    800010c8:	00050463          	beqz	a0,800010d0 <_ZL5checkbPKc+0x8>
    800010cc:	00008067          	ret
static void check ( bool ok, const char* tag ) {
    800010d0:	fe010113          	addi	sp,sp,-32
    800010d4:	00113c23          	sd	ra,24(sp)
    800010d8:	00813823          	sd	s0,16(sp)
    800010dc:	00913423          	sd	s1,8(sp)
    800010e0:	02010413          	addi	s0,sp,32
    800010e4:	00058493          	mv	s1,a1
        put_str ( "FAIL: " );
    800010e8:	00003517          	auipc	a0,0x3
    800010ec:	f3850513          	addi	a0,a0,-200 # 80004020 <CONSOLE_STATUS+0x10>
    800010f0:	00000097          	auipc	ra,0x0
    800010f4:	f94080e7          	jalr	-108(ra) # 80001084 <_ZL7put_strPKc>
        put_str ( tag );
    800010f8:	00048513          	mv	a0,s1
    800010fc:	00000097          	auipc	ra,0x0
    80001100:	f88080e7          	jalr	-120(ra) # 80001084 <_ZL7put_strPKc>
        __putc ( '\n' );
    80001104:	00a00513          	li	a0,10
    80001108:	00003097          	auipc	ra,0x3
    8000110c:	ba4080e7          	jalr	-1116(ra) # 80003cac <__putc>
        g_failures++;
    80001110:	00003717          	auipc	a4,0x3
    80001114:	57070713          	addi	a4,a4,1392 # 80004680 <_ZL10g_failures>
    80001118:	00072783          	lw	a5,0(a4)
    8000111c:	0017879b          	addiw	a5,a5,1
    80001120:	00f72023          	sw	a5,0(a4)
}
    80001124:	01813083          	ld	ra,24(sp)
    80001128:	01013403          	ld	s0,16(sp)
    8000112c:	00813483          	ld	s1,8(sp)
    80001130:	02010113          	addi	sp,sp,32
    80001134:	00008067          	ret

0000000080001138 <_ZL17assert_heap_wholeR15MemoryAllocatorPKc>:

// Invarijanta posle svakog testa: hip mora biti SAV slobodan i potpuno
// spojen u jedan blok. Ako test nije sve oslobodio ili koalescencija nije
// potpuna, alokacija celog hipa ne uspeva i tag pokazuje POSLE kog testa
// je nastao problem.
static void assert_heap_whole ( MemoryAllocator& a, const char* tag ) {
    80001138:	fd010113          	addi	sp,sp,-48
    8000113c:	02113423          	sd	ra,40(sp)
    80001140:	02813023          	sd	s0,32(sp)
    80001144:	00913c23          	sd	s1,24(sp)
    80001148:	01213823          	sd	s2,16(sp)
    8000114c:	01313423          	sd	s3,8(sp)
    80001150:	03010413          	addi	s0,sp,48
    80001154:	00050913          	mv	s2,a0
    80001158:	00058993          	mv	s3,a1
    void* whole = a.k_malloc ( usable_heap_size () - sizeof ( header_t ) );
    8000115c:	00000097          	auipc	ra,0x0
    80001160:	ee8080e7          	jalr	-280(ra) # 80001044 <_ZL16usable_heap_sizev>
    80001164:	ff850593          	addi	a1,a0,-8
    80001168:	00090513          	mv	a0,s2
    8000116c:	00001097          	auipc	ra,0x1
    80001170:	83c080e7          	jalr	-1988(ra) # 800019a8 <_ZN15MemoryAllocator8k_mallocEm>
    80001174:	00050493          	mv	s1,a0
    check ( whole != nullptr, tag );
    80001178:	00098593          	mv	a1,s3
    8000117c:	00a03533          	snez	a0,a0
    80001180:	00000097          	auipc	ra,0x0
    80001184:	f48080e7          	jalr	-184(ra) # 800010c8 <_ZL5checkbPKc>
    if ( whole ) a.k_free ( whole );
    80001188:	00048a63          	beqz	s1,8000119c <_ZL17assert_heap_wholeR15MemoryAllocatorPKc+0x64>
    8000118c:	00048593          	mv	a1,s1
    80001190:	00090513          	mv	a0,s2
    80001194:	00001097          	auipc	ra,0x1
    80001198:	94c080e7          	jalr	-1716(ra) # 80001ae0 <_ZN15MemoryAllocator6k_freeEPv>
}
    8000119c:	02813083          	ld	ra,40(sp)
    800011a0:	02013403          	ld	s0,32(sp)
    800011a4:	01813483          	ld	s1,24(sp)
    800011a8:	01013903          	ld	s2,16(sp)
    800011ac:	00813983          	ld	s3,8(sp)
    800011b0:	03010113          	addi	sp,sp,48
    800011b4:	00008067          	ret

00000000800011b8 <_Z21memory_allocator_testR15MemoryAllocator>:
// =====================================================================
//  Testovi
//  Pretpostavka: pri ulasku je hip kompletno slobodan (jedan blok).
// =====================================================================

int memory_allocator_test ( MemoryAllocator& allocator ) {
    800011b8:	f2010113          	addi	sp,sp,-224
    800011bc:	0c113c23          	sd	ra,216(sp)
    800011c0:	0c813823          	sd	s0,208(sp)
    800011c4:	0c913423          	sd	s1,200(sp)
    800011c8:	0d213023          	sd	s2,192(sp)
    800011cc:	0b313c23          	sd	s3,184(sp)
    800011d0:	0b413823          	sd	s4,176(sp)
    800011d4:	0b513423          	sd	s5,168(sp)
    800011d8:	0b613023          	sd	s6,160(sp)
    800011dc:	09713c23          	sd	s7,152(sp)
    800011e0:	09813823          	sd	s8,144(sp)
    800011e4:	09913423          	sd	s9,136(sp)
    800011e8:	0e010413          	addi	s0,sp,224
    800011ec:	00050493          	mv	s1,a0

    g_failures = 0;
    800011f0:	00003797          	auipc	a5,0x3
    800011f4:	4807a823          	sw	zero,1168(a5) # 80004680 <_ZL10g_failures>

    // TEST 1: osnovni ciklus alokacija - upis - citanje - oslobadjanje -----
    {
        const int n = 10;
        char* arr = ( char* ) allocator.k_malloc ( n * sizeof ( char ) );
    800011f8:	00a00593          	li	a1,10
    800011fc:	00000097          	auipc	ra,0x0
    80001200:	7ac080e7          	jalr	1964(ra) # 800019a8 <_ZN15MemoryAllocator8k_mallocEm>
    80001204:	00050913          	mv	s2,a0
        check ( arr != nullptr, "T1.alloc" );
    80001208:	00003597          	auipc	a1,0x3
    8000120c:	e2058593          	addi	a1,a1,-480 # 80004028 <CONSOLE_STATUS+0x18>
    80001210:	00a03533          	snez	a0,a0
    80001214:	00000097          	auipc	ra,0x0
    80001218:	eb4080e7          	jalr	-332(ra) # 800010c8 <_ZL5checkbPKc>

        if ( arr ) {
    8000121c:	08090463          	beqz	s2,800012a4 <_Z21memory_allocator_testR15MemoryAllocator+0xec>
            for ( int i = 0; i < n; i++ ) arr[i] = 'k';
    80001220:	00000793          	li	a5,0
    80001224:	00900713          	li	a4,9
    80001228:	00f74c63          	blt	a4,a5,80001240 <_Z21memory_allocator_testR15MemoryAllocator+0x88>
    8000122c:	00f90733          	add	a4,s2,a5
    80001230:	06b00693          	li	a3,107
    80001234:	00d70023          	sb	a3,0(a4)
    80001238:	0017879b          	addiw	a5,a5,1
    8000123c:	fe9ff06f          	j	80001224 <_Z21memory_allocator_testR15MemoryAllocator+0x6c>
            bool ok = true;
            for ( int i = 0; i < n; i++ ) if ( arr[i] != 'k' ) ok = false;
    80001240:	00000793          	li	a5,0
            bool ok = true;
    80001244:	00100513          	li	a0,1
    80001248:	0080006f          	j	80001250 <_Z21memory_allocator_testR15MemoryAllocator+0x98>
            for ( int i = 0; i < n; i++ ) if ( arr[i] != 'k' ) ok = false;
    8000124c:	0017879b          	addiw	a5,a5,1
    80001250:	00900713          	li	a4,9
    80001254:	00f74e63          	blt	a4,a5,80001270 <_Z21memory_allocator_testR15MemoryAllocator+0xb8>
    80001258:	00f90733          	add	a4,s2,a5
    8000125c:	00074683          	lbu	a3,0(a4)
    80001260:	06b00713          	li	a4,107
    80001264:	fee684e3          	beq	a3,a4,8000124c <_Z21memory_allocator_testR15MemoryAllocator+0x94>
    80001268:	00000513          	li	a0,0
    8000126c:	fe1ff06f          	j	8000124c <_Z21memory_allocator_testR15MemoryAllocator+0x94>
            check ( ok, "T1.content" );
    80001270:	00003597          	auipc	a1,0x3
    80001274:	dc858593          	addi	a1,a1,-568 # 80004038 <CONSOLE_STATUS+0x28>
    80001278:	00000097          	auipc	ra,0x0
    8000127c:	e50080e7          	jalr	-432(ra) # 800010c8 <_ZL5checkbPKc>
            check ( allocator.k_free ( arr ) == 0, "T1.free" );
    80001280:	00090593          	mv	a1,s2
    80001284:	00048513          	mv	a0,s1
    80001288:	00001097          	auipc	ra,0x1
    8000128c:	858080e7          	jalr	-1960(ra) # 80001ae0 <_ZN15MemoryAllocator6k_freeEPv>
    80001290:	00003597          	auipc	a1,0x3
    80001294:	db858593          	addi	a1,a1,-584 # 80004048 <CONSOLE_STATUS+0x38>
    80001298:	00153513          	seqz	a0,a0
    8000129c:	00000097          	auipc	ra,0x0
    800012a0:	e2c080e7          	jalr	-468(ra) # 800010c8 <_ZL5checkbPKc>
        }
    }
    assert_heap_whole ( allocator, "T1.leak" );
    800012a4:	00003597          	auipc	a1,0x3
    800012a8:	dac58593          	addi	a1,a1,-596 # 80004050 <CONSOLE_STATUS+0x40>
    800012ac:	00048513          	mv	a0,s1
    800012b0:	00000097          	auipc	ra,0x0
    800012b4:	e88080e7          	jalr	-376(ra) # 80001138 <_ZL17assert_heap_wholeR15MemoryAllocatorPKc>

    // TEST 2: out-of-memory i potpun povracaj -----------------------------
    {
        // Zauzmi ceo hip u jednom bloku.
        char* big = ( char* ) allocator.k_malloc ( usable_heap_size () - sizeof ( header_t ) );
    800012b8:	00000097          	auipc	ra,0x0
    800012bc:	d8c080e7          	jalr	-628(ra) # 80001044 <_ZL16usable_heap_sizev>
    800012c0:	ff850593          	addi	a1,a0,-8
    800012c4:	00048513          	mv	a0,s1
    800012c8:	00000097          	auipc	ra,0x0
    800012cc:	6e0080e7          	jalr	1760(ra) # 800019a8 <_ZN15MemoryAllocator8k_mallocEm>
    800012d0:	00050913          	mv	s2,a0
        check ( big != nullptr, "T2.alloc_whole" );
    800012d4:	00003597          	auipc	a1,0x3
    800012d8:	d8458593          	addi	a1,a1,-636 # 80004058 <CONSOLE_STATUS+0x48>
    800012dc:	00a03533          	snez	a0,a0
    800012e0:	00000097          	auipc	ra,0x0
    800012e4:	de8080e7          	jalr	-536(ra) # 800010c8 <_ZL5checkbPKc>

        // Sad nema vise mesta ni za jedan bajt.
        char* none = ( char* ) allocator.k_malloc ( 1 );
    800012e8:	00100593          	li	a1,1
    800012ec:	00048513          	mv	a0,s1
    800012f0:	00000097          	auipc	ra,0x0
    800012f4:	6b8080e7          	jalr	1720(ra) # 800019a8 <_ZN15MemoryAllocator8k_mallocEm>
        check ( none == nullptr, "T2.oom_when_full" );
    800012f8:	00003597          	auipc	a1,0x3
    800012fc:	d7058593          	addi	a1,a1,-656 # 80004068 <CONSOLE_STATUS+0x58>
    80001300:	00153513          	seqz	a0,a0
    80001304:	00000097          	auipc	ra,0x0
    80001308:	dc4080e7          	jalr	-572(ra) # 800010c8 <_ZL5checkbPKc>

        // Oslobodi veliki blok (pazi: drzimo handle u zasebnoj promenljivoj!).
        check ( allocator.k_free ( big ) == 0, "T2.free_whole" );
    8000130c:	00090593          	mv	a1,s2
    80001310:	00048513          	mv	a0,s1
    80001314:	00000097          	auipc	ra,0x0
    80001318:	7cc080e7          	jalr	1996(ra) # 80001ae0 <_ZN15MemoryAllocator6k_freeEPv>
    8000131c:	00003597          	auipc	a1,0x3
    80001320:	d6458593          	addi	a1,a1,-668 # 80004080 <CONSOLE_STATUS+0x70>
    80001324:	00153513          	seqz	a0,a0
    80001328:	00000097          	auipc	ra,0x0
    8000132c:	da0080e7          	jalr	-608(ra) # 800010c8 <_ZL5checkbPKc>

        // Posle oslobadjanja alokacija opet radi.
        char* again = ( char* ) allocator.k_malloc ( 1 );
    80001330:	00100593          	li	a1,1
    80001334:	00048513          	mv	a0,s1
    80001338:	00000097          	auipc	ra,0x0
    8000133c:	670080e7          	jalr	1648(ra) # 800019a8 <_ZN15MemoryAllocator8k_mallocEm>
    80001340:	00050913          	mv	s2,a0
        check ( again != nullptr, "T2.realloc_after_free" );
    80001344:	00003597          	auipc	a1,0x3
    80001348:	d4c58593          	addi	a1,a1,-692 # 80004090 <CONSOLE_STATUS+0x80>
    8000134c:	00a03533          	snez	a0,a0
    80001350:	00000097          	auipc	ra,0x0
    80001354:	d78080e7          	jalr	-648(ra) # 800010c8 <_ZL5checkbPKc>
        if ( again ) allocator.k_free ( again );
    80001358:	00090a63          	beqz	s2,8000136c <_Z21memory_allocator_testR15MemoryAllocator+0x1b4>
    8000135c:	00090593          	mv	a1,s2
    80001360:	00048513          	mv	a0,s1
    80001364:	00000097          	auipc	ra,0x0
    80001368:	77c080e7          	jalr	1916(ra) # 80001ae0 <_ZN15MemoryAllocator6k_freeEPv>
    }
    assert_heap_whole ( allocator, "T2.leak" );
    8000136c:	00003597          	auipc	a1,0x3
    80001370:	d3c58593          	addi	a1,a1,-708 # 800040a8 <CONSOLE_STATUS+0x98>
    80001374:	00048513          	mv	a0,s1
    80001378:	00000097          	auipc	ra,0x0
    8000137c:	dc0080e7          	jalr	-576(ra) # 80001138 <_ZL17assert_heap_wholeR15MemoryAllocatorPKc>

    // TEST 3: oslobadjanje nullptr (mora vratiti 0, bez pada) -------------
    {
        check ( allocator.k_free ( nullptr ) == 0, "T3.free_null" );
    80001380:	00000593          	li	a1,0
    80001384:	00048513          	mv	a0,s1
    80001388:	00000097          	auipc	ra,0x0
    8000138c:	758080e7          	jalr	1880(ra) # 80001ae0 <_ZN15MemoryAllocator6k_freeEPv>
    80001390:	00003597          	auipc	a1,0x3
    80001394:	d2058593          	addi	a1,a1,-736 # 800040b0 <CONSOLE_STATUS+0xa0>
    80001398:	00153513          	seqz	a0,a0
    8000139c:	00000097          	auipc	ra,0x0
    800013a0:	d2c080e7          	jalr	-724(ra) # 800010c8 <_ZL5checkbPKc>
    }
    assert_heap_whole ( allocator, "T3.leak" );
    800013a4:	00003597          	auipc	a1,0x3
    800013a8:	d1c58593          	addi	a1,a1,-740 # 800040c0 <CONSOLE_STATUS+0xb0>
    800013ac:	00048513          	mv	a0,s1
    800013b0:	00000097          	auipc	ra,0x0
    800013b4:	d88080e7          	jalr	-632(ra) # 80001138 <_ZL17assert_heap_wholeR15MemoryAllocatorPKc>

    // TEST 4: best-fit bira NAJMANJU dovoljnu rupu ------------------------
    {
        // Raspored (po rastucoj adresi):  a(2) b(1) c(3) d(1) e(2) [rep]
        char* a = ( char* ) allocator.k_malloc ( request_for_blocks ( 2 ) );
    800013b8:	00200513          	li	a0,2
    800013bc:	00000097          	auipc	ra,0x0
    800013c0:	c68080e7          	jalr	-920(ra) # 80001024 <_ZL18request_for_blocksm>
    800013c4:	00050913          	mv	s2,a0
    800013c8:	00050593          	mv	a1,a0
    800013cc:	00048513          	mv	a0,s1
    800013d0:	00000097          	auipc	ra,0x0
    800013d4:	5d8080e7          	jalr	1496(ra) # 800019a8 <_ZN15MemoryAllocator8k_mallocEm>
    800013d8:	00050993          	mv	s3,a0
        char* b = ( char* ) allocator.k_malloc ( request_for_blocks ( 1 ) );
    800013dc:	00100513          	li	a0,1
    800013e0:	00000097          	auipc	ra,0x0
    800013e4:	c44080e7          	jalr	-956(ra) # 80001024 <_ZL18request_for_blocksm>
    800013e8:	00050a93          	mv	s5,a0
    800013ec:	00050593          	mv	a1,a0
    800013f0:	00048513          	mv	a0,s1
    800013f4:	00000097          	auipc	ra,0x0
    800013f8:	5b4080e7          	jalr	1460(ra) # 800019a8 <_ZN15MemoryAllocator8k_mallocEm>
    800013fc:	00050b93          	mv	s7,a0
        char* c = ( char* ) allocator.k_malloc ( request_for_blocks ( 3 ) );
    80001400:	00300513          	li	a0,3
    80001404:	00000097          	auipc	ra,0x0
    80001408:	c20080e7          	jalr	-992(ra) # 80001024 <_ZL18request_for_blocksm>
    8000140c:	00050c93          	mv	s9,a0
    80001410:	00050593          	mv	a1,a0
    80001414:	00048513          	mv	a0,s1
    80001418:	00000097          	auipc	ra,0x0
    8000141c:	590080e7          	jalr	1424(ra) # 800019a8 <_ZN15MemoryAllocator8k_mallocEm>
    80001420:	00050a13          	mv	s4,a0
        char* d = ( char* ) allocator.k_malloc ( request_for_blocks ( 1 ) );
    80001424:	000a8593          	mv	a1,s5
    80001428:	00048513          	mv	a0,s1
    8000142c:	00000097          	auipc	ra,0x0
    80001430:	57c080e7          	jalr	1404(ra) # 800019a8 <_ZN15MemoryAllocator8k_mallocEm>
    80001434:	00050c13          	mv	s8,a0
        char* e = ( char* ) allocator.k_malloc ( request_for_blocks ( 2 ) );
    80001438:	00090593          	mv	a1,s2
    8000143c:	00048513          	mv	a0,s1
    80001440:	00000097          	auipc	ra,0x0
    80001444:	568080e7          	jalr	1384(ra) # 800019a8 <_ZN15MemoryAllocator8k_mallocEm>
    80001448:	00050b13          	mv	s6,a0
        check ( a && b && c && d && e, "T4.setup" );
    8000144c:	02098263          	beqz	s3,80001470 <_Z21memory_allocator_testR15MemoryAllocator+0x2b8>
    80001450:	160b8c63          	beqz	s7,800015c8 <_Z21memory_allocator_testR15MemoryAllocator+0x410>
    80001454:	160a0e63          	beqz	s4,800015d0 <_Z21memory_allocator_testR15MemoryAllocator+0x418>
    80001458:	180c0063          	beqz	s8,800015d8 <_Z21memory_allocator_testR15MemoryAllocator+0x420>
    8000145c:	00050663          	beqz	a0,80001468 <_Z21memory_allocator_testR15MemoryAllocator+0x2b0>
    80001460:	00100513          	li	a0,1
    80001464:	0100006f          	j	80001474 <_Z21memory_allocator_testR15MemoryAllocator+0x2bc>
    80001468:	00000513          	li	a0,0
    8000146c:	0080006f          	j	80001474 <_Z21memory_allocator_testR15MemoryAllocator+0x2bc>
    80001470:	00000513          	li	a0,0
    80001474:	00003597          	auipc	a1,0x3
    80001478:	c5458593          	addi	a1,a1,-940 # 800040c8 <CONSOLE_STATUS+0xb8>
    8000147c:	00000097          	auipc	ra,0x0
    80001480:	c4c080e7          	jalr	-948(ra) # 800010c8 <_ZL5checkbPKc>

        // Rupe: a=2blk, c=3blk, e=2blk (+ veliki rep).
        allocator.k_free ( a );
    80001484:	00098593          	mv	a1,s3
    80001488:	00048513          	mv	a0,s1
    8000148c:	00000097          	auipc	ra,0x0
    80001490:	654080e7          	jalr	1620(ra) # 80001ae0 <_ZN15MemoryAllocator6k_freeEPv>
        allocator.k_free ( c );
    80001494:	000a0593          	mv	a1,s4
    80001498:	00048513          	mv	a0,s1
    8000149c:	00000097          	auipc	ra,0x0
    800014a0:	644080e7          	jalr	1604(ra) # 80001ae0 <_ZN15MemoryAllocator6k_freeEPv>
        allocator.k_free ( e );
    800014a4:	000b0593          	mv	a1,s6
    800014a8:	00048513          	mv	a0,s1
    800014ac:	00000097          	auipc	ra,0x0
    800014b0:	634080e7          	jalr	1588(ra) # 80001ae0 <_ZN15MemoryAllocator6k_freeEPv>

        // Zahtev za 2 bloka -> mora uzeti prvu 2-blok rupu (a), ne rep.
        char* x2 = ( char* ) allocator.k_malloc ( request_for_blocks ( 2 ) );
    800014b4:	00090593          	mv	a1,s2
    800014b8:	00048513          	mv	a0,s1
    800014bc:	00000097          	auipc	ra,0x0
    800014c0:	4ec080e7          	jalr	1260(ra) # 800019a8 <_ZN15MemoryAllocator8k_mallocEm>
    800014c4:	00050b13          	mv	s6,a0
        check ( x2 == a, "T4.best_fit_2" );
    800014c8:	40a989b3          	sub	s3,s3,a0
    800014cc:	00003597          	auipc	a1,0x3
    800014d0:	c0c58593          	addi	a1,a1,-1012 # 800040d8 <CONSOLE_STATUS+0xc8>
    800014d4:	0019b513          	seqz	a0,s3
    800014d8:	00000097          	auipc	ra,0x0
    800014dc:	bf0080e7          	jalr	-1040(ra) # 800010c8 <_ZL5checkbPKc>

        // Zahtev za 3 bloka -> jedina 3-blok rupa je c.
        char* x3 = ( char* ) allocator.k_malloc ( request_for_blocks ( 3 ) );
    800014e0:	000c8593          	mv	a1,s9
    800014e4:	00048513          	mv	a0,s1
    800014e8:	00000097          	auipc	ra,0x0
    800014ec:	4c0080e7          	jalr	1216(ra) # 800019a8 <_ZN15MemoryAllocator8k_mallocEm>
    800014f0:	00050993          	mv	s3,a0
        check ( x3 == c, "T4.best_fit_3" );
    800014f4:	40aa0a33          	sub	s4,s4,a0
    800014f8:	00003597          	auipc	a1,0x3
    800014fc:	bf058593          	addi	a1,a1,-1040 # 800040e8 <CONSOLE_STATUS+0xd8>
    80001500:	001a3513          	seqz	a0,s4
    80001504:	00000097          	auipc	ra,0x0
    80001508:	bc4080e7          	jalr	-1084(ra) # 800010c8 <_ZL5checkbPKc>

        // Ciscenje (e je vec slobodno; x2==a regija, x3==c regija).
        allocator.k_free ( x2 );
    8000150c:	000b0593          	mv	a1,s6
    80001510:	00048513          	mv	a0,s1
    80001514:	00000097          	auipc	ra,0x0
    80001518:	5cc080e7          	jalr	1484(ra) # 80001ae0 <_ZN15MemoryAllocator6k_freeEPv>
        allocator.k_free ( b );
    8000151c:	000b8593          	mv	a1,s7
    80001520:	00048513          	mv	a0,s1
    80001524:	00000097          	auipc	ra,0x0
    80001528:	5bc080e7          	jalr	1468(ra) # 80001ae0 <_ZN15MemoryAllocator6k_freeEPv>
        allocator.k_free ( x3 );
    8000152c:	00098593          	mv	a1,s3
    80001530:	00048513          	mv	a0,s1
    80001534:	00000097          	auipc	ra,0x0
    80001538:	5ac080e7          	jalr	1452(ra) # 80001ae0 <_ZN15MemoryAllocator6k_freeEPv>
        allocator.k_free ( d );
    8000153c:	000c0593          	mv	a1,s8
    80001540:	00048513          	mv	a0,s1
    80001544:	00000097          	auipc	ra,0x0
    80001548:	59c080e7          	jalr	1436(ra) # 80001ae0 <_ZN15MemoryAllocator6k_freeEPv>
    }
    assert_heap_whole ( allocator, "T4.leak" );
    8000154c:	00003597          	auipc	a1,0x3
    80001550:	bac58593          	addi	a1,a1,-1108 # 800040f8 <CONSOLE_STATUS+0xe8>
    80001554:	00048513          	mv	a0,s1
    80001558:	00000097          	auipc	ra,0x0
    8000155c:	be0080e7          	jalr	-1056(ra) # 80001138 <_ZL17assert_heap_wholeR15MemoryAllocatorPKc>

    // TEST 5: koalescencija sa OBA suseda (trostruko spajanje) ------------
    {
        // p1(2) p2(2) p3(2) sep(1) [rep] ; sep drzi rep odvojeno od p3.
        char* p1  = ( char* ) allocator.k_malloc ( request_for_blocks ( 2 ) );
    80001560:	00090593          	mv	a1,s2
    80001564:	00048513          	mv	a0,s1
    80001568:	00000097          	auipc	ra,0x0
    8000156c:	440080e7          	jalr	1088(ra) # 800019a8 <_ZN15MemoryAllocator8k_mallocEm>
    80001570:	00050993          	mv	s3,a0
        char* p2  = ( char* ) allocator.k_malloc ( request_for_blocks ( 2 ) );
    80001574:	00090593          	mv	a1,s2
    80001578:	00048513          	mv	a0,s1
    8000157c:	00000097          	auipc	ra,0x0
    80001580:	42c080e7          	jalr	1068(ra) # 800019a8 <_ZN15MemoryAllocator8k_mallocEm>
    80001584:	00050a13          	mv	s4,a0
        char* p3  = ( char* ) allocator.k_malloc ( request_for_blocks ( 2 ) );
    80001588:	00090593          	mv	a1,s2
    8000158c:	00048513          	mv	a0,s1
    80001590:	00000097          	auipc	ra,0x0
    80001594:	418080e7          	jalr	1048(ra) # 800019a8 <_ZN15MemoryAllocator8k_mallocEm>
    80001598:	00050913          	mv	s2,a0
        char* sep = ( char* ) allocator.k_malloc ( request_for_blocks ( 1 ) );
    8000159c:	000a8593          	mv	a1,s5
    800015a0:	00048513          	mv	a0,s1
    800015a4:	00000097          	auipc	ra,0x0
    800015a8:	404080e7          	jalr	1028(ra) # 800019a8 <_ZN15MemoryAllocator8k_mallocEm>
    800015ac:	00050a93          	mv	s5,a0
        check ( p1 && p2 && p3 && sep, "T5.setup" );
    800015b0:	02098c63          	beqz	s3,800015e8 <_Z21memory_allocator_testR15MemoryAllocator+0x430>
    800015b4:	0e0a0863          	beqz	s4,800016a4 <_Z21memory_allocator_testR15MemoryAllocator+0x4ec>
    800015b8:	0e090a63          	beqz	s2,800016ac <_Z21memory_allocator_testR15MemoryAllocator+0x4f4>
    800015bc:	02050263          	beqz	a0,800015e0 <_Z21memory_allocator_testR15MemoryAllocator+0x428>
    800015c0:	00100513          	li	a0,1
    800015c4:	0280006f          	j	800015ec <_Z21memory_allocator_testR15MemoryAllocator+0x434>
        check ( a && b && c && d && e, "T4.setup" );
    800015c8:	00000513          	li	a0,0
    800015cc:	ea9ff06f          	j	80001474 <_Z21memory_allocator_testR15MemoryAllocator+0x2bc>
    800015d0:	00000513          	li	a0,0
    800015d4:	ea1ff06f          	j	80001474 <_Z21memory_allocator_testR15MemoryAllocator+0x2bc>
    800015d8:	00000513          	li	a0,0
    800015dc:	e99ff06f          	j	80001474 <_Z21memory_allocator_testR15MemoryAllocator+0x2bc>
        check ( p1 && p2 && p3 && sep, "T5.setup" );
    800015e0:	00000513          	li	a0,0
    800015e4:	0080006f          	j	800015ec <_Z21memory_allocator_testR15MemoryAllocator+0x434>
    800015e8:	00000513          	li	a0,0
    800015ec:	00003597          	auipc	a1,0x3
    800015f0:	b1458593          	addi	a1,a1,-1260 # 80004100 <CONSOLE_STATUS+0xf0>
    800015f4:	00000097          	auipc	ra,0x0
    800015f8:	ad4080e7          	jalr	-1324(ra) # 800010c8 <_ZL5checkbPKc>

        allocator.k_free ( p1 );
    800015fc:	00098593          	mv	a1,s3
    80001600:	00048513          	mv	a0,s1
    80001604:	00000097          	auipc	ra,0x0
    80001608:	4dc080e7          	jalr	1244(ra) # 80001ae0 <_ZN15MemoryAllocator6k_freeEPv>
        allocator.k_free ( p3 );
    8000160c:	00090593          	mv	a1,s2
    80001610:	00048513          	mv	a0,s1
    80001614:	00000097          	auipc	ra,0x0
    80001618:	4cc080e7          	jalr	1228(ra) # 80001ae0 <_ZN15MemoryAllocator6k_freeEPv>
        allocator.k_free ( p2 );   // mora se spojiti i levo (p1) i desno (p3)
    8000161c:	000a0593          	mv	a1,s4
    80001620:	00048513          	mv	a0,s1
    80001624:	00000097          	auipc	ra,0x0
    80001628:	4bc080e7          	jalr	1212(ra) # 80001ae0 <_ZN15MemoryAllocator6k_freeEPv>

        // Sada postoji spojena rupa od 6 blokova koja pocinje na p1.
        char* merged = ( char* ) allocator.k_malloc ( request_for_blocks ( 6 ) );
    8000162c:	00600513          	li	a0,6
    80001630:	00000097          	auipc	ra,0x0
    80001634:	9f4080e7          	jalr	-1548(ra) # 80001024 <_ZL18request_for_blocksm>
    80001638:	00050593          	mv	a1,a0
    8000163c:	00048513          	mv	a0,s1
    80001640:	00000097          	auipc	ra,0x0
    80001644:	368080e7          	jalr	872(ra) # 800019a8 <_ZN15MemoryAllocator8k_mallocEm>
    80001648:	00050913          	mv	s2,a0
        check ( merged == p1, "T5.coalesce_3way" );
    8000164c:	40a989b3          	sub	s3,s3,a0
    80001650:	00003597          	auipc	a1,0x3
    80001654:	ac058593          	addi	a1,a1,-1344 # 80004110 <CONSOLE_STATUS+0x100>
    80001658:	0019b513          	seqz	a0,s3
    8000165c:	00000097          	auipc	ra,0x0
    80001660:	a6c080e7          	jalr	-1428(ra) # 800010c8 <_ZL5checkbPKc>

        allocator.k_free ( merged );
    80001664:	00090593          	mv	a1,s2
    80001668:	00048513          	mv	a0,s1
    8000166c:	00000097          	auipc	ra,0x0
    80001670:	474080e7          	jalr	1140(ra) # 80001ae0 <_ZN15MemoryAllocator6k_freeEPv>
        allocator.k_free ( sep );
    80001674:	000a8593          	mv	a1,s5
    80001678:	00048513          	mv	a0,s1
    8000167c:	00000097          	auipc	ra,0x0
    80001680:	464080e7          	jalr	1124(ra) # 80001ae0 <_ZN15MemoryAllocator6k_freeEPv>
    }
    assert_heap_whole ( allocator, "T5.leak" );
    80001684:	00003597          	auipc	a1,0x3
    80001688:	aa458593          	addi	a1,a1,-1372 # 80004128 <CONSOLE_STATUS+0x118>
    8000168c:	00048513          	mv	a0,s1
    80001690:	00000097          	auipc	ra,0x0
    80001694:	aa8080e7          	jalr	-1368(ra) # 80001138 <_ZL17assert_heap_wholeR15MemoryAllocatorPKc>
    {
        const int N = 16;
        char* blocks[16];

        bool alloc_ok = true;
        for ( int i = 0; i < N; i++ ) {
    80001698:	00000913          	li	s2,0
        bool alloc_ok = true;
    8000169c:	00100993          	li	s3,1
    800016a0:	0180006f          	j	800016b8 <_Z21memory_allocator_testR15MemoryAllocator+0x500>
        check ( p1 && p2 && p3 && sep, "T5.setup" );
    800016a4:	00000513          	li	a0,0
    800016a8:	f45ff06f          	j	800015ec <_Z21memory_allocator_testR15MemoryAllocator+0x434>
    800016ac:	00000513          	li	a0,0
    800016b0:	f3dff06f          	j	800015ec <_Z21memory_allocator_testR15MemoryAllocator+0x434>
        for ( int i = 0; i < N; i++ ) {
    800016b4:	0019091b          	addiw	s2,s2,1
    800016b8:	00f00793          	li	a5,15
    800016bc:	0327c863          	blt	a5,s2,800016ec <_Z21memory_allocator_testR15MemoryAllocator+0x534>
            blocks[i] = ( char* ) allocator.k_malloc ( N * sizeof ( char ) );
    800016c0:	01000593          	li	a1,16
    800016c4:	00048513          	mv	a0,s1
    800016c8:	00000097          	auipc	ra,0x0
    800016cc:	2e0080e7          	jalr	736(ra) # 800019a8 <_ZN15MemoryAllocator8k_mallocEm>
    800016d0:	00391793          	slli	a5,s2,0x3
    800016d4:	fa040713          	addi	a4,s0,-96
    800016d8:	00f707b3          	add	a5,a4,a5
    800016dc:	f8a7b023          	sd	a0,-128(a5)
            if ( blocks[i] == nullptr ) alloc_ok = false;
    800016e0:	fc051ae3          	bnez	a0,800016b4 <_Z21memory_allocator_testR15MemoryAllocator+0x4fc>
    800016e4:	00000993          	li	s3,0
    800016e8:	fcdff06f          	j	800016b4 <_Z21memory_allocator_testR15MemoryAllocator+0x4fc>
        }
        check ( alloc_ok, "T6.alloc_all" );
    800016ec:	00003597          	auipc	a1,0x3
    800016f0:	a4458593          	addi	a1,a1,-1468 # 80004130 <CONSOLE_STATUS+0x120>
    800016f4:	00098513          	mv	a0,s3
    800016f8:	00000097          	auipc	ra,0x0
    800016fc:	9d0080e7          	jalr	-1584(ra) # 800010c8 <_ZL5checkbPKc>

        // Jedinstven sadrzaj po bloku.
        for ( int i = 0; i < N; i++ )
    80001700:	00000613          	li	a2,0
    80001704:	0080006f          	j	8000170c <_Z21memory_allocator_testR15MemoryAllocator+0x554>
    80001708:	0016061b          	addiw	a2,a2,1
    8000170c:	00f00793          	li	a5,15
    80001710:	02c7cc63          	blt	a5,a2,80001748 <_Z21memory_allocator_testR15MemoryAllocator+0x590>
            if ( blocks[i] )
    80001714:	00361793          	slli	a5,a2,0x3
    80001718:	fa040713          	addi	a4,s0,-96
    8000171c:	00f707b3          	add	a5,a4,a5
    80001720:	f807b583          	ld	a1,-128(a5)
    80001724:	fe0582e3          	beqz	a1,80001708 <_Z21memory_allocator_testR15MemoryAllocator+0x550>
                for ( int j = 0; j < N; j++ ) blocks[i][j] = ( char ) ( 'A' + i );
    80001728:	00000793          	li	a5,0
    8000172c:	00f00713          	li	a4,15
    80001730:	fcf74ce3          	blt	a4,a5,80001708 <_Z21memory_allocator_testR15MemoryAllocator+0x550>
    80001734:	00f58733          	add	a4,a1,a5
    80001738:	0416069b          	addiw	a3,a2,65
    8000173c:	00d70023          	sb	a3,0(a4)
    80001740:	0017879b          	addiw	a5,a5,1
    80001744:	fe9ff06f          	j	8000172c <_Z21memory_allocator_testR15MemoryAllocator+0x574>

        // Ako se blokovi preklapaju, neki bajt nece imati ocekivanu vrednost.
        bool intact = true;
        for ( int i = 0; i < N; i++ )
    80001748:	00000613          	li	a2,0
        bool intact = true;
    8000174c:	00100513          	li	a0,1
    80001750:	0300006f          	j	80001780 <_Z21memory_allocator_testR15MemoryAllocator+0x5c8>
            if ( blocks[i] )
                for ( int j = 0; j < N; j++ )
    80001754:	0017879b          	addiw	a5,a5,1
    80001758:	00f00713          	li	a4,15
    8000175c:	02f74063          	blt	a4,a5,8000177c <_Z21memory_allocator_testR15MemoryAllocator+0x5c4>
                    if ( blocks[i][j] != ( char ) ( 'A' + i ) ) intact = false;
    80001760:	00f58733          	add	a4,a1,a5
    80001764:	00074683          	lbu	a3,0(a4)
    80001768:	0416071b          	addiw	a4,a2,65
    8000176c:	0ff77713          	andi	a4,a4,255
    80001770:	fee682e3          	beq	a3,a4,80001754 <_Z21memory_allocator_testR15MemoryAllocator+0x59c>
    80001774:	00000513          	li	a0,0
    80001778:	fddff06f          	j	80001754 <_Z21memory_allocator_testR15MemoryAllocator+0x59c>
        for ( int i = 0; i < N; i++ )
    8000177c:	0016061b          	addiw	a2,a2,1
    80001780:	00f00793          	li	a5,15
    80001784:	02c7c063          	blt	a5,a2,800017a4 <_Z21memory_allocator_testR15MemoryAllocator+0x5ec>
            if ( blocks[i] )
    80001788:	00361793          	slli	a5,a2,0x3
    8000178c:	fa040713          	addi	a4,s0,-96
    80001790:	00f707b3          	add	a5,a4,a5
    80001794:	f807b583          	ld	a1,-128(a5)
    80001798:	fe0582e3          	beqz	a1,8000177c <_Z21memory_allocator_testR15MemoryAllocator+0x5c4>
                for ( int j = 0; j < N; j++ )
    8000179c:	00000793          	li	a5,0
    800017a0:	fb9ff06f          	j	80001758 <_Z21memory_allocator_testR15MemoryAllocator+0x5a0>
        check ( intact, "T6.no_overlap" );
    800017a4:	00003597          	auipc	a1,0x3
    800017a8:	99c58593          	addi	a1,a1,-1636 # 80004140 <CONSOLE_STATUS+0x130>
    800017ac:	00000097          	auipc	ra,0x0
    800017b0:	91c080e7          	jalr	-1764(ra) # 800010c8 <_ZL5checkbPKc>

        bool free_ok = true;
        for ( int i = 0; i < N; i++ )
    800017b4:	00000913          	li	s2,0
        bool free_ok = true;
    800017b8:	00100993          	li	s3,1
    800017bc:	0080006f          	j	800017c4 <_Z21memory_allocator_testR15MemoryAllocator+0x60c>
        for ( int i = 0; i < N; i++ )
    800017c0:	0019091b          	addiw	s2,s2,1
    800017c4:	00f00793          	li	a5,15
    800017c8:	0327c863          	blt	a5,s2,800017f8 <_Z21memory_allocator_testR15MemoryAllocator+0x640>
            if ( blocks[i] && allocator.k_free ( blocks[i] ) != 0 ) free_ok = false;
    800017cc:	00391793          	slli	a5,s2,0x3
    800017d0:	fa040713          	addi	a4,s0,-96
    800017d4:	00f707b3          	add	a5,a4,a5
    800017d8:	f807b583          	ld	a1,-128(a5)
    800017dc:	fe0582e3          	beqz	a1,800017c0 <_Z21memory_allocator_testR15MemoryAllocator+0x608>
    800017e0:	00048513          	mv	a0,s1
    800017e4:	00000097          	auipc	ra,0x0
    800017e8:	2fc080e7          	jalr	764(ra) # 80001ae0 <_ZN15MemoryAllocator6k_freeEPv>
    800017ec:	fc050ae3          	beqz	a0,800017c0 <_Z21memory_allocator_testR15MemoryAllocator+0x608>
    800017f0:	00000993          	li	s3,0
    800017f4:	fcdff06f          	j	800017c0 <_Z21memory_allocator_testR15MemoryAllocator+0x608>
        check ( free_ok, "T6.free_all" );
    800017f8:	00003597          	auipc	a1,0x3
    800017fc:	95858593          	addi	a1,a1,-1704 # 80004150 <CONSOLE_STATUS+0x140>
    80001800:	00098513          	mv	a0,s3
    80001804:	00000097          	auipc	ra,0x0
    80001808:	8c4080e7          	jalr	-1852(ra) # 800010c8 <_ZL5checkbPKc>
    }
    assert_heap_whole ( allocator, "T6.leak" );
    8000180c:	00003597          	auipc	a1,0x3
    80001810:	95458593          	addi	a1,a1,-1708 # 80004160 <CONSOLE_STATUS+0x150>
    80001814:	00048513          	mv	a0,s1
    80001818:	00000097          	auipc	ra,0x0
    8000181c:	920080e7          	jalr	-1760(ra) # 80001138 <_ZL17assert_heap_wholeR15MemoryAllocatorPKc>

    // TEST 7: granicni ulazi ----------------------------------------------
    {
        // Veci od celog hipa -> nullptr (i hip ostaje netaknut).
        char* too_big = ( char* ) allocator.k_malloc ( usable_heap_size () + MEM_BLOCK_SIZE );
    80001820:	00000097          	auipc	ra,0x0
    80001824:	824080e7          	jalr	-2012(ra) # 80001044 <_ZL16usable_heap_sizev>
    80001828:	04050593          	addi	a1,a0,64
    8000182c:	00048513          	mv	a0,s1
    80001830:	00000097          	auipc	ra,0x0
    80001834:	178080e7          	jalr	376(ra) # 800019a8 <_ZN15MemoryAllocator8k_mallocEm>
        check ( too_big == nullptr, "T7.oversize" );
    80001838:	00003597          	auipc	a1,0x3
    8000183c:	93058593          	addi	a1,a1,-1744 # 80004168 <CONSOLE_STATUS+0x158>
    80001840:	00153513          	seqz	a0,a0
    80001844:	00000097          	auipc	ra,0x0
    80001848:	884080e7          	jalr	-1916(ra) # 800010c8 <_ZL5checkbPKc>

        // Nula bajtova -> nullptr (provera size <= 0 u k_malloc).
        char* zero = ( char* ) allocator.k_malloc ( 0 );
    8000184c:	00000593          	li	a1,0
    80001850:	00048513          	mv	a0,s1
    80001854:	00000097          	auipc	ra,0x0
    80001858:	154080e7          	jalr	340(ra) # 800019a8 <_ZN15MemoryAllocator8k_mallocEm>
        check ( zero == nullptr, "T7.zero_size" );
    8000185c:	00003597          	auipc	a1,0x3
    80001860:	91c58593          	addi	a1,a1,-1764 # 80004178 <CONSOLE_STATUS+0x168>
    80001864:	00153513          	seqz	a0,a0
    80001868:	00000097          	auipc	ra,0x0
    8000186c:	860080e7          	jalr	-1952(ra) # 800010c8 <_ZL5checkbPKc>
    }
    assert_heap_whole ( allocator, "T7.leak" );
    80001870:	00003597          	auipc	a1,0x3
    80001874:	91858593          	addi	a1,a1,-1768 # 80004188 <CONSOLE_STATUS+0x178>
    80001878:	00048513          	mv	a0,s1
    8000187c:	00000097          	auipc	ra,0x0
    80001880:	8bc080e7          	jalr	-1860(ra) # 80001138 <_ZL17assert_heap_wholeR15MemoryAllocatorPKc>

    // Rezime --------------------------------------------------------------
    if ( g_failures == 0 ) put_str ( "ALL TESTS OK\n" );
    80001884:	00003797          	auipc	a5,0x3
    80001888:	dfc7a783          	lw	a5,-516(a5) # 80004680 <_ZL10g_failures>
    8000188c:	04079863          	bnez	a5,800018dc <_Z21memory_allocator_testR15MemoryAllocator+0x724>
    80001890:	00003517          	auipc	a0,0x3
    80001894:	90050513          	addi	a0,a0,-1792 # 80004190 <CONSOLE_STATUS+0x180>
    80001898:	fffff097          	auipc	ra,0xfffff
    8000189c:	7ec080e7          	jalr	2028(ra) # 80001084 <_ZL7put_strPKc>
    else                   put_str ( "SOME TESTS FAILED\n" );

    return g_failures;
}
    800018a0:	00003517          	auipc	a0,0x3
    800018a4:	de052503          	lw	a0,-544(a0) # 80004680 <_ZL10g_failures>
    800018a8:	0d813083          	ld	ra,216(sp)
    800018ac:	0d013403          	ld	s0,208(sp)
    800018b0:	0c813483          	ld	s1,200(sp)
    800018b4:	0c013903          	ld	s2,192(sp)
    800018b8:	0b813983          	ld	s3,184(sp)
    800018bc:	0b013a03          	ld	s4,176(sp)
    800018c0:	0a813a83          	ld	s5,168(sp)
    800018c4:	0a013b03          	ld	s6,160(sp)
    800018c8:	09813b83          	ld	s7,152(sp)
    800018cc:	09013c03          	ld	s8,144(sp)
    800018d0:	08813c83          	ld	s9,136(sp)
    800018d4:	0e010113          	addi	sp,sp,224
    800018d8:	00008067          	ret
    else                   put_str ( "SOME TESTS FAILED\n" );
    800018dc:	00003517          	auipc	a0,0x3
    800018e0:	8c450513          	addi	a0,a0,-1852 # 800041a0 <CONSOLE_STATUS+0x190>
    800018e4:	fffff097          	auipc	ra,0xfffff
    800018e8:	7a0080e7          	jalr	1952(ra) # 80001084 <_ZL7put_strPKc>
    800018ec:	fb5ff06f          	j	800018a0 <_Z21memory_allocator_testR15MemoryAllocator+0x6e8>

00000000800018f0 <_ZN15MemoryAllocatorC1Ev>:
#include "../h/MemoryAllocator.hpp"

MemoryAllocator::MemoryAllocator () {
    800018f0:	ff010113          	addi	sp,sp,-16
    800018f4:	00813423          	sd	s0,8(sp)
    800018f8:	01010413          	addi	s0,sp,16
    // Initialization of the memory allocator
    mem_start_addr = align_up (( size_t ) HEAP_START_ADDR );    // Align start addr to block
    800018fc:	00003797          	auipc	a5,0x3
    80001900:	d1c7b783          	ld	a5,-740(a5) # 80004618 <_GLOBAL_OFFSET_TABLE_+0x8>
    80001904:	0007b783          	ld	a5,0(a5)

    return 0;
}

inline constexpr size_t MemoryAllocator::align_up ( size_t addr ) {
    return ( ( addr + MEM_BLOCK_SIZE - 1 ) / MEM_BLOCK_SIZE ) * MEM_BLOCK_SIZE;
    80001908:	03f78793          	addi	a5,a5,63
    8000190c:	fc07f793          	andi	a5,a5,-64
    mem_start_addr = align_up (( size_t ) HEAP_START_ADDR );    // Align start addr to block
    80001910:	00f53023          	sd	a5,0(a0)
    mem_end_addr   = align_down (( size_t ) HEAP_END_ADDR );    // Align end addr to block
    80001914:	00003717          	auipc	a4,0x3
    80001918:	d1c73703          	ld	a4,-740(a4) # 80004630 <_GLOBAL_OFFSET_TABLE_+0x20>
    8000191c:	00073703          	ld	a4,0(a4)
}

inline constexpr size_t MemoryAllocator::align_down ( size_t addr ) {
    return ( addr / MEM_BLOCK_SIZE ) * MEM_BLOCK_SIZE;
    80001920:	fc077713          	andi	a4,a4,-64
    mem_end_addr   = align_down (( size_t ) HEAP_END_ADDR );    // Align end addr to block
    80001924:	00e53423          	sd	a4,8(a0)
    free_mem_head  = ( FreeFragment* ) mem_start_addr;
    80001928:	00f53c23          	sd	a5,24(a0)
    free_mem_size  = mem_end_addr - mem_start_addr;
    8000192c:	40f70733          	sub	a4,a4,a5
    80001930:	00e53823          	sd	a4,16(a0)
    free_mem_head->size = free_mem_size;
    80001934:	00e7b023          	sd	a4,0(a5)
    free_mem_head->next = nullptr;
    80001938:	01853783          	ld	a5,24(a0)
    8000193c:	0007b423          	sd	zero,8(a5)
}
    80001940:	00813403          	ld	s0,8(sp)
    80001944:	01010113          	addi	sp,sp,16
    80001948:	00008067          	ret

000000008000194c <_ZN15MemoryAllocator12get_instanceEv>:
    static MemoryAllocator instance;
    8000194c:	00003797          	auipc	a5,0x3
    80001950:	d3c7c783          	lbu	a5,-708(a5) # 80004688 <_ZGVZN15MemoryAllocator12get_instanceEvE8instance>
    80001954:	00078863          	beqz	a5,80001964 <_ZN15MemoryAllocator12get_instanceEv+0x18>
}
    80001958:	00003517          	auipc	a0,0x3
    8000195c:	d3850513          	addi	a0,a0,-712 # 80004690 <_ZZN15MemoryAllocator12get_instanceEvE8instance>
    80001960:	00008067          	ret
MemoryAllocator& MemoryAllocator::get_instance () {
    80001964:	ff010113          	addi	sp,sp,-16
    80001968:	00113423          	sd	ra,8(sp)
    8000196c:	00813023          	sd	s0,0(sp)
    80001970:	01010413          	addi	s0,sp,16
    static MemoryAllocator instance;
    80001974:	00003517          	auipc	a0,0x3
    80001978:	d1c50513          	addi	a0,a0,-740 # 80004690 <_ZZN15MemoryAllocator12get_instanceEvE8instance>
    8000197c:	00000097          	auipc	ra,0x0
    80001980:	f74080e7          	jalr	-140(ra) # 800018f0 <_ZN15MemoryAllocatorC1Ev>
    80001984:	00100793          	li	a5,1
    80001988:	00003717          	auipc	a4,0x3
    8000198c:	d0f70023          	sb	a5,-768(a4) # 80004688 <_ZGVZN15MemoryAllocator12get_instanceEvE8instance>
}
    80001990:	00003517          	auipc	a0,0x3
    80001994:	d0050513          	addi	a0,a0,-768 # 80004690 <_ZZN15MemoryAllocator12get_instanceEvE8instance>
    80001998:	00813083          	ld	ra,8(sp)
    8000199c:	00013403          	ld	s0,0(sp)
    800019a0:	01010113          	addi	sp,sp,16
    800019a4:	00008067          	ret

00000000800019a8 <_ZN15MemoryAllocator8k_mallocEm>:
void* MemoryAllocator::k_malloc ( size_t size ) {
    800019a8:	ff010113          	addi	sp,sp,-16
    800019ac:	00813423          	sd	s0,8(sp)
    800019b0:	01010413          	addi	s0,sp,16
    if ( size <= 0 || size > free_mem_size ) return nullptr;
    800019b4:	0c058c63          	beqz	a1,80001a8c <_ZN15MemoryAllocator8k_mallocEm+0xe4>
    800019b8:	00050813          	mv	a6,a0
    800019bc:	01053783          	ld	a5,16(a0)
    800019c0:	0cb7ea63          	bltu	a5,a1,80001a94 <_ZN15MemoryAllocator8k_mallocEm+0xec>
    return ( ( addr + MEM_BLOCK_SIZE - 1 ) / MEM_BLOCK_SIZE ) * MEM_BLOCK_SIZE;
    800019c4:	04758593          	addi	a1,a1,71
    800019c8:	fc05f713          	andi	a4,a1,-64
    FreeFragment* curr = free_mem_head;
    800019cc:	01853783          	ld	a5,24(a0)
    FreeFragment* best_prev = nullptr;
    800019d0:	00000893          	li	a7,0
    FreeFragment* best      = nullptr;
    800019d4:	00000513          	li	a0,0
    FreeFragment* prev = nullptr;
    800019d8:	00000613          	li	a2,0
    800019dc:	0140006f          	j	800019f0 <_ZN15MemoryAllocator8k_mallocEm+0x48>
                best_prev = prev;
    800019e0:	00060893          	mv	a7,a2
                best      = curr;
    800019e4:	00078513          	mv	a0,a5
    for ( ; curr != nullptr; prev = curr, curr = curr->next ) {
    800019e8:	00078613          	mv	a2,a5
    800019ec:	0087b783          	ld	a5,8(a5)
    800019f0:	02078263          	beqz	a5,80001a14 <_ZN15MemoryAllocator8k_mallocEm+0x6c>
        if ( curr->size >= needed_size ) {
    800019f4:	0007b683          	ld	a3,0(a5)
    800019f8:	fee6e8e3          	bltu	a3,a4,800019e8 <_ZN15MemoryAllocator8k_mallocEm+0x40>
            if ( best == nullptr || curr->size < best->size ) {
    800019fc:	fe0502e3          	beqz	a0,800019e0 <_ZN15MemoryAllocator8k_mallocEm+0x38>
    80001a00:	00053583          	ld	a1,0(a0)
    80001a04:	feb6f2e3          	bgeu	a3,a1,800019e8 <_ZN15MemoryAllocator8k_mallocEm+0x40>
                best_prev = prev;
    80001a08:	00060893          	mv	a7,a2
                best      = curr;
    80001a0c:	00078513          	mv	a0,a5
    80001a10:	fd9ff06f          	j	800019e8 <_ZN15MemoryAllocator8k_mallocEm+0x40>
    if ( best == nullptr ) return nullptr;  // out of memory
    80001a14:	04050063          	beqz	a0,80001a54 <_ZN15MemoryAllocator8k_mallocEm+0xac>
    size_t remainder_size = best->size - needed_size; // calculate the size of leftover fragment
    80001a18:	00053783          	ld	a5,0(a0)
    80001a1c:	40e786b3          	sub	a3,a5,a4
    if ( remainder_size >= MEM_BLOCK_SIZE ) {
    80001a20:	03f00613          	li	a2,63
    80001a24:	04d67263          	bgeu	a2,a3,80001a68 <_ZN15MemoryAllocator8k_mallocEm+0xc0>
        FreeFragment* remainder = ( FreeFragment* ) ( ( char* ) best + needed_size );
    80001a28:	00e507b3          	add	a5,a0,a4
        remainder->size = remainder_size;
    80001a2c:	00d7b023          	sd	a3,0(a5)
        remainder->next = best->next;
    80001a30:	00853683          	ld	a3,8(a0)
    80001a34:	00d7b423          	sd	a3,8(a5)
        if ( best_prev ) best_prev->next = remainder;
    80001a38:	02088463          	beqz	a7,80001a60 <_ZN15MemoryAllocator8k_mallocEm+0xb8>
    80001a3c:	00f8b423          	sd	a5,8(a7)
    free_mem_size -= needed_size; // update size of free mem
    80001a40:	01083783          	ld	a5,16(a6)
    80001a44:	40e787b3          	sub	a5,a5,a4
    80001a48:	00f83823          	sd	a5,16(a6)
    *(( header_t* ) best ) = needed_size; // write size of allocated block in the header
    80001a4c:	00e53023          	sd	a4,0(a0)
    return ( void* ) ( ( char* ) best + sizeof ( header_t ) );
    80001a50:	00850513          	addi	a0,a0,8
}
    80001a54:	00813403          	ld	s0,8(sp)
    80001a58:	01010113          	addi	sp,sp,16
    80001a5c:	00008067          	ret
        else             free_mem_head   = remainder;   // best was head
    80001a60:	00f83c23          	sd	a5,24(a6)
    80001a64:	fddff06f          	j	80001a40 <_ZN15MemoryAllocator8k_mallocEm+0x98>
        if ( best_prev ) best_prev->next = best->next;
    80001a68:	00088a63          	beqz	a7,80001a7c <_ZN15MemoryAllocator8k_mallocEm+0xd4>
    80001a6c:	00853703          	ld	a4,8(a0)
    80001a70:	00e8b423          	sd	a4,8(a7)
        needed_size = best->size;
    80001a74:	00078713          	mv	a4,a5
    80001a78:	fc9ff06f          	j	80001a40 <_ZN15MemoryAllocator8k_mallocEm+0x98>
        else             free_mem_head   = best->next;
    80001a7c:	00853703          	ld	a4,8(a0)
    80001a80:	00e83c23          	sd	a4,24(a6)
        needed_size = best->size;
    80001a84:	00078713          	mv	a4,a5
    80001a88:	fb9ff06f          	j	80001a40 <_ZN15MemoryAllocator8k_mallocEm+0x98>
    if ( size <= 0 || size > free_mem_size ) return nullptr;
    80001a8c:	00000513          	li	a0,0
    80001a90:	fc5ff06f          	j	80001a54 <_ZN15MemoryAllocator8k_mallocEm+0xac>
    80001a94:	00000513          	li	a0,0
    80001a98:	fbdff06f          	j	80001a54 <_ZN15MemoryAllocator8k_mallocEm+0xac>

0000000080001a9c <_ZN15MemoryAllocator12try_to_mergeEP12FreeFragmentS1_>:
}

void MemoryAllocator::try_to_merge ( FreeFragment* prev, FreeFragment* curr ) {
    80001a9c:	ff010113          	addi	sp,sp,-16
    80001aa0:	00813423          	sd	s0,8(sp)
    80001aa4:	01010413          	addi	s0,sp,16
    // check if args are valid
    if ( prev == nullptr || curr == nullptr ) return;
    80001aa8:	00058a63          	beqz	a1,80001abc <_ZN15MemoryAllocator12try_to_mergeEP12FreeFragmentS1_+0x20>
    80001aac:	00060863          	beqz	a2,80001abc <_ZN15MemoryAllocator12try_to_mergeEP12FreeFragmentS1_+0x20>

    if ( (( char* ) prev + prev->size ) == ( char* ) curr ) {
    80001ab0:	0005b783          	ld	a5,0(a1)
    80001ab4:	00f58733          	add	a4,a1,a5
    80001ab8:	00c70863          	beq	a4,a2,80001ac8 <_ZN15MemoryAllocator12try_to_mergeEP12FreeFragmentS1_+0x2c>
        prev->size += curr->size;
        prev->next  = curr->next;
    }
}
    80001abc:	00813403          	ld	s0,8(sp)
    80001ac0:	01010113          	addi	sp,sp,16
    80001ac4:	00008067          	ret
        prev->size += curr->size;
    80001ac8:	00063703          	ld	a4,0(a2)
    80001acc:	00e787b3          	add	a5,a5,a4
    80001ad0:	00f5b023          	sd	a5,0(a1)
        prev->next  = curr->next;
    80001ad4:	00863783          	ld	a5,8(a2)
    80001ad8:	00f5b423          	sd	a5,8(a1)
    80001adc:	fe1ff06f          	j	80001abc <_ZN15MemoryAllocator12try_to_mergeEP12FreeFragmentS1_+0x20>

0000000080001ae0 <_ZN15MemoryAllocator6k_freeEPv>:
    if ( ptr == nullptr ) return 0; // nothing to free
    80001ae0:	0a058863          	beqz	a1,80001b90 <_ZN15MemoryAllocator6k_freeEPv+0xb0>
int MemoryAllocator::k_free ( void* ptr ) {
    80001ae4:	fd010113          	addi	sp,sp,-48
    80001ae8:	02113423          	sd	ra,40(sp)
    80001aec:	02813023          	sd	s0,32(sp)
    80001af0:	00913c23          	sd	s1,24(sp)
    80001af4:	01213823          	sd	s2,16(sp)
    80001af8:	01313423          	sd	s3,8(sp)
    80001afc:	03010413          	addi	s0,sp,48
    80001b00:	00050993          	mv	s3,a0
    header_t* hdr = ( header_t* ) (( char* ) ptr - sizeof ( header_t ));
    80001b04:	ff858493          	addi	s1,a1,-8
    size_t block_size = *hdr;
    80001b08:	ff85b703          	ld	a4,-8(a1)
    free_mem_size += block_size; // update size of free mem
    80001b0c:	01053783          	ld	a5,16(a0)
    80001b10:	00e787b3          	add	a5,a5,a4
    80001b14:	00f53823          	sd	a5,16(a0)
    FreeFragment* curr = free_mem_head;
    80001b18:	01853603          	ld	a2,24(a0)
    FreeFragment* prev = nullptr;
    80001b1c:	00000913          	li	s2,0
    while ( curr != nullptr && curr < freed_block ) {
    80001b20:	00060a63          	beqz	a2,80001b34 <_ZN15MemoryAllocator6k_freeEPv+0x54>
    80001b24:	00967863          	bgeu	a2,s1,80001b34 <_ZN15MemoryAllocator6k_freeEPv+0x54>
        prev = curr;
    80001b28:	00060913          	mv	s2,a2
        curr = curr->next;
    80001b2c:	00863603          	ld	a2,8(a2)
    while ( curr != nullptr && curr < freed_block ) {
    80001b30:	ff1ff06f          	j	80001b20 <_ZN15MemoryAllocator6k_freeEPv+0x40>
    freed_block->size = block_size;
    80001b34:	fee5bc23          	sd	a4,-8(a1)
    freed_block->next = curr;
    80001b38:	00c5b023          	sd	a2,0(a1)
    if ( prev ) prev->next    = freed_block;
    80001b3c:	04090663          	beqz	s2,80001b88 <_ZN15MemoryAllocator6k_freeEPv+0xa8>
    80001b40:	00993423          	sd	s1,8(s2)
    try_to_merge ( freed_block, curr );
    80001b44:	00048593          	mv	a1,s1
    80001b48:	00098513          	mv	a0,s3
    80001b4c:	00000097          	auipc	ra,0x0
    80001b50:	f50080e7          	jalr	-176(ra) # 80001a9c <_ZN15MemoryAllocator12try_to_mergeEP12FreeFragmentS1_>
    try_to_merge ( prev, freed_block );
    80001b54:	00048613          	mv	a2,s1
    80001b58:	00090593          	mv	a1,s2
    80001b5c:	00098513          	mv	a0,s3
    80001b60:	00000097          	auipc	ra,0x0
    80001b64:	f3c080e7          	jalr	-196(ra) # 80001a9c <_ZN15MemoryAllocator12try_to_mergeEP12FreeFragmentS1_>
}
    80001b68:	00000513          	li	a0,0
    80001b6c:	02813083          	ld	ra,40(sp)
    80001b70:	02013403          	ld	s0,32(sp)
    80001b74:	01813483          	ld	s1,24(sp)
    80001b78:	01013903          	ld	s2,16(sp)
    80001b7c:	00813983          	ld	s3,8(sp)
    80001b80:	03010113          	addi	sp,sp,48
    80001b84:	00008067          	ret
    else        free_mem_head = freed_block;
    80001b88:	0099bc23          	sd	s1,24(s3)
    80001b8c:	fb9ff06f          	j	80001b44 <_ZN15MemoryAllocator6k_freeEPv+0x64>
}
    80001b90:	00000513          	li	a0,0
    80001b94:	00008067          	ret

0000000080001b98 <main>:

extern int memory_allocator_test ( MemoryAllocator& allocator );

extern "C" void trap_handler ();

void main() {
    80001b98:	ff010113          	addi	sp,sp,-16
    80001b9c:	00113423          	sd	ra,8(sp)
    80001ba0:	00813023          	sd	s0,0(sp)
    80001ba4:	01010413          	addi	s0,sp,16

    // memory_allocator_test ( MemoryAllocator::get_instance () );

    RiscV::w_stvec ( ( uint64 ) trap_handler );
    80001ba8:	00003797          	auipc	a5,0x3
    80001bac:	a807b783          	ld	a5,-1408(a5) # 80004628 <_GLOBAL_OFFSET_TABLE_+0x18>

    return stvec;
}

inline void RiscV::w_stvec ( uint64 stvec ) {
    __asm__ volatile ( "csrw stvec, %[stvec]" : : [stvec] "r"(stvec) );
    80001bb0:	10579073          	csrw	stvec,a5

    __putc ( 'A' );
    80001bb4:	04100513          	li	a0,65
    80001bb8:	00002097          	auipc	ra,0x2
    80001bbc:	0f4080e7          	jalr	244(ra) # 80003cac <__putc>

    __asm__ volatile ( "ecall" );
    80001bc0:	00000073          	ecall

    __putc ( 'B' );
    80001bc4:	04200513          	li	a0,66
    80001bc8:	00002097          	auipc	ra,0x2
    80001bcc:	0e4080e7          	jalr	228(ra) # 80003cac <__putc>

    __putc ( '\n' );
    80001bd0:	00a00513          	li	a0,10
    80001bd4:	00002097          	auipc	ra,0x2
    80001bd8:	0d8080e7          	jalr	216(ra) # 80003cac <__putc>
}
    80001bdc:	00813083          	ld	ra,8(sp)
    80001be0:	00013403          	ld	s0,0(sp)
    80001be4:	01010113          	addi	sp,sp,16
    80001be8:	00008067          	ret

0000000080001bec <start>:
    80001bec:	ff010113          	addi	sp,sp,-16
    80001bf0:	00813423          	sd	s0,8(sp)
    80001bf4:	01010413          	addi	s0,sp,16
    80001bf8:	300027f3          	csrr	a5,mstatus
    80001bfc:	ffffe737          	lui	a4,0xffffe
    80001c00:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fff8eff>
    80001c04:	00e7f7b3          	and	a5,a5,a4
    80001c08:	00001737          	lui	a4,0x1
    80001c0c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80001c10:	00e7e7b3          	or	a5,a5,a4
    80001c14:	30079073          	csrw	mstatus,a5
    80001c18:	00000797          	auipc	a5,0x0
    80001c1c:	16078793          	addi	a5,a5,352 # 80001d78 <system_main>
    80001c20:	34179073          	csrw	mepc,a5
    80001c24:	00000793          	li	a5,0
    80001c28:	18079073          	csrw	satp,a5
    80001c2c:	000107b7          	lui	a5,0x10
    80001c30:	fff78793          	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80001c34:	30279073          	csrw	medeleg,a5
    80001c38:	30379073          	csrw	mideleg,a5
    80001c3c:	104027f3          	csrr	a5,sie
    80001c40:	2227e793          	ori	a5,a5,546
    80001c44:	10479073          	csrw	sie,a5
    80001c48:	fff00793          	li	a5,-1
    80001c4c:	00a7d793          	srli	a5,a5,0xa
    80001c50:	3b079073          	csrw	pmpaddr0,a5
    80001c54:	00f00793          	li	a5,15
    80001c58:	3a079073          	csrw	pmpcfg0,a5
    80001c5c:	f14027f3          	csrr	a5,mhartid
    80001c60:	0200c737          	lui	a4,0x200c
    80001c64:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80001c68:	0007869b          	sext.w	a3,a5
    80001c6c:	00269713          	slli	a4,a3,0x2
    80001c70:	000f4637          	lui	a2,0xf4
    80001c74:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80001c78:	00d70733          	add	a4,a4,a3
    80001c7c:	0037979b          	slliw	a5,a5,0x3
    80001c80:	020046b7          	lui	a3,0x2004
    80001c84:	00d787b3          	add	a5,a5,a3
    80001c88:	00c585b3          	add	a1,a1,a2
    80001c8c:	00371693          	slli	a3,a4,0x3
    80001c90:	00003717          	auipc	a4,0x3
    80001c94:	a2070713          	addi	a4,a4,-1504 # 800046b0 <timer_scratch>
    80001c98:	00b7b023          	sd	a1,0(a5)
    80001c9c:	00d70733          	add	a4,a4,a3
    80001ca0:	00f73c23          	sd	a5,24(a4)
    80001ca4:	02c73023          	sd	a2,32(a4)
    80001ca8:	34071073          	csrw	mscratch,a4
    80001cac:	00000797          	auipc	a5,0x0
    80001cb0:	6e478793          	addi	a5,a5,1764 # 80002390 <timervec>
    80001cb4:	30579073          	csrw	mtvec,a5
    80001cb8:	300027f3          	csrr	a5,mstatus
    80001cbc:	0087e793          	ori	a5,a5,8
    80001cc0:	30079073          	csrw	mstatus,a5
    80001cc4:	304027f3          	csrr	a5,mie
    80001cc8:	0807e793          	ori	a5,a5,128
    80001ccc:	30479073          	csrw	mie,a5
    80001cd0:	f14027f3          	csrr	a5,mhartid
    80001cd4:	0007879b          	sext.w	a5,a5
    80001cd8:	00078213          	mv	tp,a5
    80001cdc:	30200073          	mret
    80001ce0:	00813403          	ld	s0,8(sp)
    80001ce4:	01010113          	addi	sp,sp,16
    80001ce8:	00008067          	ret

0000000080001cec <timerinit>:
    80001cec:	ff010113          	addi	sp,sp,-16
    80001cf0:	00813423          	sd	s0,8(sp)
    80001cf4:	01010413          	addi	s0,sp,16
    80001cf8:	f14027f3          	csrr	a5,mhartid
    80001cfc:	0200c737          	lui	a4,0x200c
    80001d00:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80001d04:	0007869b          	sext.w	a3,a5
    80001d08:	00269713          	slli	a4,a3,0x2
    80001d0c:	000f4637          	lui	a2,0xf4
    80001d10:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80001d14:	00d70733          	add	a4,a4,a3
    80001d18:	0037979b          	slliw	a5,a5,0x3
    80001d1c:	020046b7          	lui	a3,0x2004
    80001d20:	00d787b3          	add	a5,a5,a3
    80001d24:	00c585b3          	add	a1,a1,a2
    80001d28:	00371693          	slli	a3,a4,0x3
    80001d2c:	00003717          	auipc	a4,0x3
    80001d30:	98470713          	addi	a4,a4,-1660 # 800046b0 <timer_scratch>
    80001d34:	00b7b023          	sd	a1,0(a5)
    80001d38:	00d70733          	add	a4,a4,a3
    80001d3c:	00f73c23          	sd	a5,24(a4)
    80001d40:	02c73023          	sd	a2,32(a4)
    80001d44:	34071073          	csrw	mscratch,a4
    80001d48:	00000797          	auipc	a5,0x0
    80001d4c:	64878793          	addi	a5,a5,1608 # 80002390 <timervec>
    80001d50:	30579073          	csrw	mtvec,a5
    80001d54:	300027f3          	csrr	a5,mstatus
    80001d58:	0087e793          	ori	a5,a5,8
    80001d5c:	30079073          	csrw	mstatus,a5
    80001d60:	304027f3          	csrr	a5,mie
    80001d64:	0807e793          	ori	a5,a5,128
    80001d68:	30479073          	csrw	mie,a5
    80001d6c:	00813403          	ld	s0,8(sp)
    80001d70:	01010113          	addi	sp,sp,16
    80001d74:	00008067          	ret

0000000080001d78 <system_main>:
    80001d78:	fe010113          	addi	sp,sp,-32
    80001d7c:	00813823          	sd	s0,16(sp)
    80001d80:	00913423          	sd	s1,8(sp)
    80001d84:	00113c23          	sd	ra,24(sp)
    80001d88:	02010413          	addi	s0,sp,32
    80001d8c:	00000097          	auipc	ra,0x0
    80001d90:	0c4080e7          	jalr	196(ra) # 80001e50 <cpuid>
    80001d94:	00003497          	auipc	s1,0x3
    80001d98:	8bc48493          	addi	s1,s1,-1860 # 80004650 <started>
    80001d9c:	02050263          	beqz	a0,80001dc0 <system_main+0x48>
    80001da0:	0004a783          	lw	a5,0(s1)
    80001da4:	0007879b          	sext.w	a5,a5
    80001da8:	fe078ce3          	beqz	a5,80001da0 <system_main+0x28>
    80001dac:	0ff0000f          	fence
    80001db0:	00002517          	auipc	a0,0x2
    80001db4:	43850513          	addi	a0,a0,1080 # 800041e8 <CONSOLE_STATUS+0x1d8>
    80001db8:	00001097          	auipc	ra,0x1
    80001dbc:	a74080e7          	jalr	-1420(ra) # 8000282c <panic>
    80001dc0:	00001097          	auipc	ra,0x1
    80001dc4:	9c8080e7          	jalr	-1592(ra) # 80002788 <consoleinit>
    80001dc8:	00001097          	auipc	ra,0x1
    80001dcc:	154080e7          	jalr	340(ra) # 80002f1c <printfinit>
    80001dd0:	00002517          	auipc	a0,0x2
    80001dd4:	4f850513          	addi	a0,a0,1272 # 800042c8 <CONSOLE_STATUS+0x2b8>
    80001dd8:	00001097          	auipc	ra,0x1
    80001ddc:	ab0080e7          	jalr	-1360(ra) # 80002888 <__printf>
    80001de0:	00002517          	auipc	a0,0x2
    80001de4:	3d850513          	addi	a0,a0,984 # 800041b8 <CONSOLE_STATUS+0x1a8>
    80001de8:	00001097          	auipc	ra,0x1
    80001dec:	aa0080e7          	jalr	-1376(ra) # 80002888 <__printf>
    80001df0:	00002517          	auipc	a0,0x2
    80001df4:	4d850513          	addi	a0,a0,1240 # 800042c8 <CONSOLE_STATUS+0x2b8>
    80001df8:	00001097          	auipc	ra,0x1
    80001dfc:	a90080e7          	jalr	-1392(ra) # 80002888 <__printf>
    80001e00:	00001097          	auipc	ra,0x1
    80001e04:	4a8080e7          	jalr	1192(ra) # 800032a8 <kinit>
    80001e08:	00000097          	auipc	ra,0x0
    80001e0c:	148080e7          	jalr	328(ra) # 80001f50 <trapinit>
    80001e10:	00000097          	auipc	ra,0x0
    80001e14:	16c080e7          	jalr	364(ra) # 80001f7c <trapinithart>
    80001e18:	00000097          	auipc	ra,0x0
    80001e1c:	5b8080e7          	jalr	1464(ra) # 800023d0 <plicinit>
    80001e20:	00000097          	auipc	ra,0x0
    80001e24:	5d8080e7          	jalr	1496(ra) # 800023f8 <plicinithart>
    80001e28:	00000097          	auipc	ra,0x0
    80001e2c:	078080e7          	jalr	120(ra) # 80001ea0 <userinit>
    80001e30:	0ff0000f          	fence
    80001e34:	00100793          	li	a5,1
    80001e38:	00002517          	auipc	a0,0x2
    80001e3c:	39850513          	addi	a0,a0,920 # 800041d0 <CONSOLE_STATUS+0x1c0>
    80001e40:	00f4a023          	sw	a5,0(s1)
    80001e44:	00001097          	auipc	ra,0x1
    80001e48:	a44080e7          	jalr	-1468(ra) # 80002888 <__printf>
    80001e4c:	0000006f          	j	80001e4c <system_main+0xd4>

0000000080001e50 <cpuid>:
    80001e50:	ff010113          	addi	sp,sp,-16
    80001e54:	00813423          	sd	s0,8(sp)
    80001e58:	01010413          	addi	s0,sp,16
    80001e5c:	00020513          	mv	a0,tp
    80001e60:	00813403          	ld	s0,8(sp)
    80001e64:	0005051b          	sext.w	a0,a0
    80001e68:	01010113          	addi	sp,sp,16
    80001e6c:	00008067          	ret

0000000080001e70 <mycpu>:
    80001e70:	ff010113          	addi	sp,sp,-16
    80001e74:	00813423          	sd	s0,8(sp)
    80001e78:	01010413          	addi	s0,sp,16
    80001e7c:	00020793          	mv	a5,tp
    80001e80:	00813403          	ld	s0,8(sp)
    80001e84:	0007879b          	sext.w	a5,a5
    80001e88:	00779793          	slli	a5,a5,0x7
    80001e8c:	00004517          	auipc	a0,0x4
    80001e90:	85450513          	addi	a0,a0,-1964 # 800056e0 <cpus>
    80001e94:	00f50533          	add	a0,a0,a5
    80001e98:	01010113          	addi	sp,sp,16
    80001e9c:	00008067          	ret

0000000080001ea0 <userinit>:
    80001ea0:	ff010113          	addi	sp,sp,-16
    80001ea4:	00813423          	sd	s0,8(sp)
    80001ea8:	01010413          	addi	s0,sp,16
    80001eac:	00813403          	ld	s0,8(sp)
    80001eb0:	01010113          	addi	sp,sp,16
    80001eb4:	00000317          	auipc	t1,0x0
    80001eb8:	ce430067          	jr	-796(t1) # 80001b98 <main>

0000000080001ebc <either_copyout>:
    80001ebc:	ff010113          	addi	sp,sp,-16
    80001ec0:	00813023          	sd	s0,0(sp)
    80001ec4:	00113423          	sd	ra,8(sp)
    80001ec8:	01010413          	addi	s0,sp,16
    80001ecc:	02051663          	bnez	a0,80001ef8 <either_copyout+0x3c>
    80001ed0:	00058513          	mv	a0,a1
    80001ed4:	00060593          	mv	a1,a2
    80001ed8:	0006861b          	sext.w	a2,a3
    80001edc:	00002097          	auipc	ra,0x2
    80001ee0:	c58080e7          	jalr	-936(ra) # 80003b34 <__memmove>
    80001ee4:	00813083          	ld	ra,8(sp)
    80001ee8:	00013403          	ld	s0,0(sp)
    80001eec:	00000513          	li	a0,0
    80001ef0:	01010113          	addi	sp,sp,16
    80001ef4:	00008067          	ret
    80001ef8:	00002517          	auipc	a0,0x2
    80001efc:	31850513          	addi	a0,a0,792 # 80004210 <CONSOLE_STATUS+0x200>
    80001f00:	00001097          	auipc	ra,0x1
    80001f04:	92c080e7          	jalr	-1748(ra) # 8000282c <panic>

0000000080001f08 <either_copyin>:
    80001f08:	ff010113          	addi	sp,sp,-16
    80001f0c:	00813023          	sd	s0,0(sp)
    80001f10:	00113423          	sd	ra,8(sp)
    80001f14:	01010413          	addi	s0,sp,16
    80001f18:	02059463          	bnez	a1,80001f40 <either_copyin+0x38>
    80001f1c:	00060593          	mv	a1,a2
    80001f20:	0006861b          	sext.w	a2,a3
    80001f24:	00002097          	auipc	ra,0x2
    80001f28:	c10080e7          	jalr	-1008(ra) # 80003b34 <__memmove>
    80001f2c:	00813083          	ld	ra,8(sp)
    80001f30:	00013403          	ld	s0,0(sp)
    80001f34:	00000513          	li	a0,0
    80001f38:	01010113          	addi	sp,sp,16
    80001f3c:	00008067          	ret
    80001f40:	00002517          	auipc	a0,0x2
    80001f44:	2f850513          	addi	a0,a0,760 # 80004238 <CONSOLE_STATUS+0x228>
    80001f48:	00001097          	auipc	ra,0x1
    80001f4c:	8e4080e7          	jalr	-1820(ra) # 8000282c <panic>

0000000080001f50 <trapinit>:
    80001f50:	ff010113          	addi	sp,sp,-16
    80001f54:	00813423          	sd	s0,8(sp)
    80001f58:	01010413          	addi	s0,sp,16
    80001f5c:	00813403          	ld	s0,8(sp)
    80001f60:	00002597          	auipc	a1,0x2
    80001f64:	30058593          	addi	a1,a1,768 # 80004260 <CONSOLE_STATUS+0x250>
    80001f68:	00003517          	auipc	a0,0x3
    80001f6c:	7f850513          	addi	a0,a0,2040 # 80005760 <tickslock>
    80001f70:	01010113          	addi	sp,sp,16
    80001f74:	00001317          	auipc	t1,0x1
    80001f78:	5c430067          	jr	1476(t1) # 80003538 <initlock>

0000000080001f7c <trapinithart>:
    80001f7c:	ff010113          	addi	sp,sp,-16
    80001f80:	00813423          	sd	s0,8(sp)
    80001f84:	01010413          	addi	s0,sp,16
    80001f88:	00000797          	auipc	a5,0x0
    80001f8c:	2f878793          	addi	a5,a5,760 # 80002280 <kernelvec>
    80001f90:	10579073          	csrw	stvec,a5
    80001f94:	00813403          	ld	s0,8(sp)
    80001f98:	01010113          	addi	sp,sp,16
    80001f9c:	00008067          	ret

0000000080001fa0 <usertrap>:
    80001fa0:	ff010113          	addi	sp,sp,-16
    80001fa4:	00813423          	sd	s0,8(sp)
    80001fa8:	01010413          	addi	s0,sp,16
    80001fac:	00813403          	ld	s0,8(sp)
    80001fb0:	01010113          	addi	sp,sp,16
    80001fb4:	00008067          	ret

0000000080001fb8 <usertrapret>:
    80001fb8:	ff010113          	addi	sp,sp,-16
    80001fbc:	00813423          	sd	s0,8(sp)
    80001fc0:	01010413          	addi	s0,sp,16
    80001fc4:	00813403          	ld	s0,8(sp)
    80001fc8:	01010113          	addi	sp,sp,16
    80001fcc:	00008067          	ret

0000000080001fd0 <kerneltrap>:
    80001fd0:	fe010113          	addi	sp,sp,-32
    80001fd4:	00813823          	sd	s0,16(sp)
    80001fd8:	00113c23          	sd	ra,24(sp)
    80001fdc:	00913423          	sd	s1,8(sp)
    80001fe0:	02010413          	addi	s0,sp,32
    80001fe4:	142025f3          	csrr	a1,scause
    80001fe8:	100027f3          	csrr	a5,sstatus
    80001fec:	0027f793          	andi	a5,a5,2
    80001ff0:	10079c63          	bnez	a5,80002108 <kerneltrap+0x138>
    80001ff4:	142027f3          	csrr	a5,scause
    80001ff8:	0207ce63          	bltz	a5,80002034 <kerneltrap+0x64>
    80001ffc:	00002517          	auipc	a0,0x2
    80002000:	2ac50513          	addi	a0,a0,684 # 800042a8 <CONSOLE_STATUS+0x298>
    80002004:	00001097          	auipc	ra,0x1
    80002008:	884080e7          	jalr	-1916(ra) # 80002888 <__printf>
    8000200c:	141025f3          	csrr	a1,sepc
    80002010:	14302673          	csrr	a2,stval
    80002014:	00002517          	auipc	a0,0x2
    80002018:	2a450513          	addi	a0,a0,676 # 800042b8 <CONSOLE_STATUS+0x2a8>
    8000201c:	00001097          	auipc	ra,0x1
    80002020:	86c080e7          	jalr	-1940(ra) # 80002888 <__printf>
    80002024:	00002517          	auipc	a0,0x2
    80002028:	2ac50513          	addi	a0,a0,684 # 800042d0 <CONSOLE_STATUS+0x2c0>
    8000202c:	00001097          	auipc	ra,0x1
    80002030:	800080e7          	jalr	-2048(ra) # 8000282c <panic>
    80002034:	0ff7f713          	andi	a4,a5,255
    80002038:	00900693          	li	a3,9
    8000203c:	04d70063          	beq	a4,a3,8000207c <kerneltrap+0xac>
    80002040:	fff00713          	li	a4,-1
    80002044:	03f71713          	slli	a4,a4,0x3f
    80002048:	00170713          	addi	a4,a4,1
    8000204c:	fae798e3          	bne	a5,a4,80001ffc <kerneltrap+0x2c>
    80002050:	00000097          	auipc	ra,0x0
    80002054:	e00080e7          	jalr	-512(ra) # 80001e50 <cpuid>
    80002058:	06050663          	beqz	a0,800020c4 <kerneltrap+0xf4>
    8000205c:	144027f3          	csrr	a5,sip
    80002060:	ffd7f793          	andi	a5,a5,-3
    80002064:	14479073          	csrw	sip,a5
    80002068:	01813083          	ld	ra,24(sp)
    8000206c:	01013403          	ld	s0,16(sp)
    80002070:	00813483          	ld	s1,8(sp)
    80002074:	02010113          	addi	sp,sp,32
    80002078:	00008067          	ret
    8000207c:	00000097          	auipc	ra,0x0
    80002080:	3c8080e7          	jalr	968(ra) # 80002444 <plic_claim>
    80002084:	00a00793          	li	a5,10
    80002088:	00050493          	mv	s1,a0
    8000208c:	06f50863          	beq	a0,a5,800020fc <kerneltrap+0x12c>
    80002090:	fc050ce3          	beqz	a0,80002068 <kerneltrap+0x98>
    80002094:	00050593          	mv	a1,a0
    80002098:	00002517          	auipc	a0,0x2
    8000209c:	1f050513          	addi	a0,a0,496 # 80004288 <CONSOLE_STATUS+0x278>
    800020a0:	00000097          	auipc	ra,0x0
    800020a4:	7e8080e7          	jalr	2024(ra) # 80002888 <__printf>
    800020a8:	01013403          	ld	s0,16(sp)
    800020ac:	01813083          	ld	ra,24(sp)
    800020b0:	00048513          	mv	a0,s1
    800020b4:	00813483          	ld	s1,8(sp)
    800020b8:	02010113          	addi	sp,sp,32
    800020bc:	00000317          	auipc	t1,0x0
    800020c0:	3c030067          	jr	960(t1) # 8000247c <plic_complete>
    800020c4:	00003517          	auipc	a0,0x3
    800020c8:	69c50513          	addi	a0,a0,1692 # 80005760 <tickslock>
    800020cc:	00001097          	auipc	ra,0x1
    800020d0:	490080e7          	jalr	1168(ra) # 8000355c <acquire>
    800020d4:	00002717          	auipc	a4,0x2
    800020d8:	58070713          	addi	a4,a4,1408 # 80004654 <ticks>
    800020dc:	00072783          	lw	a5,0(a4)
    800020e0:	00003517          	auipc	a0,0x3
    800020e4:	68050513          	addi	a0,a0,1664 # 80005760 <tickslock>
    800020e8:	0017879b          	addiw	a5,a5,1
    800020ec:	00f72023          	sw	a5,0(a4)
    800020f0:	00001097          	auipc	ra,0x1
    800020f4:	538080e7          	jalr	1336(ra) # 80003628 <release>
    800020f8:	f65ff06f          	j	8000205c <kerneltrap+0x8c>
    800020fc:	00001097          	auipc	ra,0x1
    80002100:	094080e7          	jalr	148(ra) # 80003190 <uartintr>
    80002104:	fa5ff06f          	j	800020a8 <kerneltrap+0xd8>
    80002108:	00002517          	auipc	a0,0x2
    8000210c:	16050513          	addi	a0,a0,352 # 80004268 <CONSOLE_STATUS+0x258>
    80002110:	00000097          	auipc	ra,0x0
    80002114:	71c080e7          	jalr	1820(ra) # 8000282c <panic>

0000000080002118 <clockintr>:
    80002118:	fe010113          	addi	sp,sp,-32
    8000211c:	00813823          	sd	s0,16(sp)
    80002120:	00913423          	sd	s1,8(sp)
    80002124:	00113c23          	sd	ra,24(sp)
    80002128:	02010413          	addi	s0,sp,32
    8000212c:	00003497          	auipc	s1,0x3
    80002130:	63448493          	addi	s1,s1,1588 # 80005760 <tickslock>
    80002134:	00048513          	mv	a0,s1
    80002138:	00001097          	auipc	ra,0x1
    8000213c:	424080e7          	jalr	1060(ra) # 8000355c <acquire>
    80002140:	00002717          	auipc	a4,0x2
    80002144:	51470713          	addi	a4,a4,1300 # 80004654 <ticks>
    80002148:	00072783          	lw	a5,0(a4)
    8000214c:	01013403          	ld	s0,16(sp)
    80002150:	01813083          	ld	ra,24(sp)
    80002154:	00048513          	mv	a0,s1
    80002158:	0017879b          	addiw	a5,a5,1
    8000215c:	00813483          	ld	s1,8(sp)
    80002160:	00f72023          	sw	a5,0(a4)
    80002164:	02010113          	addi	sp,sp,32
    80002168:	00001317          	auipc	t1,0x1
    8000216c:	4c030067          	jr	1216(t1) # 80003628 <release>

0000000080002170 <devintr>:
    80002170:	142027f3          	csrr	a5,scause
    80002174:	00000513          	li	a0,0
    80002178:	0007c463          	bltz	a5,80002180 <devintr+0x10>
    8000217c:	00008067          	ret
    80002180:	fe010113          	addi	sp,sp,-32
    80002184:	00813823          	sd	s0,16(sp)
    80002188:	00113c23          	sd	ra,24(sp)
    8000218c:	00913423          	sd	s1,8(sp)
    80002190:	02010413          	addi	s0,sp,32
    80002194:	0ff7f713          	andi	a4,a5,255
    80002198:	00900693          	li	a3,9
    8000219c:	04d70c63          	beq	a4,a3,800021f4 <devintr+0x84>
    800021a0:	fff00713          	li	a4,-1
    800021a4:	03f71713          	slli	a4,a4,0x3f
    800021a8:	00170713          	addi	a4,a4,1
    800021ac:	00e78c63          	beq	a5,a4,800021c4 <devintr+0x54>
    800021b0:	01813083          	ld	ra,24(sp)
    800021b4:	01013403          	ld	s0,16(sp)
    800021b8:	00813483          	ld	s1,8(sp)
    800021bc:	02010113          	addi	sp,sp,32
    800021c0:	00008067          	ret
    800021c4:	00000097          	auipc	ra,0x0
    800021c8:	c8c080e7          	jalr	-884(ra) # 80001e50 <cpuid>
    800021cc:	06050663          	beqz	a0,80002238 <devintr+0xc8>
    800021d0:	144027f3          	csrr	a5,sip
    800021d4:	ffd7f793          	andi	a5,a5,-3
    800021d8:	14479073          	csrw	sip,a5
    800021dc:	01813083          	ld	ra,24(sp)
    800021e0:	01013403          	ld	s0,16(sp)
    800021e4:	00813483          	ld	s1,8(sp)
    800021e8:	00200513          	li	a0,2
    800021ec:	02010113          	addi	sp,sp,32
    800021f0:	00008067          	ret
    800021f4:	00000097          	auipc	ra,0x0
    800021f8:	250080e7          	jalr	592(ra) # 80002444 <plic_claim>
    800021fc:	00a00793          	li	a5,10
    80002200:	00050493          	mv	s1,a0
    80002204:	06f50663          	beq	a0,a5,80002270 <devintr+0x100>
    80002208:	00100513          	li	a0,1
    8000220c:	fa0482e3          	beqz	s1,800021b0 <devintr+0x40>
    80002210:	00048593          	mv	a1,s1
    80002214:	00002517          	auipc	a0,0x2
    80002218:	07450513          	addi	a0,a0,116 # 80004288 <CONSOLE_STATUS+0x278>
    8000221c:	00000097          	auipc	ra,0x0
    80002220:	66c080e7          	jalr	1644(ra) # 80002888 <__printf>
    80002224:	00048513          	mv	a0,s1
    80002228:	00000097          	auipc	ra,0x0
    8000222c:	254080e7          	jalr	596(ra) # 8000247c <plic_complete>
    80002230:	00100513          	li	a0,1
    80002234:	f7dff06f          	j	800021b0 <devintr+0x40>
    80002238:	00003517          	auipc	a0,0x3
    8000223c:	52850513          	addi	a0,a0,1320 # 80005760 <tickslock>
    80002240:	00001097          	auipc	ra,0x1
    80002244:	31c080e7          	jalr	796(ra) # 8000355c <acquire>
    80002248:	00002717          	auipc	a4,0x2
    8000224c:	40c70713          	addi	a4,a4,1036 # 80004654 <ticks>
    80002250:	00072783          	lw	a5,0(a4)
    80002254:	00003517          	auipc	a0,0x3
    80002258:	50c50513          	addi	a0,a0,1292 # 80005760 <tickslock>
    8000225c:	0017879b          	addiw	a5,a5,1
    80002260:	00f72023          	sw	a5,0(a4)
    80002264:	00001097          	auipc	ra,0x1
    80002268:	3c4080e7          	jalr	964(ra) # 80003628 <release>
    8000226c:	f65ff06f          	j	800021d0 <devintr+0x60>
    80002270:	00001097          	auipc	ra,0x1
    80002274:	f20080e7          	jalr	-224(ra) # 80003190 <uartintr>
    80002278:	fadff06f          	j	80002224 <devintr+0xb4>
    8000227c:	0000                	unimp
	...

0000000080002280 <kernelvec>:
    80002280:	f0010113          	addi	sp,sp,-256
    80002284:	00113023          	sd	ra,0(sp)
    80002288:	00213423          	sd	sp,8(sp)
    8000228c:	00313823          	sd	gp,16(sp)
    80002290:	00413c23          	sd	tp,24(sp)
    80002294:	02513023          	sd	t0,32(sp)
    80002298:	02613423          	sd	t1,40(sp)
    8000229c:	02713823          	sd	t2,48(sp)
    800022a0:	02813c23          	sd	s0,56(sp)
    800022a4:	04913023          	sd	s1,64(sp)
    800022a8:	04a13423          	sd	a0,72(sp)
    800022ac:	04b13823          	sd	a1,80(sp)
    800022b0:	04c13c23          	sd	a2,88(sp)
    800022b4:	06d13023          	sd	a3,96(sp)
    800022b8:	06e13423          	sd	a4,104(sp)
    800022bc:	06f13823          	sd	a5,112(sp)
    800022c0:	07013c23          	sd	a6,120(sp)
    800022c4:	09113023          	sd	a7,128(sp)
    800022c8:	09213423          	sd	s2,136(sp)
    800022cc:	09313823          	sd	s3,144(sp)
    800022d0:	09413c23          	sd	s4,152(sp)
    800022d4:	0b513023          	sd	s5,160(sp)
    800022d8:	0b613423          	sd	s6,168(sp)
    800022dc:	0b713823          	sd	s7,176(sp)
    800022e0:	0b813c23          	sd	s8,184(sp)
    800022e4:	0d913023          	sd	s9,192(sp)
    800022e8:	0da13423          	sd	s10,200(sp)
    800022ec:	0db13823          	sd	s11,208(sp)
    800022f0:	0dc13c23          	sd	t3,216(sp)
    800022f4:	0fd13023          	sd	t4,224(sp)
    800022f8:	0fe13423          	sd	t5,232(sp)
    800022fc:	0ff13823          	sd	t6,240(sp)
    80002300:	cd1ff0ef          	jal	ra,80001fd0 <kerneltrap>
    80002304:	00013083          	ld	ra,0(sp)
    80002308:	00813103          	ld	sp,8(sp)
    8000230c:	01013183          	ld	gp,16(sp)
    80002310:	02013283          	ld	t0,32(sp)
    80002314:	02813303          	ld	t1,40(sp)
    80002318:	03013383          	ld	t2,48(sp)
    8000231c:	03813403          	ld	s0,56(sp)
    80002320:	04013483          	ld	s1,64(sp)
    80002324:	04813503          	ld	a0,72(sp)
    80002328:	05013583          	ld	a1,80(sp)
    8000232c:	05813603          	ld	a2,88(sp)
    80002330:	06013683          	ld	a3,96(sp)
    80002334:	06813703          	ld	a4,104(sp)
    80002338:	07013783          	ld	a5,112(sp)
    8000233c:	07813803          	ld	a6,120(sp)
    80002340:	08013883          	ld	a7,128(sp)
    80002344:	08813903          	ld	s2,136(sp)
    80002348:	09013983          	ld	s3,144(sp)
    8000234c:	09813a03          	ld	s4,152(sp)
    80002350:	0a013a83          	ld	s5,160(sp)
    80002354:	0a813b03          	ld	s6,168(sp)
    80002358:	0b013b83          	ld	s7,176(sp)
    8000235c:	0b813c03          	ld	s8,184(sp)
    80002360:	0c013c83          	ld	s9,192(sp)
    80002364:	0c813d03          	ld	s10,200(sp)
    80002368:	0d013d83          	ld	s11,208(sp)
    8000236c:	0d813e03          	ld	t3,216(sp)
    80002370:	0e013e83          	ld	t4,224(sp)
    80002374:	0e813f03          	ld	t5,232(sp)
    80002378:	0f013f83          	ld	t6,240(sp)
    8000237c:	10010113          	addi	sp,sp,256
    80002380:	10200073          	sret
    80002384:	00000013          	nop
    80002388:	00000013          	nop
    8000238c:	00000013          	nop

0000000080002390 <timervec>:
    80002390:	34051573          	csrrw	a0,mscratch,a0
    80002394:	00b53023          	sd	a1,0(a0)
    80002398:	00c53423          	sd	a2,8(a0)
    8000239c:	00d53823          	sd	a3,16(a0)
    800023a0:	01853583          	ld	a1,24(a0)
    800023a4:	02053603          	ld	a2,32(a0)
    800023a8:	0005b683          	ld	a3,0(a1)
    800023ac:	00c686b3          	add	a3,a3,a2
    800023b0:	00d5b023          	sd	a3,0(a1)
    800023b4:	00200593          	li	a1,2
    800023b8:	14459073          	csrw	sip,a1
    800023bc:	01053683          	ld	a3,16(a0)
    800023c0:	00853603          	ld	a2,8(a0)
    800023c4:	00053583          	ld	a1,0(a0)
    800023c8:	34051573          	csrrw	a0,mscratch,a0
    800023cc:	30200073          	mret

00000000800023d0 <plicinit>:
    800023d0:	ff010113          	addi	sp,sp,-16
    800023d4:	00813423          	sd	s0,8(sp)
    800023d8:	01010413          	addi	s0,sp,16
    800023dc:	00813403          	ld	s0,8(sp)
    800023e0:	0c0007b7          	lui	a5,0xc000
    800023e4:	00100713          	li	a4,1
    800023e8:	02e7a423          	sw	a4,40(a5) # c000028 <_entry-0x73ffffd8>
    800023ec:	00e7a223          	sw	a4,4(a5)
    800023f0:	01010113          	addi	sp,sp,16
    800023f4:	00008067          	ret

00000000800023f8 <plicinithart>:
    800023f8:	ff010113          	addi	sp,sp,-16
    800023fc:	00813023          	sd	s0,0(sp)
    80002400:	00113423          	sd	ra,8(sp)
    80002404:	01010413          	addi	s0,sp,16
    80002408:	00000097          	auipc	ra,0x0
    8000240c:	a48080e7          	jalr	-1464(ra) # 80001e50 <cpuid>
    80002410:	0085171b          	slliw	a4,a0,0x8
    80002414:	0c0027b7          	lui	a5,0xc002
    80002418:	00e787b3          	add	a5,a5,a4
    8000241c:	40200713          	li	a4,1026
    80002420:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>
    80002424:	00813083          	ld	ra,8(sp)
    80002428:	00013403          	ld	s0,0(sp)
    8000242c:	00d5151b          	slliw	a0,a0,0xd
    80002430:	0c2017b7          	lui	a5,0xc201
    80002434:	00a78533          	add	a0,a5,a0
    80002438:	00052023          	sw	zero,0(a0)
    8000243c:	01010113          	addi	sp,sp,16
    80002440:	00008067          	ret

0000000080002444 <plic_claim>:
    80002444:	ff010113          	addi	sp,sp,-16
    80002448:	00813023          	sd	s0,0(sp)
    8000244c:	00113423          	sd	ra,8(sp)
    80002450:	01010413          	addi	s0,sp,16
    80002454:	00000097          	auipc	ra,0x0
    80002458:	9fc080e7          	jalr	-1540(ra) # 80001e50 <cpuid>
    8000245c:	00813083          	ld	ra,8(sp)
    80002460:	00013403          	ld	s0,0(sp)
    80002464:	00d5151b          	slliw	a0,a0,0xd
    80002468:	0c2017b7          	lui	a5,0xc201
    8000246c:	00a78533          	add	a0,a5,a0
    80002470:	00452503          	lw	a0,4(a0)
    80002474:	01010113          	addi	sp,sp,16
    80002478:	00008067          	ret

000000008000247c <plic_complete>:
    8000247c:	fe010113          	addi	sp,sp,-32
    80002480:	00813823          	sd	s0,16(sp)
    80002484:	00913423          	sd	s1,8(sp)
    80002488:	00113c23          	sd	ra,24(sp)
    8000248c:	02010413          	addi	s0,sp,32
    80002490:	00050493          	mv	s1,a0
    80002494:	00000097          	auipc	ra,0x0
    80002498:	9bc080e7          	jalr	-1604(ra) # 80001e50 <cpuid>
    8000249c:	01813083          	ld	ra,24(sp)
    800024a0:	01013403          	ld	s0,16(sp)
    800024a4:	00d5179b          	slliw	a5,a0,0xd
    800024a8:	0c201737          	lui	a4,0xc201
    800024ac:	00f707b3          	add	a5,a4,a5
    800024b0:	0097a223          	sw	s1,4(a5) # c201004 <_entry-0x73dfeffc>
    800024b4:	00813483          	ld	s1,8(sp)
    800024b8:	02010113          	addi	sp,sp,32
    800024bc:	00008067          	ret

00000000800024c0 <consolewrite>:
    800024c0:	fb010113          	addi	sp,sp,-80
    800024c4:	04813023          	sd	s0,64(sp)
    800024c8:	04113423          	sd	ra,72(sp)
    800024cc:	02913c23          	sd	s1,56(sp)
    800024d0:	03213823          	sd	s2,48(sp)
    800024d4:	03313423          	sd	s3,40(sp)
    800024d8:	03413023          	sd	s4,32(sp)
    800024dc:	01513c23          	sd	s5,24(sp)
    800024e0:	05010413          	addi	s0,sp,80
    800024e4:	06c05c63          	blez	a2,8000255c <consolewrite+0x9c>
    800024e8:	00060993          	mv	s3,a2
    800024ec:	00050a13          	mv	s4,a0
    800024f0:	00058493          	mv	s1,a1
    800024f4:	00000913          	li	s2,0
    800024f8:	fff00a93          	li	s5,-1
    800024fc:	01c0006f          	j	80002518 <consolewrite+0x58>
    80002500:	fbf44503          	lbu	a0,-65(s0)
    80002504:	0019091b          	addiw	s2,s2,1
    80002508:	00148493          	addi	s1,s1,1
    8000250c:	00001097          	auipc	ra,0x1
    80002510:	a9c080e7          	jalr	-1380(ra) # 80002fa8 <uartputc>
    80002514:	03298063          	beq	s3,s2,80002534 <consolewrite+0x74>
    80002518:	00048613          	mv	a2,s1
    8000251c:	00100693          	li	a3,1
    80002520:	000a0593          	mv	a1,s4
    80002524:	fbf40513          	addi	a0,s0,-65
    80002528:	00000097          	auipc	ra,0x0
    8000252c:	9e0080e7          	jalr	-1568(ra) # 80001f08 <either_copyin>
    80002530:	fd5518e3          	bne	a0,s5,80002500 <consolewrite+0x40>
    80002534:	04813083          	ld	ra,72(sp)
    80002538:	04013403          	ld	s0,64(sp)
    8000253c:	03813483          	ld	s1,56(sp)
    80002540:	02813983          	ld	s3,40(sp)
    80002544:	02013a03          	ld	s4,32(sp)
    80002548:	01813a83          	ld	s5,24(sp)
    8000254c:	00090513          	mv	a0,s2
    80002550:	03013903          	ld	s2,48(sp)
    80002554:	05010113          	addi	sp,sp,80
    80002558:	00008067          	ret
    8000255c:	00000913          	li	s2,0
    80002560:	fd5ff06f          	j	80002534 <consolewrite+0x74>

0000000080002564 <consoleread>:
    80002564:	f9010113          	addi	sp,sp,-112
    80002568:	06813023          	sd	s0,96(sp)
    8000256c:	04913c23          	sd	s1,88(sp)
    80002570:	05213823          	sd	s2,80(sp)
    80002574:	05313423          	sd	s3,72(sp)
    80002578:	05413023          	sd	s4,64(sp)
    8000257c:	03513c23          	sd	s5,56(sp)
    80002580:	03613823          	sd	s6,48(sp)
    80002584:	03713423          	sd	s7,40(sp)
    80002588:	03813023          	sd	s8,32(sp)
    8000258c:	06113423          	sd	ra,104(sp)
    80002590:	01913c23          	sd	s9,24(sp)
    80002594:	07010413          	addi	s0,sp,112
    80002598:	00060b93          	mv	s7,a2
    8000259c:	00050913          	mv	s2,a0
    800025a0:	00058c13          	mv	s8,a1
    800025a4:	00060b1b          	sext.w	s6,a2
    800025a8:	00003497          	auipc	s1,0x3
    800025ac:	1d048493          	addi	s1,s1,464 # 80005778 <cons>
    800025b0:	00400993          	li	s3,4
    800025b4:	fff00a13          	li	s4,-1
    800025b8:	00a00a93          	li	s5,10
    800025bc:	05705e63          	blez	s7,80002618 <consoleread+0xb4>
    800025c0:	09c4a703          	lw	a4,156(s1)
    800025c4:	0984a783          	lw	a5,152(s1)
    800025c8:	0007071b          	sext.w	a4,a4
    800025cc:	08e78463          	beq	a5,a4,80002654 <consoleread+0xf0>
    800025d0:	07f7f713          	andi	a4,a5,127
    800025d4:	00e48733          	add	a4,s1,a4
    800025d8:	01874703          	lbu	a4,24(a4) # c201018 <_entry-0x73dfefe8>
    800025dc:	0017869b          	addiw	a3,a5,1
    800025e0:	08d4ac23          	sw	a3,152(s1)
    800025e4:	00070c9b          	sext.w	s9,a4
    800025e8:	0b370663          	beq	a4,s3,80002694 <consoleread+0x130>
    800025ec:	00100693          	li	a3,1
    800025f0:	f9f40613          	addi	a2,s0,-97
    800025f4:	000c0593          	mv	a1,s8
    800025f8:	00090513          	mv	a0,s2
    800025fc:	f8e40fa3          	sb	a4,-97(s0)
    80002600:	00000097          	auipc	ra,0x0
    80002604:	8bc080e7          	jalr	-1860(ra) # 80001ebc <either_copyout>
    80002608:	01450863          	beq	a0,s4,80002618 <consoleread+0xb4>
    8000260c:	001c0c13          	addi	s8,s8,1
    80002610:	fffb8b9b          	addiw	s7,s7,-1
    80002614:	fb5c94e3          	bne	s9,s5,800025bc <consoleread+0x58>
    80002618:	000b851b          	sext.w	a0,s7
    8000261c:	06813083          	ld	ra,104(sp)
    80002620:	06013403          	ld	s0,96(sp)
    80002624:	05813483          	ld	s1,88(sp)
    80002628:	05013903          	ld	s2,80(sp)
    8000262c:	04813983          	ld	s3,72(sp)
    80002630:	04013a03          	ld	s4,64(sp)
    80002634:	03813a83          	ld	s5,56(sp)
    80002638:	02813b83          	ld	s7,40(sp)
    8000263c:	02013c03          	ld	s8,32(sp)
    80002640:	01813c83          	ld	s9,24(sp)
    80002644:	40ab053b          	subw	a0,s6,a0
    80002648:	03013b03          	ld	s6,48(sp)
    8000264c:	07010113          	addi	sp,sp,112
    80002650:	00008067          	ret
    80002654:	00001097          	auipc	ra,0x1
    80002658:	1d8080e7          	jalr	472(ra) # 8000382c <push_on>
    8000265c:	0984a703          	lw	a4,152(s1)
    80002660:	09c4a783          	lw	a5,156(s1)
    80002664:	0007879b          	sext.w	a5,a5
    80002668:	fef70ce3          	beq	a4,a5,80002660 <consoleread+0xfc>
    8000266c:	00001097          	auipc	ra,0x1
    80002670:	234080e7          	jalr	564(ra) # 800038a0 <pop_on>
    80002674:	0984a783          	lw	a5,152(s1)
    80002678:	07f7f713          	andi	a4,a5,127
    8000267c:	00e48733          	add	a4,s1,a4
    80002680:	01874703          	lbu	a4,24(a4)
    80002684:	0017869b          	addiw	a3,a5,1
    80002688:	08d4ac23          	sw	a3,152(s1)
    8000268c:	00070c9b          	sext.w	s9,a4
    80002690:	f5371ee3          	bne	a4,s3,800025ec <consoleread+0x88>
    80002694:	000b851b          	sext.w	a0,s7
    80002698:	f96bf2e3          	bgeu	s7,s6,8000261c <consoleread+0xb8>
    8000269c:	08f4ac23          	sw	a5,152(s1)
    800026a0:	f7dff06f          	j	8000261c <consoleread+0xb8>

00000000800026a4 <consputc>:
    800026a4:	10000793          	li	a5,256
    800026a8:	00f50663          	beq	a0,a5,800026b4 <consputc+0x10>
    800026ac:	00001317          	auipc	t1,0x1
    800026b0:	9f430067          	jr	-1548(t1) # 800030a0 <uartputc_sync>
    800026b4:	ff010113          	addi	sp,sp,-16
    800026b8:	00113423          	sd	ra,8(sp)
    800026bc:	00813023          	sd	s0,0(sp)
    800026c0:	01010413          	addi	s0,sp,16
    800026c4:	00800513          	li	a0,8
    800026c8:	00001097          	auipc	ra,0x1
    800026cc:	9d8080e7          	jalr	-1576(ra) # 800030a0 <uartputc_sync>
    800026d0:	02000513          	li	a0,32
    800026d4:	00001097          	auipc	ra,0x1
    800026d8:	9cc080e7          	jalr	-1588(ra) # 800030a0 <uartputc_sync>
    800026dc:	00013403          	ld	s0,0(sp)
    800026e0:	00813083          	ld	ra,8(sp)
    800026e4:	00800513          	li	a0,8
    800026e8:	01010113          	addi	sp,sp,16
    800026ec:	00001317          	auipc	t1,0x1
    800026f0:	9b430067          	jr	-1612(t1) # 800030a0 <uartputc_sync>

00000000800026f4 <consoleintr>:
    800026f4:	fe010113          	addi	sp,sp,-32
    800026f8:	00813823          	sd	s0,16(sp)
    800026fc:	00913423          	sd	s1,8(sp)
    80002700:	01213023          	sd	s2,0(sp)
    80002704:	00113c23          	sd	ra,24(sp)
    80002708:	02010413          	addi	s0,sp,32
    8000270c:	00003917          	auipc	s2,0x3
    80002710:	06c90913          	addi	s2,s2,108 # 80005778 <cons>
    80002714:	00050493          	mv	s1,a0
    80002718:	00090513          	mv	a0,s2
    8000271c:	00001097          	auipc	ra,0x1
    80002720:	e40080e7          	jalr	-448(ra) # 8000355c <acquire>
    80002724:	02048c63          	beqz	s1,8000275c <consoleintr+0x68>
    80002728:	0a092783          	lw	a5,160(s2)
    8000272c:	09892703          	lw	a4,152(s2)
    80002730:	07f00693          	li	a3,127
    80002734:	40e7873b          	subw	a4,a5,a4
    80002738:	02e6e263          	bltu	a3,a4,8000275c <consoleintr+0x68>
    8000273c:	00d00713          	li	a4,13
    80002740:	04e48063          	beq	s1,a4,80002780 <consoleintr+0x8c>
    80002744:	07f7f713          	andi	a4,a5,127
    80002748:	00e90733          	add	a4,s2,a4
    8000274c:	0017879b          	addiw	a5,a5,1
    80002750:	0af92023          	sw	a5,160(s2)
    80002754:	00970c23          	sb	s1,24(a4)
    80002758:	08f92e23          	sw	a5,156(s2)
    8000275c:	01013403          	ld	s0,16(sp)
    80002760:	01813083          	ld	ra,24(sp)
    80002764:	00813483          	ld	s1,8(sp)
    80002768:	00013903          	ld	s2,0(sp)
    8000276c:	00003517          	auipc	a0,0x3
    80002770:	00c50513          	addi	a0,a0,12 # 80005778 <cons>
    80002774:	02010113          	addi	sp,sp,32
    80002778:	00001317          	auipc	t1,0x1
    8000277c:	eb030067          	jr	-336(t1) # 80003628 <release>
    80002780:	00a00493          	li	s1,10
    80002784:	fc1ff06f          	j	80002744 <consoleintr+0x50>

0000000080002788 <consoleinit>:
    80002788:	fe010113          	addi	sp,sp,-32
    8000278c:	00113c23          	sd	ra,24(sp)
    80002790:	00813823          	sd	s0,16(sp)
    80002794:	00913423          	sd	s1,8(sp)
    80002798:	02010413          	addi	s0,sp,32
    8000279c:	00003497          	auipc	s1,0x3
    800027a0:	fdc48493          	addi	s1,s1,-36 # 80005778 <cons>
    800027a4:	00048513          	mv	a0,s1
    800027a8:	00002597          	auipc	a1,0x2
    800027ac:	b3858593          	addi	a1,a1,-1224 # 800042e0 <CONSOLE_STATUS+0x2d0>
    800027b0:	00001097          	auipc	ra,0x1
    800027b4:	d88080e7          	jalr	-632(ra) # 80003538 <initlock>
    800027b8:	00000097          	auipc	ra,0x0
    800027bc:	7ac080e7          	jalr	1964(ra) # 80002f64 <uartinit>
    800027c0:	01813083          	ld	ra,24(sp)
    800027c4:	01013403          	ld	s0,16(sp)
    800027c8:	00000797          	auipc	a5,0x0
    800027cc:	d9c78793          	addi	a5,a5,-612 # 80002564 <consoleread>
    800027d0:	0af4bc23          	sd	a5,184(s1)
    800027d4:	00000797          	auipc	a5,0x0
    800027d8:	cec78793          	addi	a5,a5,-788 # 800024c0 <consolewrite>
    800027dc:	0cf4b023          	sd	a5,192(s1)
    800027e0:	00813483          	ld	s1,8(sp)
    800027e4:	02010113          	addi	sp,sp,32
    800027e8:	00008067          	ret

00000000800027ec <console_read>:
    800027ec:	ff010113          	addi	sp,sp,-16
    800027f0:	00813423          	sd	s0,8(sp)
    800027f4:	01010413          	addi	s0,sp,16
    800027f8:	00813403          	ld	s0,8(sp)
    800027fc:	00003317          	auipc	t1,0x3
    80002800:	03433303          	ld	t1,52(t1) # 80005830 <devsw+0x10>
    80002804:	01010113          	addi	sp,sp,16
    80002808:	00030067          	jr	t1

000000008000280c <console_write>:
    8000280c:	ff010113          	addi	sp,sp,-16
    80002810:	00813423          	sd	s0,8(sp)
    80002814:	01010413          	addi	s0,sp,16
    80002818:	00813403          	ld	s0,8(sp)
    8000281c:	00003317          	auipc	t1,0x3
    80002820:	01c33303          	ld	t1,28(t1) # 80005838 <devsw+0x18>
    80002824:	01010113          	addi	sp,sp,16
    80002828:	00030067          	jr	t1

000000008000282c <panic>:
    8000282c:	fe010113          	addi	sp,sp,-32
    80002830:	00113c23          	sd	ra,24(sp)
    80002834:	00813823          	sd	s0,16(sp)
    80002838:	00913423          	sd	s1,8(sp)
    8000283c:	02010413          	addi	s0,sp,32
    80002840:	00050493          	mv	s1,a0
    80002844:	00002517          	auipc	a0,0x2
    80002848:	aa450513          	addi	a0,a0,-1372 # 800042e8 <CONSOLE_STATUS+0x2d8>
    8000284c:	00003797          	auipc	a5,0x3
    80002850:	0807a623          	sw	zero,140(a5) # 800058d8 <pr+0x18>
    80002854:	00000097          	auipc	ra,0x0
    80002858:	034080e7          	jalr	52(ra) # 80002888 <__printf>
    8000285c:	00048513          	mv	a0,s1
    80002860:	00000097          	auipc	ra,0x0
    80002864:	028080e7          	jalr	40(ra) # 80002888 <__printf>
    80002868:	00002517          	auipc	a0,0x2
    8000286c:	a6050513          	addi	a0,a0,-1440 # 800042c8 <CONSOLE_STATUS+0x2b8>
    80002870:	00000097          	auipc	ra,0x0
    80002874:	018080e7          	jalr	24(ra) # 80002888 <__printf>
    80002878:	00100793          	li	a5,1
    8000287c:	00002717          	auipc	a4,0x2
    80002880:	dcf72e23          	sw	a5,-548(a4) # 80004658 <panicked>
    80002884:	0000006f          	j	80002884 <panic+0x58>

0000000080002888 <__printf>:
    80002888:	f3010113          	addi	sp,sp,-208
    8000288c:	08813023          	sd	s0,128(sp)
    80002890:	07313423          	sd	s3,104(sp)
    80002894:	09010413          	addi	s0,sp,144
    80002898:	05813023          	sd	s8,64(sp)
    8000289c:	08113423          	sd	ra,136(sp)
    800028a0:	06913c23          	sd	s1,120(sp)
    800028a4:	07213823          	sd	s2,112(sp)
    800028a8:	07413023          	sd	s4,96(sp)
    800028ac:	05513c23          	sd	s5,88(sp)
    800028b0:	05613823          	sd	s6,80(sp)
    800028b4:	05713423          	sd	s7,72(sp)
    800028b8:	03913c23          	sd	s9,56(sp)
    800028bc:	03a13823          	sd	s10,48(sp)
    800028c0:	03b13423          	sd	s11,40(sp)
    800028c4:	00003317          	auipc	t1,0x3
    800028c8:	ffc30313          	addi	t1,t1,-4 # 800058c0 <pr>
    800028cc:	01832c03          	lw	s8,24(t1)
    800028d0:	00b43423          	sd	a1,8(s0)
    800028d4:	00c43823          	sd	a2,16(s0)
    800028d8:	00d43c23          	sd	a3,24(s0)
    800028dc:	02e43023          	sd	a4,32(s0)
    800028e0:	02f43423          	sd	a5,40(s0)
    800028e4:	03043823          	sd	a6,48(s0)
    800028e8:	03143c23          	sd	a7,56(s0)
    800028ec:	00050993          	mv	s3,a0
    800028f0:	4a0c1663          	bnez	s8,80002d9c <__printf+0x514>
    800028f4:	60098c63          	beqz	s3,80002f0c <__printf+0x684>
    800028f8:	0009c503          	lbu	a0,0(s3)
    800028fc:	00840793          	addi	a5,s0,8
    80002900:	f6f43c23          	sd	a5,-136(s0)
    80002904:	00000493          	li	s1,0
    80002908:	22050063          	beqz	a0,80002b28 <__printf+0x2a0>
    8000290c:	00002a37          	lui	s4,0x2
    80002910:	00018ab7          	lui	s5,0x18
    80002914:	000f4b37          	lui	s6,0xf4
    80002918:	00989bb7          	lui	s7,0x989
    8000291c:	70fa0a13          	addi	s4,s4,1807 # 270f <_entry-0x7fffd8f1>
    80002920:	69fa8a93          	addi	s5,s5,1695 # 1869f <_entry-0x7ffe7961>
    80002924:	23fb0b13          	addi	s6,s6,575 # f423f <_entry-0x7ff0bdc1>
    80002928:	67fb8b93          	addi	s7,s7,1663 # 98967f <_entry-0x7f676981>
    8000292c:	00148c9b          	addiw	s9,s1,1
    80002930:	02500793          	li	a5,37
    80002934:	01998933          	add	s2,s3,s9
    80002938:	38f51263          	bne	a0,a5,80002cbc <__printf+0x434>
    8000293c:	00094783          	lbu	a5,0(s2)
    80002940:	00078c9b          	sext.w	s9,a5
    80002944:	1e078263          	beqz	a5,80002b28 <__printf+0x2a0>
    80002948:	0024849b          	addiw	s1,s1,2
    8000294c:	07000713          	li	a4,112
    80002950:	00998933          	add	s2,s3,s1
    80002954:	38e78a63          	beq	a5,a4,80002ce8 <__printf+0x460>
    80002958:	20f76863          	bltu	a4,a5,80002b68 <__printf+0x2e0>
    8000295c:	42a78863          	beq	a5,a0,80002d8c <__printf+0x504>
    80002960:	06400713          	li	a4,100
    80002964:	40e79663          	bne	a5,a4,80002d70 <__printf+0x4e8>
    80002968:	f7843783          	ld	a5,-136(s0)
    8000296c:	0007a603          	lw	a2,0(a5)
    80002970:	00878793          	addi	a5,a5,8
    80002974:	f6f43c23          	sd	a5,-136(s0)
    80002978:	42064a63          	bltz	a2,80002dac <__printf+0x524>
    8000297c:	00a00713          	li	a4,10
    80002980:	02e677bb          	remuw	a5,a2,a4
    80002984:	00002d97          	auipc	s11,0x2
    80002988:	98cd8d93          	addi	s11,s11,-1652 # 80004310 <digits>
    8000298c:	00900593          	li	a1,9
    80002990:	0006051b          	sext.w	a0,a2
    80002994:	00000c93          	li	s9,0
    80002998:	02079793          	slli	a5,a5,0x20
    8000299c:	0207d793          	srli	a5,a5,0x20
    800029a0:	00fd87b3          	add	a5,s11,a5
    800029a4:	0007c783          	lbu	a5,0(a5)
    800029a8:	02e656bb          	divuw	a3,a2,a4
    800029ac:	f8f40023          	sb	a5,-128(s0)
    800029b0:	14c5d863          	bge	a1,a2,80002b00 <__printf+0x278>
    800029b4:	06300593          	li	a1,99
    800029b8:	00100c93          	li	s9,1
    800029bc:	02e6f7bb          	remuw	a5,a3,a4
    800029c0:	02079793          	slli	a5,a5,0x20
    800029c4:	0207d793          	srli	a5,a5,0x20
    800029c8:	00fd87b3          	add	a5,s11,a5
    800029cc:	0007c783          	lbu	a5,0(a5)
    800029d0:	02e6d73b          	divuw	a4,a3,a4
    800029d4:	f8f400a3          	sb	a5,-127(s0)
    800029d8:	12a5f463          	bgeu	a1,a0,80002b00 <__printf+0x278>
    800029dc:	00a00693          	li	a3,10
    800029e0:	00900593          	li	a1,9
    800029e4:	02d777bb          	remuw	a5,a4,a3
    800029e8:	02079793          	slli	a5,a5,0x20
    800029ec:	0207d793          	srli	a5,a5,0x20
    800029f0:	00fd87b3          	add	a5,s11,a5
    800029f4:	0007c503          	lbu	a0,0(a5)
    800029f8:	02d757bb          	divuw	a5,a4,a3
    800029fc:	f8a40123          	sb	a0,-126(s0)
    80002a00:	48e5f263          	bgeu	a1,a4,80002e84 <__printf+0x5fc>
    80002a04:	06300513          	li	a0,99
    80002a08:	02d7f5bb          	remuw	a1,a5,a3
    80002a0c:	02059593          	slli	a1,a1,0x20
    80002a10:	0205d593          	srli	a1,a1,0x20
    80002a14:	00bd85b3          	add	a1,s11,a1
    80002a18:	0005c583          	lbu	a1,0(a1)
    80002a1c:	02d7d7bb          	divuw	a5,a5,a3
    80002a20:	f8b401a3          	sb	a1,-125(s0)
    80002a24:	48e57263          	bgeu	a0,a4,80002ea8 <__printf+0x620>
    80002a28:	3e700513          	li	a0,999
    80002a2c:	02d7f5bb          	remuw	a1,a5,a3
    80002a30:	02059593          	slli	a1,a1,0x20
    80002a34:	0205d593          	srli	a1,a1,0x20
    80002a38:	00bd85b3          	add	a1,s11,a1
    80002a3c:	0005c583          	lbu	a1,0(a1)
    80002a40:	02d7d7bb          	divuw	a5,a5,a3
    80002a44:	f8b40223          	sb	a1,-124(s0)
    80002a48:	46e57663          	bgeu	a0,a4,80002eb4 <__printf+0x62c>
    80002a4c:	02d7f5bb          	remuw	a1,a5,a3
    80002a50:	02059593          	slli	a1,a1,0x20
    80002a54:	0205d593          	srli	a1,a1,0x20
    80002a58:	00bd85b3          	add	a1,s11,a1
    80002a5c:	0005c583          	lbu	a1,0(a1)
    80002a60:	02d7d7bb          	divuw	a5,a5,a3
    80002a64:	f8b402a3          	sb	a1,-123(s0)
    80002a68:	46ea7863          	bgeu	s4,a4,80002ed8 <__printf+0x650>
    80002a6c:	02d7f5bb          	remuw	a1,a5,a3
    80002a70:	02059593          	slli	a1,a1,0x20
    80002a74:	0205d593          	srli	a1,a1,0x20
    80002a78:	00bd85b3          	add	a1,s11,a1
    80002a7c:	0005c583          	lbu	a1,0(a1)
    80002a80:	02d7d7bb          	divuw	a5,a5,a3
    80002a84:	f8b40323          	sb	a1,-122(s0)
    80002a88:	3eeaf863          	bgeu	s5,a4,80002e78 <__printf+0x5f0>
    80002a8c:	02d7f5bb          	remuw	a1,a5,a3
    80002a90:	02059593          	slli	a1,a1,0x20
    80002a94:	0205d593          	srli	a1,a1,0x20
    80002a98:	00bd85b3          	add	a1,s11,a1
    80002a9c:	0005c583          	lbu	a1,0(a1)
    80002aa0:	02d7d7bb          	divuw	a5,a5,a3
    80002aa4:	f8b403a3          	sb	a1,-121(s0)
    80002aa8:	42eb7e63          	bgeu	s6,a4,80002ee4 <__printf+0x65c>
    80002aac:	02d7f5bb          	remuw	a1,a5,a3
    80002ab0:	02059593          	slli	a1,a1,0x20
    80002ab4:	0205d593          	srli	a1,a1,0x20
    80002ab8:	00bd85b3          	add	a1,s11,a1
    80002abc:	0005c583          	lbu	a1,0(a1)
    80002ac0:	02d7d7bb          	divuw	a5,a5,a3
    80002ac4:	f8b40423          	sb	a1,-120(s0)
    80002ac8:	42ebfc63          	bgeu	s7,a4,80002f00 <__printf+0x678>
    80002acc:	02079793          	slli	a5,a5,0x20
    80002ad0:	0207d793          	srli	a5,a5,0x20
    80002ad4:	00fd8db3          	add	s11,s11,a5
    80002ad8:	000dc703          	lbu	a4,0(s11)
    80002adc:	00a00793          	li	a5,10
    80002ae0:	00900c93          	li	s9,9
    80002ae4:	f8e404a3          	sb	a4,-119(s0)
    80002ae8:	00065c63          	bgez	a2,80002b00 <__printf+0x278>
    80002aec:	f9040713          	addi	a4,s0,-112
    80002af0:	00f70733          	add	a4,a4,a5
    80002af4:	02d00693          	li	a3,45
    80002af8:	fed70823          	sb	a3,-16(a4)
    80002afc:	00078c93          	mv	s9,a5
    80002b00:	f8040793          	addi	a5,s0,-128
    80002b04:	01978cb3          	add	s9,a5,s9
    80002b08:	f7f40d13          	addi	s10,s0,-129
    80002b0c:	000cc503          	lbu	a0,0(s9)
    80002b10:	fffc8c93          	addi	s9,s9,-1
    80002b14:	00000097          	auipc	ra,0x0
    80002b18:	b90080e7          	jalr	-1136(ra) # 800026a4 <consputc>
    80002b1c:	ffac98e3          	bne	s9,s10,80002b0c <__printf+0x284>
    80002b20:	00094503          	lbu	a0,0(s2)
    80002b24:	e00514e3          	bnez	a0,8000292c <__printf+0xa4>
    80002b28:	1a0c1663          	bnez	s8,80002cd4 <__printf+0x44c>
    80002b2c:	08813083          	ld	ra,136(sp)
    80002b30:	08013403          	ld	s0,128(sp)
    80002b34:	07813483          	ld	s1,120(sp)
    80002b38:	07013903          	ld	s2,112(sp)
    80002b3c:	06813983          	ld	s3,104(sp)
    80002b40:	06013a03          	ld	s4,96(sp)
    80002b44:	05813a83          	ld	s5,88(sp)
    80002b48:	05013b03          	ld	s6,80(sp)
    80002b4c:	04813b83          	ld	s7,72(sp)
    80002b50:	04013c03          	ld	s8,64(sp)
    80002b54:	03813c83          	ld	s9,56(sp)
    80002b58:	03013d03          	ld	s10,48(sp)
    80002b5c:	02813d83          	ld	s11,40(sp)
    80002b60:	0d010113          	addi	sp,sp,208
    80002b64:	00008067          	ret
    80002b68:	07300713          	li	a4,115
    80002b6c:	1ce78a63          	beq	a5,a4,80002d40 <__printf+0x4b8>
    80002b70:	07800713          	li	a4,120
    80002b74:	1ee79e63          	bne	a5,a4,80002d70 <__printf+0x4e8>
    80002b78:	f7843783          	ld	a5,-136(s0)
    80002b7c:	0007a703          	lw	a4,0(a5)
    80002b80:	00878793          	addi	a5,a5,8
    80002b84:	f6f43c23          	sd	a5,-136(s0)
    80002b88:	28074263          	bltz	a4,80002e0c <__printf+0x584>
    80002b8c:	00001d97          	auipc	s11,0x1
    80002b90:	784d8d93          	addi	s11,s11,1924 # 80004310 <digits>
    80002b94:	00f77793          	andi	a5,a4,15
    80002b98:	00fd87b3          	add	a5,s11,a5
    80002b9c:	0007c683          	lbu	a3,0(a5)
    80002ba0:	00f00613          	li	a2,15
    80002ba4:	0007079b          	sext.w	a5,a4
    80002ba8:	f8d40023          	sb	a3,-128(s0)
    80002bac:	0047559b          	srliw	a1,a4,0x4
    80002bb0:	0047569b          	srliw	a3,a4,0x4
    80002bb4:	00000c93          	li	s9,0
    80002bb8:	0ee65063          	bge	a2,a4,80002c98 <__printf+0x410>
    80002bbc:	00f6f693          	andi	a3,a3,15
    80002bc0:	00dd86b3          	add	a3,s11,a3
    80002bc4:	0006c683          	lbu	a3,0(a3) # 2004000 <_entry-0x7dffc000>
    80002bc8:	0087d79b          	srliw	a5,a5,0x8
    80002bcc:	00100c93          	li	s9,1
    80002bd0:	f8d400a3          	sb	a3,-127(s0)
    80002bd4:	0cb67263          	bgeu	a2,a1,80002c98 <__printf+0x410>
    80002bd8:	00f7f693          	andi	a3,a5,15
    80002bdc:	00dd86b3          	add	a3,s11,a3
    80002be0:	0006c583          	lbu	a1,0(a3)
    80002be4:	00f00613          	li	a2,15
    80002be8:	0047d69b          	srliw	a3,a5,0x4
    80002bec:	f8b40123          	sb	a1,-126(s0)
    80002bf0:	0047d593          	srli	a1,a5,0x4
    80002bf4:	28f67e63          	bgeu	a2,a5,80002e90 <__printf+0x608>
    80002bf8:	00f6f693          	andi	a3,a3,15
    80002bfc:	00dd86b3          	add	a3,s11,a3
    80002c00:	0006c503          	lbu	a0,0(a3)
    80002c04:	0087d813          	srli	a6,a5,0x8
    80002c08:	0087d69b          	srliw	a3,a5,0x8
    80002c0c:	f8a401a3          	sb	a0,-125(s0)
    80002c10:	28b67663          	bgeu	a2,a1,80002e9c <__printf+0x614>
    80002c14:	00f6f693          	andi	a3,a3,15
    80002c18:	00dd86b3          	add	a3,s11,a3
    80002c1c:	0006c583          	lbu	a1,0(a3)
    80002c20:	00c7d513          	srli	a0,a5,0xc
    80002c24:	00c7d69b          	srliw	a3,a5,0xc
    80002c28:	f8b40223          	sb	a1,-124(s0)
    80002c2c:	29067a63          	bgeu	a2,a6,80002ec0 <__printf+0x638>
    80002c30:	00f6f693          	andi	a3,a3,15
    80002c34:	00dd86b3          	add	a3,s11,a3
    80002c38:	0006c583          	lbu	a1,0(a3)
    80002c3c:	0107d813          	srli	a6,a5,0x10
    80002c40:	0107d69b          	srliw	a3,a5,0x10
    80002c44:	f8b402a3          	sb	a1,-123(s0)
    80002c48:	28a67263          	bgeu	a2,a0,80002ecc <__printf+0x644>
    80002c4c:	00f6f693          	andi	a3,a3,15
    80002c50:	00dd86b3          	add	a3,s11,a3
    80002c54:	0006c683          	lbu	a3,0(a3)
    80002c58:	0147d79b          	srliw	a5,a5,0x14
    80002c5c:	f8d40323          	sb	a3,-122(s0)
    80002c60:	21067663          	bgeu	a2,a6,80002e6c <__printf+0x5e4>
    80002c64:	02079793          	slli	a5,a5,0x20
    80002c68:	0207d793          	srli	a5,a5,0x20
    80002c6c:	00fd8db3          	add	s11,s11,a5
    80002c70:	000dc683          	lbu	a3,0(s11)
    80002c74:	00800793          	li	a5,8
    80002c78:	00700c93          	li	s9,7
    80002c7c:	f8d403a3          	sb	a3,-121(s0)
    80002c80:	00075c63          	bgez	a4,80002c98 <__printf+0x410>
    80002c84:	f9040713          	addi	a4,s0,-112
    80002c88:	00f70733          	add	a4,a4,a5
    80002c8c:	02d00693          	li	a3,45
    80002c90:	fed70823          	sb	a3,-16(a4)
    80002c94:	00078c93          	mv	s9,a5
    80002c98:	f8040793          	addi	a5,s0,-128
    80002c9c:	01978cb3          	add	s9,a5,s9
    80002ca0:	f7f40d13          	addi	s10,s0,-129
    80002ca4:	000cc503          	lbu	a0,0(s9)
    80002ca8:	fffc8c93          	addi	s9,s9,-1
    80002cac:	00000097          	auipc	ra,0x0
    80002cb0:	9f8080e7          	jalr	-1544(ra) # 800026a4 <consputc>
    80002cb4:	ff9d18e3          	bne	s10,s9,80002ca4 <__printf+0x41c>
    80002cb8:	0100006f          	j	80002cc8 <__printf+0x440>
    80002cbc:	00000097          	auipc	ra,0x0
    80002cc0:	9e8080e7          	jalr	-1560(ra) # 800026a4 <consputc>
    80002cc4:	000c8493          	mv	s1,s9
    80002cc8:	00094503          	lbu	a0,0(s2)
    80002ccc:	c60510e3          	bnez	a0,8000292c <__printf+0xa4>
    80002cd0:	e40c0ee3          	beqz	s8,80002b2c <__printf+0x2a4>
    80002cd4:	00003517          	auipc	a0,0x3
    80002cd8:	bec50513          	addi	a0,a0,-1044 # 800058c0 <pr>
    80002cdc:	00001097          	auipc	ra,0x1
    80002ce0:	94c080e7          	jalr	-1716(ra) # 80003628 <release>
    80002ce4:	e49ff06f          	j	80002b2c <__printf+0x2a4>
    80002ce8:	f7843783          	ld	a5,-136(s0)
    80002cec:	03000513          	li	a0,48
    80002cf0:	01000d13          	li	s10,16
    80002cf4:	00878713          	addi	a4,a5,8
    80002cf8:	0007bc83          	ld	s9,0(a5)
    80002cfc:	f6e43c23          	sd	a4,-136(s0)
    80002d00:	00000097          	auipc	ra,0x0
    80002d04:	9a4080e7          	jalr	-1628(ra) # 800026a4 <consputc>
    80002d08:	07800513          	li	a0,120
    80002d0c:	00000097          	auipc	ra,0x0
    80002d10:	998080e7          	jalr	-1640(ra) # 800026a4 <consputc>
    80002d14:	00001d97          	auipc	s11,0x1
    80002d18:	5fcd8d93          	addi	s11,s11,1532 # 80004310 <digits>
    80002d1c:	03ccd793          	srli	a5,s9,0x3c
    80002d20:	00fd87b3          	add	a5,s11,a5
    80002d24:	0007c503          	lbu	a0,0(a5)
    80002d28:	fffd0d1b          	addiw	s10,s10,-1
    80002d2c:	004c9c93          	slli	s9,s9,0x4
    80002d30:	00000097          	auipc	ra,0x0
    80002d34:	974080e7          	jalr	-1676(ra) # 800026a4 <consputc>
    80002d38:	fe0d12e3          	bnez	s10,80002d1c <__printf+0x494>
    80002d3c:	f8dff06f          	j	80002cc8 <__printf+0x440>
    80002d40:	f7843783          	ld	a5,-136(s0)
    80002d44:	0007bc83          	ld	s9,0(a5)
    80002d48:	00878793          	addi	a5,a5,8
    80002d4c:	f6f43c23          	sd	a5,-136(s0)
    80002d50:	000c9a63          	bnez	s9,80002d64 <__printf+0x4dc>
    80002d54:	1080006f          	j	80002e5c <__printf+0x5d4>
    80002d58:	001c8c93          	addi	s9,s9,1
    80002d5c:	00000097          	auipc	ra,0x0
    80002d60:	948080e7          	jalr	-1720(ra) # 800026a4 <consputc>
    80002d64:	000cc503          	lbu	a0,0(s9)
    80002d68:	fe0518e3          	bnez	a0,80002d58 <__printf+0x4d0>
    80002d6c:	f5dff06f          	j	80002cc8 <__printf+0x440>
    80002d70:	02500513          	li	a0,37
    80002d74:	00000097          	auipc	ra,0x0
    80002d78:	930080e7          	jalr	-1744(ra) # 800026a4 <consputc>
    80002d7c:	000c8513          	mv	a0,s9
    80002d80:	00000097          	auipc	ra,0x0
    80002d84:	924080e7          	jalr	-1756(ra) # 800026a4 <consputc>
    80002d88:	f41ff06f          	j	80002cc8 <__printf+0x440>
    80002d8c:	02500513          	li	a0,37
    80002d90:	00000097          	auipc	ra,0x0
    80002d94:	914080e7          	jalr	-1772(ra) # 800026a4 <consputc>
    80002d98:	f31ff06f          	j	80002cc8 <__printf+0x440>
    80002d9c:	00030513          	mv	a0,t1
    80002da0:	00000097          	auipc	ra,0x0
    80002da4:	7bc080e7          	jalr	1980(ra) # 8000355c <acquire>
    80002da8:	b4dff06f          	j	800028f4 <__printf+0x6c>
    80002dac:	40c0053b          	negw	a0,a2
    80002db0:	00a00713          	li	a4,10
    80002db4:	02e576bb          	remuw	a3,a0,a4
    80002db8:	00001d97          	auipc	s11,0x1
    80002dbc:	558d8d93          	addi	s11,s11,1368 # 80004310 <digits>
    80002dc0:	ff700593          	li	a1,-9
    80002dc4:	02069693          	slli	a3,a3,0x20
    80002dc8:	0206d693          	srli	a3,a3,0x20
    80002dcc:	00dd86b3          	add	a3,s11,a3
    80002dd0:	0006c683          	lbu	a3,0(a3)
    80002dd4:	02e557bb          	divuw	a5,a0,a4
    80002dd8:	f8d40023          	sb	a3,-128(s0)
    80002ddc:	10b65e63          	bge	a2,a1,80002ef8 <__printf+0x670>
    80002de0:	06300593          	li	a1,99
    80002de4:	02e7f6bb          	remuw	a3,a5,a4
    80002de8:	02069693          	slli	a3,a3,0x20
    80002dec:	0206d693          	srli	a3,a3,0x20
    80002df0:	00dd86b3          	add	a3,s11,a3
    80002df4:	0006c683          	lbu	a3,0(a3)
    80002df8:	02e7d73b          	divuw	a4,a5,a4
    80002dfc:	00200793          	li	a5,2
    80002e00:	f8d400a3          	sb	a3,-127(s0)
    80002e04:	bca5ece3          	bltu	a1,a0,800029dc <__printf+0x154>
    80002e08:	ce5ff06f          	j	80002aec <__printf+0x264>
    80002e0c:	40e007bb          	negw	a5,a4
    80002e10:	00001d97          	auipc	s11,0x1
    80002e14:	500d8d93          	addi	s11,s11,1280 # 80004310 <digits>
    80002e18:	00f7f693          	andi	a3,a5,15
    80002e1c:	00dd86b3          	add	a3,s11,a3
    80002e20:	0006c583          	lbu	a1,0(a3)
    80002e24:	ff100613          	li	a2,-15
    80002e28:	0047d69b          	srliw	a3,a5,0x4
    80002e2c:	f8b40023          	sb	a1,-128(s0)
    80002e30:	0047d59b          	srliw	a1,a5,0x4
    80002e34:	0ac75e63          	bge	a4,a2,80002ef0 <__printf+0x668>
    80002e38:	00f6f693          	andi	a3,a3,15
    80002e3c:	00dd86b3          	add	a3,s11,a3
    80002e40:	0006c603          	lbu	a2,0(a3)
    80002e44:	00f00693          	li	a3,15
    80002e48:	0087d79b          	srliw	a5,a5,0x8
    80002e4c:	f8c400a3          	sb	a2,-127(s0)
    80002e50:	d8b6e4e3          	bltu	a3,a1,80002bd8 <__printf+0x350>
    80002e54:	00200793          	li	a5,2
    80002e58:	e2dff06f          	j	80002c84 <__printf+0x3fc>
    80002e5c:	00001c97          	auipc	s9,0x1
    80002e60:	494c8c93          	addi	s9,s9,1172 # 800042f0 <CONSOLE_STATUS+0x2e0>
    80002e64:	02800513          	li	a0,40
    80002e68:	ef1ff06f          	j	80002d58 <__printf+0x4d0>
    80002e6c:	00700793          	li	a5,7
    80002e70:	00600c93          	li	s9,6
    80002e74:	e0dff06f          	j	80002c80 <__printf+0x3f8>
    80002e78:	00700793          	li	a5,7
    80002e7c:	00600c93          	li	s9,6
    80002e80:	c69ff06f          	j	80002ae8 <__printf+0x260>
    80002e84:	00300793          	li	a5,3
    80002e88:	00200c93          	li	s9,2
    80002e8c:	c5dff06f          	j	80002ae8 <__printf+0x260>
    80002e90:	00300793          	li	a5,3
    80002e94:	00200c93          	li	s9,2
    80002e98:	de9ff06f          	j	80002c80 <__printf+0x3f8>
    80002e9c:	00400793          	li	a5,4
    80002ea0:	00300c93          	li	s9,3
    80002ea4:	dddff06f          	j	80002c80 <__printf+0x3f8>
    80002ea8:	00400793          	li	a5,4
    80002eac:	00300c93          	li	s9,3
    80002eb0:	c39ff06f          	j	80002ae8 <__printf+0x260>
    80002eb4:	00500793          	li	a5,5
    80002eb8:	00400c93          	li	s9,4
    80002ebc:	c2dff06f          	j	80002ae8 <__printf+0x260>
    80002ec0:	00500793          	li	a5,5
    80002ec4:	00400c93          	li	s9,4
    80002ec8:	db9ff06f          	j	80002c80 <__printf+0x3f8>
    80002ecc:	00600793          	li	a5,6
    80002ed0:	00500c93          	li	s9,5
    80002ed4:	dadff06f          	j	80002c80 <__printf+0x3f8>
    80002ed8:	00600793          	li	a5,6
    80002edc:	00500c93          	li	s9,5
    80002ee0:	c09ff06f          	j	80002ae8 <__printf+0x260>
    80002ee4:	00800793          	li	a5,8
    80002ee8:	00700c93          	li	s9,7
    80002eec:	bfdff06f          	j	80002ae8 <__printf+0x260>
    80002ef0:	00100793          	li	a5,1
    80002ef4:	d91ff06f          	j	80002c84 <__printf+0x3fc>
    80002ef8:	00100793          	li	a5,1
    80002efc:	bf1ff06f          	j	80002aec <__printf+0x264>
    80002f00:	00900793          	li	a5,9
    80002f04:	00800c93          	li	s9,8
    80002f08:	be1ff06f          	j	80002ae8 <__printf+0x260>
    80002f0c:	00001517          	auipc	a0,0x1
    80002f10:	3ec50513          	addi	a0,a0,1004 # 800042f8 <CONSOLE_STATUS+0x2e8>
    80002f14:	00000097          	auipc	ra,0x0
    80002f18:	918080e7          	jalr	-1768(ra) # 8000282c <panic>

0000000080002f1c <printfinit>:
    80002f1c:	fe010113          	addi	sp,sp,-32
    80002f20:	00813823          	sd	s0,16(sp)
    80002f24:	00913423          	sd	s1,8(sp)
    80002f28:	00113c23          	sd	ra,24(sp)
    80002f2c:	02010413          	addi	s0,sp,32
    80002f30:	00003497          	auipc	s1,0x3
    80002f34:	99048493          	addi	s1,s1,-1648 # 800058c0 <pr>
    80002f38:	00048513          	mv	a0,s1
    80002f3c:	00001597          	auipc	a1,0x1
    80002f40:	3cc58593          	addi	a1,a1,972 # 80004308 <CONSOLE_STATUS+0x2f8>
    80002f44:	00000097          	auipc	ra,0x0
    80002f48:	5f4080e7          	jalr	1524(ra) # 80003538 <initlock>
    80002f4c:	01813083          	ld	ra,24(sp)
    80002f50:	01013403          	ld	s0,16(sp)
    80002f54:	0004ac23          	sw	zero,24(s1)
    80002f58:	00813483          	ld	s1,8(sp)
    80002f5c:	02010113          	addi	sp,sp,32
    80002f60:	00008067          	ret

0000000080002f64 <uartinit>:
    80002f64:	ff010113          	addi	sp,sp,-16
    80002f68:	00813423          	sd	s0,8(sp)
    80002f6c:	01010413          	addi	s0,sp,16
    80002f70:	100007b7          	lui	a5,0x10000
    80002f74:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>
    80002f78:	f8000713          	li	a4,-128
    80002f7c:	00e781a3          	sb	a4,3(a5)
    80002f80:	00300713          	li	a4,3
    80002f84:	00e78023          	sb	a4,0(a5)
    80002f88:	000780a3          	sb	zero,1(a5)
    80002f8c:	00e781a3          	sb	a4,3(a5)
    80002f90:	00700693          	li	a3,7
    80002f94:	00d78123          	sb	a3,2(a5)
    80002f98:	00e780a3          	sb	a4,1(a5)
    80002f9c:	00813403          	ld	s0,8(sp)
    80002fa0:	01010113          	addi	sp,sp,16
    80002fa4:	00008067          	ret

0000000080002fa8 <uartputc>:
    80002fa8:	00001797          	auipc	a5,0x1
    80002fac:	6b07a783          	lw	a5,1712(a5) # 80004658 <panicked>
    80002fb0:	00078463          	beqz	a5,80002fb8 <uartputc+0x10>
    80002fb4:	0000006f          	j	80002fb4 <uartputc+0xc>
    80002fb8:	fd010113          	addi	sp,sp,-48
    80002fbc:	02813023          	sd	s0,32(sp)
    80002fc0:	00913c23          	sd	s1,24(sp)
    80002fc4:	01213823          	sd	s2,16(sp)
    80002fc8:	01313423          	sd	s3,8(sp)
    80002fcc:	02113423          	sd	ra,40(sp)
    80002fd0:	03010413          	addi	s0,sp,48
    80002fd4:	00001917          	auipc	s2,0x1
    80002fd8:	68c90913          	addi	s2,s2,1676 # 80004660 <uart_tx_r>
    80002fdc:	00093783          	ld	a5,0(s2)
    80002fe0:	00001497          	auipc	s1,0x1
    80002fe4:	68848493          	addi	s1,s1,1672 # 80004668 <uart_tx_w>
    80002fe8:	0004b703          	ld	a4,0(s1)
    80002fec:	02078693          	addi	a3,a5,32
    80002ff0:	00050993          	mv	s3,a0
    80002ff4:	02e69c63          	bne	a3,a4,8000302c <uartputc+0x84>
    80002ff8:	00001097          	auipc	ra,0x1
    80002ffc:	834080e7          	jalr	-1996(ra) # 8000382c <push_on>
    80003000:	00093783          	ld	a5,0(s2)
    80003004:	0004b703          	ld	a4,0(s1)
    80003008:	02078793          	addi	a5,a5,32
    8000300c:	00e79463          	bne	a5,a4,80003014 <uartputc+0x6c>
    80003010:	0000006f          	j	80003010 <uartputc+0x68>
    80003014:	00001097          	auipc	ra,0x1
    80003018:	88c080e7          	jalr	-1908(ra) # 800038a0 <pop_on>
    8000301c:	00093783          	ld	a5,0(s2)
    80003020:	0004b703          	ld	a4,0(s1)
    80003024:	02078693          	addi	a3,a5,32
    80003028:	fce688e3          	beq	a3,a4,80002ff8 <uartputc+0x50>
    8000302c:	01f77693          	andi	a3,a4,31
    80003030:	00003597          	auipc	a1,0x3
    80003034:	8b058593          	addi	a1,a1,-1872 # 800058e0 <uart_tx_buf>
    80003038:	00d586b3          	add	a3,a1,a3
    8000303c:	00170713          	addi	a4,a4,1
    80003040:	01368023          	sb	s3,0(a3)
    80003044:	00e4b023          	sd	a4,0(s1)
    80003048:	10000637          	lui	a2,0x10000
    8000304c:	02f71063          	bne	a4,a5,8000306c <uartputc+0xc4>
    80003050:	0340006f          	j	80003084 <uartputc+0xdc>
    80003054:	00074703          	lbu	a4,0(a4)
    80003058:	00f93023          	sd	a5,0(s2)
    8000305c:	00e60023          	sb	a4,0(a2) # 10000000 <_entry-0x70000000>
    80003060:	00093783          	ld	a5,0(s2)
    80003064:	0004b703          	ld	a4,0(s1)
    80003068:	00f70e63          	beq	a4,a5,80003084 <uartputc+0xdc>
    8000306c:	00564683          	lbu	a3,5(a2)
    80003070:	01f7f713          	andi	a4,a5,31
    80003074:	00e58733          	add	a4,a1,a4
    80003078:	0206f693          	andi	a3,a3,32
    8000307c:	00178793          	addi	a5,a5,1
    80003080:	fc069ae3          	bnez	a3,80003054 <uartputc+0xac>
    80003084:	02813083          	ld	ra,40(sp)
    80003088:	02013403          	ld	s0,32(sp)
    8000308c:	01813483          	ld	s1,24(sp)
    80003090:	01013903          	ld	s2,16(sp)
    80003094:	00813983          	ld	s3,8(sp)
    80003098:	03010113          	addi	sp,sp,48
    8000309c:	00008067          	ret

00000000800030a0 <uartputc_sync>:
    800030a0:	ff010113          	addi	sp,sp,-16
    800030a4:	00813423          	sd	s0,8(sp)
    800030a8:	01010413          	addi	s0,sp,16
    800030ac:	00001717          	auipc	a4,0x1
    800030b0:	5ac72703          	lw	a4,1452(a4) # 80004658 <panicked>
    800030b4:	02071663          	bnez	a4,800030e0 <uartputc_sync+0x40>
    800030b8:	00050793          	mv	a5,a0
    800030bc:	100006b7          	lui	a3,0x10000
    800030c0:	0056c703          	lbu	a4,5(a3) # 10000005 <_entry-0x6ffffffb>
    800030c4:	02077713          	andi	a4,a4,32
    800030c8:	fe070ce3          	beqz	a4,800030c0 <uartputc_sync+0x20>
    800030cc:	0ff7f793          	andi	a5,a5,255
    800030d0:	00f68023          	sb	a5,0(a3)
    800030d4:	00813403          	ld	s0,8(sp)
    800030d8:	01010113          	addi	sp,sp,16
    800030dc:	00008067          	ret
    800030e0:	0000006f          	j	800030e0 <uartputc_sync+0x40>

00000000800030e4 <uartstart>:
    800030e4:	ff010113          	addi	sp,sp,-16
    800030e8:	00813423          	sd	s0,8(sp)
    800030ec:	01010413          	addi	s0,sp,16
    800030f0:	00001617          	auipc	a2,0x1
    800030f4:	57060613          	addi	a2,a2,1392 # 80004660 <uart_tx_r>
    800030f8:	00001517          	auipc	a0,0x1
    800030fc:	57050513          	addi	a0,a0,1392 # 80004668 <uart_tx_w>
    80003100:	00063783          	ld	a5,0(a2)
    80003104:	00053703          	ld	a4,0(a0)
    80003108:	04f70263          	beq	a4,a5,8000314c <uartstart+0x68>
    8000310c:	100005b7          	lui	a1,0x10000
    80003110:	00002817          	auipc	a6,0x2
    80003114:	7d080813          	addi	a6,a6,2000 # 800058e0 <uart_tx_buf>
    80003118:	01c0006f          	j	80003134 <uartstart+0x50>
    8000311c:	0006c703          	lbu	a4,0(a3)
    80003120:	00f63023          	sd	a5,0(a2)
    80003124:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    80003128:	00063783          	ld	a5,0(a2)
    8000312c:	00053703          	ld	a4,0(a0)
    80003130:	00f70e63          	beq	a4,a5,8000314c <uartstart+0x68>
    80003134:	01f7f713          	andi	a4,a5,31
    80003138:	00e806b3          	add	a3,a6,a4
    8000313c:	0055c703          	lbu	a4,5(a1)
    80003140:	00178793          	addi	a5,a5,1
    80003144:	02077713          	andi	a4,a4,32
    80003148:	fc071ae3          	bnez	a4,8000311c <uartstart+0x38>
    8000314c:	00813403          	ld	s0,8(sp)
    80003150:	01010113          	addi	sp,sp,16
    80003154:	00008067          	ret

0000000080003158 <uartgetc>:
    80003158:	ff010113          	addi	sp,sp,-16
    8000315c:	00813423          	sd	s0,8(sp)
    80003160:	01010413          	addi	s0,sp,16
    80003164:	10000737          	lui	a4,0x10000
    80003168:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000316c:	0017f793          	andi	a5,a5,1
    80003170:	00078c63          	beqz	a5,80003188 <uartgetc+0x30>
    80003174:	00074503          	lbu	a0,0(a4)
    80003178:	0ff57513          	andi	a0,a0,255
    8000317c:	00813403          	ld	s0,8(sp)
    80003180:	01010113          	addi	sp,sp,16
    80003184:	00008067          	ret
    80003188:	fff00513          	li	a0,-1
    8000318c:	ff1ff06f          	j	8000317c <uartgetc+0x24>

0000000080003190 <uartintr>:
    80003190:	100007b7          	lui	a5,0x10000
    80003194:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80003198:	0017f793          	andi	a5,a5,1
    8000319c:	0a078463          	beqz	a5,80003244 <uartintr+0xb4>
    800031a0:	fe010113          	addi	sp,sp,-32
    800031a4:	00813823          	sd	s0,16(sp)
    800031a8:	00913423          	sd	s1,8(sp)
    800031ac:	00113c23          	sd	ra,24(sp)
    800031b0:	02010413          	addi	s0,sp,32
    800031b4:	100004b7          	lui	s1,0x10000
    800031b8:	0004c503          	lbu	a0,0(s1) # 10000000 <_entry-0x70000000>
    800031bc:	0ff57513          	andi	a0,a0,255
    800031c0:	fffff097          	auipc	ra,0xfffff
    800031c4:	534080e7          	jalr	1332(ra) # 800026f4 <consoleintr>
    800031c8:	0054c783          	lbu	a5,5(s1)
    800031cc:	0017f793          	andi	a5,a5,1
    800031d0:	fe0794e3          	bnez	a5,800031b8 <uartintr+0x28>
    800031d4:	00001617          	auipc	a2,0x1
    800031d8:	48c60613          	addi	a2,a2,1164 # 80004660 <uart_tx_r>
    800031dc:	00001517          	auipc	a0,0x1
    800031e0:	48c50513          	addi	a0,a0,1164 # 80004668 <uart_tx_w>
    800031e4:	00063783          	ld	a5,0(a2)
    800031e8:	00053703          	ld	a4,0(a0)
    800031ec:	04f70263          	beq	a4,a5,80003230 <uartintr+0xa0>
    800031f0:	100005b7          	lui	a1,0x10000
    800031f4:	00002817          	auipc	a6,0x2
    800031f8:	6ec80813          	addi	a6,a6,1772 # 800058e0 <uart_tx_buf>
    800031fc:	01c0006f          	j	80003218 <uartintr+0x88>
    80003200:	0006c703          	lbu	a4,0(a3)
    80003204:	00f63023          	sd	a5,0(a2)
    80003208:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    8000320c:	00063783          	ld	a5,0(a2)
    80003210:	00053703          	ld	a4,0(a0)
    80003214:	00f70e63          	beq	a4,a5,80003230 <uartintr+0xa0>
    80003218:	01f7f713          	andi	a4,a5,31
    8000321c:	00e806b3          	add	a3,a6,a4
    80003220:	0055c703          	lbu	a4,5(a1)
    80003224:	00178793          	addi	a5,a5,1
    80003228:	02077713          	andi	a4,a4,32
    8000322c:	fc071ae3          	bnez	a4,80003200 <uartintr+0x70>
    80003230:	01813083          	ld	ra,24(sp)
    80003234:	01013403          	ld	s0,16(sp)
    80003238:	00813483          	ld	s1,8(sp)
    8000323c:	02010113          	addi	sp,sp,32
    80003240:	00008067          	ret
    80003244:	00001617          	auipc	a2,0x1
    80003248:	41c60613          	addi	a2,a2,1052 # 80004660 <uart_tx_r>
    8000324c:	00001517          	auipc	a0,0x1
    80003250:	41c50513          	addi	a0,a0,1052 # 80004668 <uart_tx_w>
    80003254:	00063783          	ld	a5,0(a2)
    80003258:	00053703          	ld	a4,0(a0)
    8000325c:	04f70263          	beq	a4,a5,800032a0 <uartintr+0x110>
    80003260:	100005b7          	lui	a1,0x10000
    80003264:	00002817          	auipc	a6,0x2
    80003268:	67c80813          	addi	a6,a6,1660 # 800058e0 <uart_tx_buf>
    8000326c:	01c0006f          	j	80003288 <uartintr+0xf8>
    80003270:	0006c703          	lbu	a4,0(a3)
    80003274:	00f63023          	sd	a5,0(a2)
    80003278:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    8000327c:	00063783          	ld	a5,0(a2)
    80003280:	00053703          	ld	a4,0(a0)
    80003284:	02f70063          	beq	a4,a5,800032a4 <uartintr+0x114>
    80003288:	01f7f713          	andi	a4,a5,31
    8000328c:	00e806b3          	add	a3,a6,a4
    80003290:	0055c703          	lbu	a4,5(a1)
    80003294:	00178793          	addi	a5,a5,1
    80003298:	02077713          	andi	a4,a4,32
    8000329c:	fc071ae3          	bnez	a4,80003270 <uartintr+0xe0>
    800032a0:	00008067          	ret
    800032a4:	00008067          	ret

00000000800032a8 <kinit>:
    800032a8:	fc010113          	addi	sp,sp,-64
    800032ac:	02913423          	sd	s1,40(sp)
    800032b0:	fffff7b7          	lui	a5,0xfffff
    800032b4:	00003497          	auipc	s1,0x3
    800032b8:	64b48493          	addi	s1,s1,1611 # 800068ff <end+0xfff>
    800032bc:	02813823          	sd	s0,48(sp)
    800032c0:	01313c23          	sd	s3,24(sp)
    800032c4:	00f4f4b3          	and	s1,s1,a5
    800032c8:	02113c23          	sd	ra,56(sp)
    800032cc:	03213023          	sd	s2,32(sp)
    800032d0:	01413823          	sd	s4,16(sp)
    800032d4:	01513423          	sd	s5,8(sp)
    800032d8:	04010413          	addi	s0,sp,64
    800032dc:	000017b7          	lui	a5,0x1
    800032e0:	01100993          	li	s3,17
    800032e4:	00f487b3          	add	a5,s1,a5
    800032e8:	01b99993          	slli	s3,s3,0x1b
    800032ec:	06f9e063          	bltu	s3,a5,8000334c <kinit+0xa4>
    800032f0:	00002a97          	auipc	s5,0x2
    800032f4:	610a8a93          	addi	s5,s5,1552 # 80005900 <end>
    800032f8:	0754ec63          	bltu	s1,s5,80003370 <kinit+0xc8>
    800032fc:	0734fa63          	bgeu	s1,s3,80003370 <kinit+0xc8>
    80003300:	00088a37          	lui	s4,0x88
    80003304:	fffa0a13          	addi	s4,s4,-1 # 87fff <_entry-0x7ff78001>
    80003308:	00001917          	auipc	s2,0x1
    8000330c:	36890913          	addi	s2,s2,872 # 80004670 <kmem>
    80003310:	00ca1a13          	slli	s4,s4,0xc
    80003314:	0140006f          	j	80003328 <kinit+0x80>
    80003318:	000017b7          	lui	a5,0x1
    8000331c:	00f484b3          	add	s1,s1,a5
    80003320:	0554e863          	bltu	s1,s5,80003370 <kinit+0xc8>
    80003324:	0534f663          	bgeu	s1,s3,80003370 <kinit+0xc8>
    80003328:	00001637          	lui	a2,0x1
    8000332c:	00100593          	li	a1,1
    80003330:	00048513          	mv	a0,s1
    80003334:	00000097          	auipc	ra,0x0
    80003338:	5e4080e7          	jalr	1508(ra) # 80003918 <__memset>
    8000333c:	00093783          	ld	a5,0(s2)
    80003340:	00f4b023          	sd	a5,0(s1)
    80003344:	00993023          	sd	s1,0(s2)
    80003348:	fd4498e3          	bne	s1,s4,80003318 <kinit+0x70>
    8000334c:	03813083          	ld	ra,56(sp)
    80003350:	03013403          	ld	s0,48(sp)
    80003354:	02813483          	ld	s1,40(sp)
    80003358:	02013903          	ld	s2,32(sp)
    8000335c:	01813983          	ld	s3,24(sp)
    80003360:	01013a03          	ld	s4,16(sp)
    80003364:	00813a83          	ld	s5,8(sp)
    80003368:	04010113          	addi	sp,sp,64
    8000336c:	00008067          	ret
    80003370:	00001517          	auipc	a0,0x1
    80003374:	fb850513          	addi	a0,a0,-72 # 80004328 <digits+0x18>
    80003378:	fffff097          	auipc	ra,0xfffff
    8000337c:	4b4080e7          	jalr	1204(ra) # 8000282c <panic>

0000000080003380 <freerange>:
    80003380:	fc010113          	addi	sp,sp,-64
    80003384:	000017b7          	lui	a5,0x1
    80003388:	02913423          	sd	s1,40(sp)
    8000338c:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80003390:	009504b3          	add	s1,a0,s1
    80003394:	fffff537          	lui	a0,0xfffff
    80003398:	02813823          	sd	s0,48(sp)
    8000339c:	02113c23          	sd	ra,56(sp)
    800033a0:	03213023          	sd	s2,32(sp)
    800033a4:	01313c23          	sd	s3,24(sp)
    800033a8:	01413823          	sd	s4,16(sp)
    800033ac:	01513423          	sd	s5,8(sp)
    800033b0:	01613023          	sd	s6,0(sp)
    800033b4:	04010413          	addi	s0,sp,64
    800033b8:	00a4f4b3          	and	s1,s1,a0
    800033bc:	00f487b3          	add	a5,s1,a5
    800033c0:	06f5e463          	bltu	a1,a5,80003428 <freerange+0xa8>
    800033c4:	00002a97          	auipc	s5,0x2
    800033c8:	53ca8a93          	addi	s5,s5,1340 # 80005900 <end>
    800033cc:	0954e263          	bltu	s1,s5,80003450 <freerange+0xd0>
    800033d0:	01100993          	li	s3,17
    800033d4:	01b99993          	slli	s3,s3,0x1b
    800033d8:	0734fc63          	bgeu	s1,s3,80003450 <freerange+0xd0>
    800033dc:	00058a13          	mv	s4,a1
    800033e0:	00001917          	auipc	s2,0x1
    800033e4:	29090913          	addi	s2,s2,656 # 80004670 <kmem>
    800033e8:	00002b37          	lui	s6,0x2
    800033ec:	0140006f          	j	80003400 <freerange+0x80>
    800033f0:	000017b7          	lui	a5,0x1
    800033f4:	00f484b3          	add	s1,s1,a5
    800033f8:	0554ec63          	bltu	s1,s5,80003450 <freerange+0xd0>
    800033fc:	0534fa63          	bgeu	s1,s3,80003450 <freerange+0xd0>
    80003400:	00001637          	lui	a2,0x1
    80003404:	00100593          	li	a1,1
    80003408:	00048513          	mv	a0,s1
    8000340c:	00000097          	auipc	ra,0x0
    80003410:	50c080e7          	jalr	1292(ra) # 80003918 <__memset>
    80003414:	00093703          	ld	a4,0(s2)
    80003418:	016487b3          	add	a5,s1,s6
    8000341c:	00e4b023          	sd	a4,0(s1)
    80003420:	00993023          	sd	s1,0(s2)
    80003424:	fcfa76e3          	bgeu	s4,a5,800033f0 <freerange+0x70>
    80003428:	03813083          	ld	ra,56(sp)
    8000342c:	03013403          	ld	s0,48(sp)
    80003430:	02813483          	ld	s1,40(sp)
    80003434:	02013903          	ld	s2,32(sp)
    80003438:	01813983          	ld	s3,24(sp)
    8000343c:	01013a03          	ld	s4,16(sp)
    80003440:	00813a83          	ld	s5,8(sp)
    80003444:	00013b03          	ld	s6,0(sp)
    80003448:	04010113          	addi	sp,sp,64
    8000344c:	00008067          	ret
    80003450:	00001517          	auipc	a0,0x1
    80003454:	ed850513          	addi	a0,a0,-296 # 80004328 <digits+0x18>
    80003458:	fffff097          	auipc	ra,0xfffff
    8000345c:	3d4080e7          	jalr	980(ra) # 8000282c <panic>

0000000080003460 <kfree>:
    80003460:	fe010113          	addi	sp,sp,-32
    80003464:	00813823          	sd	s0,16(sp)
    80003468:	00113c23          	sd	ra,24(sp)
    8000346c:	00913423          	sd	s1,8(sp)
    80003470:	02010413          	addi	s0,sp,32
    80003474:	03451793          	slli	a5,a0,0x34
    80003478:	04079c63          	bnez	a5,800034d0 <kfree+0x70>
    8000347c:	00002797          	auipc	a5,0x2
    80003480:	48478793          	addi	a5,a5,1156 # 80005900 <end>
    80003484:	00050493          	mv	s1,a0
    80003488:	04f56463          	bltu	a0,a5,800034d0 <kfree+0x70>
    8000348c:	01100793          	li	a5,17
    80003490:	01b79793          	slli	a5,a5,0x1b
    80003494:	02f57e63          	bgeu	a0,a5,800034d0 <kfree+0x70>
    80003498:	00001637          	lui	a2,0x1
    8000349c:	00100593          	li	a1,1
    800034a0:	00000097          	auipc	ra,0x0
    800034a4:	478080e7          	jalr	1144(ra) # 80003918 <__memset>
    800034a8:	00001797          	auipc	a5,0x1
    800034ac:	1c878793          	addi	a5,a5,456 # 80004670 <kmem>
    800034b0:	0007b703          	ld	a4,0(a5)
    800034b4:	01813083          	ld	ra,24(sp)
    800034b8:	01013403          	ld	s0,16(sp)
    800034bc:	00e4b023          	sd	a4,0(s1)
    800034c0:	0097b023          	sd	s1,0(a5)
    800034c4:	00813483          	ld	s1,8(sp)
    800034c8:	02010113          	addi	sp,sp,32
    800034cc:	00008067          	ret
    800034d0:	00001517          	auipc	a0,0x1
    800034d4:	e5850513          	addi	a0,a0,-424 # 80004328 <digits+0x18>
    800034d8:	fffff097          	auipc	ra,0xfffff
    800034dc:	354080e7          	jalr	852(ra) # 8000282c <panic>

00000000800034e0 <kalloc>:
    800034e0:	fe010113          	addi	sp,sp,-32
    800034e4:	00813823          	sd	s0,16(sp)
    800034e8:	00913423          	sd	s1,8(sp)
    800034ec:	00113c23          	sd	ra,24(sp)
    800034f0:	02010413          	addi	s0,sp,32
    800034f4:	00001797          	auipc	a5,0x1
    800034f8:	17c78793          	addi	a5,a5,380 # 80004670 <kmem>
    800034fc:	0007b483          	ld	s1,0(a5)
    80003500:	02048063          	beqz	s1,80003520 <kalloc+0x40>
    80003504:	0004b703          	ld	a4,0(s1)
    80003508:	00001637          	lui	a2,0x1
    8000350c:	00500593          	li	a1,5
    80003510:	00048513          	mv	a0,s1
    80003514:	00e7b023          	sd	a4,0(a5)
    80003518:	00000097          	auipc	ra,0x0
    8000351c:	400080e7          	jalr	1024(ra) # 80003918 <__memset>
    80003520:	01813083          	ld	ra,24(sp)
    80003524:	01013403          	ld	s0,16(sp)
    80003528:	00048513          	mv	a0,s1
    8000352c:	00813483          	ld	s1,8(sp)
    80003530:	02010113          	addi	sp,sp,32
    80003534:	00008067          	ret

0000000080003538 <initlock>:
    80003538:	ff010113          	addi	sp,sp,-16
    8000353c:	00813423          	sd	s0,8(sp)
    80003540:	01010413          	addi	s0,sp,16
    80003544:	00813403          	ld	s0,8(sp)
    80003548:	00b53423          	sd	a1,8(a0)
    8000354c:	00052023          	sw	zero,0(a0)
    80003550:	00053823          	sd	zero,16(a0)
    80003554:	01010113          	addi	sp,sp,16
    80003558:	00008067          	ret

000000008000355c <acquire>:
    8000355c:	fe010113          	addi	sp,sp,-32
    80003560:	00813823          	sd	s0,16(sp)
    80003564:	00913423          	sd	s1,8(sp)
    80003568:	00113c23          	sd	ra,24(sp)
    8000356c:	01213023          	sd	s2,0(sp)
    80003570:	02010413          	addi	s0,sp,32
    80003574:	00050493          	mv	s1,a0
    80003578:	10002973          	csrr	s2,sstatus
    8000357c:	100027f3          	csrr	a5,sstatus
    80003580:	ffd7f793          	andi	a5,a5,-3
    80003584:	10079073          	csrw	sstatus,a5
    80003588:	fffff097          	auipc	ra,0xfffff
    8000358c:	8e8080e7          	jalr	-1816(ra) # 80001e70 <mycpu>
    80003590:	07852783          	lw	a5,120(a0)
    80003594:	06078e63          	beqz	a5,80003610 <acquire+0xb4>
    80003598:	fffff097          	auipc	ra,0xfffff
    8000359c:	8d8080e7          	jalr	-1832(ra) # 80001e70 <mycpu>
    800035a0:	07852783          	lw	a5,120(a0)
    800035a4:	0004a703          	lw	a4,0(s1)
    800035a8:	0017879b          	addiw	a5,a5,1
    800035ac:	06f52c23          	sw	a5,120(a0)
    800035b0:	04071063          	bnez	a4,800035f0 <acquire+0x94>
    800035b4:	00100713          	li	a4,1
    800035b8:	00070793          	mv	a5,a4
    800035bc:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800035c0:	0007879b          	sext.w	a5,a5
    800035c4:	fe079ae3          	bnez	a5,800035b8 <acquire+0x5c>
    800035c8:	0ff0000f          	fence
    800035cc:	fffff097          	auipc	ra,0xfffff
    800035d0:	8a4080e7          	jalr	-1884(ra) # 80001e70 <mycpu>
    800035d4:	01813083          	ld	ra,24(sp)
    800035d8:	01013403          	ld	s0,16(sp)
    800035dc:	00a4b823          	sd	a0,16(s1)
    800035e0:	00013903          	ld	s2,0(sp)
    800035e4:	00813483          	ld	s1,8(sp)
    800035e8:	02010113          	addi	sp,sp,32
    800035ec:	00008067          	ret
    800035f0:	0104b903          	ld	s2,16(s1)
    800035f4:	fffff097          	auipc	ra,0xfffff
    800035f8:	87c080e7          	jalr	-1924(ra) # 80001e70 <mycpu>
    800035fc:	faa91ce3          	bne	s2,a0,800035b4 <acquire+0x58>
    80003600:	00001517          	auipc	a0,0x1
    80003604:	d3050513          	addi	a0,a0,-720 # 80004330 <digits+0x20>
    80003608:	fffff097          	auipc	ra,0xfffff
    8000360c:	224080e7          	jalr	548(ra) # 8000282c <panic>
    80003610:	00195913          	srli	s2,s2,0x1
    80003614:	fffff097          	auipc	ra,0xfffff
    80003618:	85c080e7          	jalr	-1956(ra) # 80001e70 <mycpu>
    8000361c:	00197913          	andi	s2,s2,1
    80003620:	07252e23          	sw	s2,124(a0)
    80003624:	f75ff06f          	j	80003598 <acquire+0x3c>

0000000080003628 <release>:
    80003628:	fe010113          	addi	sp,sp,-32
    8000362c:	00813823          	sd	s0,16(sp)
    80003630:	00113c23          	sd	ra,24(sp)
    80003634:	00913423          	sd	s1,8(sp)
    80003638:	01213023          	sd	s2,0(sp)
    8000363c:	02010413          	addi	s0,sp,32
    80003640:	00052783          	lw	a5,0(a0)
    80003644:	00079a63          	bnez	a5,80003658 <release+0x30>
    80003648:	00001517          	auipc	a0,0x1
    8000364c:	cf050513          	addi	a0,a0,-784 # 80004338 <digits+0x28>
    80003650:	fffff097          	auipc	ra,0xfffff
    80003654:	1dc080e7          	jalr	476(ra) # 8000282c <panic>
    80003658:	01053903          	ld	s2,16(a0)
    8000365c:	00050493          	mv	s1,a0
    80003660:	fffff097          	auipc	ra,0xfffff
    80003664:	810080e7          	jalr	-2032(ra) # 80001e70 <mycpu>
    80003668:	fea910e3          	bne	s2,a0,80003648 <release+0x20>
    8000366c:	0004b823          	sd	zero,16(s1)
    80003670:	0ff0000f          	fence
    80003674:	0f50000f          	fence	iorw,ow
    80003678:	0804a02f          	amoswap.w	zero,zero,(s1)
    8000367c:	ffffe097          	auipc	ra,0xffffe
    80003680:	7f4080e7          	jalr	2036(ra) # 80001e70 <mycpu>
    80003684:	100027f3          	csrr	a5,sstatus
    80003688:	0027f793          	andi	a5,a5,2
    8000368c:	04079a63          	bnez	a5,800036e0 <release+0xb8>
    80003690:	07852783          	lw	a5,120(a0)
    80003694:	02f05e63          	blez	a5,800036d0 <release+0xa8>
    80003698:	fff7871b          	addiw	a4,a5,-1
    8000369c:	06e52c23          	sw	a4,120(a0)
    800036a0:	00071c63          	bnez	a4,800036b8 <release+0x90>
    800036a4:	07c52783          	lw	a5,124(a0)
    800036a8:	00078863          	beqz	a5,800036b8 <release+0x90>
    800036ac:	100027f3          	csrr	a5,sstatus
    800036b0:	0027e793          	ori	a5,a5,2
    800036b4:	10079073          	csrw	sstatus,a5
    800036b8:	01813083          	ld	ra,24(sp)
    800036bc:	01013403          	ld	s0,16(sp)
    800036c0:	00813483          	ld	s1,8(sp)
    800036c4:	00013903          	ld	s2,0(sp)
    800036c8:	02010113          	addi	sp,sp,32
    800036cc:	00008067          	ret
    800036d0:	00001517          	auipc	a0,0x1
    800036d4:	c8850513          	addi	a0,a0,-888 # 80004358 <digits+0x48>
    800036d8:	fffff097          	auipc	ra,0xfffff
    800036dc:	154080e7          	jalr	340(ra) # 8000282c <panic>
    800036e0:	00001517          	auipc	a0,0x1
    800036e4:	c6050513          	addi	a0,a0,-928 # 80004340 <digits+0x30>
    800036e8:	fffff097          	auipc	ra,0xfffff
    800036ec:	144080e7          	jalr	324(ra) # 8000282c <panic>

00000000800036f0 <holding>:
    800036f0:	00052783          	lw	a5,0(a0)
    800036f4:	00079663          	bnez	a5,80003700 <holding+0x10>
    800036f8:	00000513          	li	a0,0
    800036fc:	00008067          	ret
    80003700:	fe010113          	addi	sp,sp,-32
    80003704:	00813823          	sd	s0,16(sp)
    80003708:	00913423          	sd	s1,8(sp)
    8000370c:	00113c23          	sd	ra,24(sp)
    80003710:	02010413          	addi	s0,sp,32
    80003714:	01053483          	ld	s1,16(a0)
    80003718:	ffffe097          	auipc	ra,0xffffe
    8000371c:	758080e7          	jalr	1880(ra) # 80001e70 <mycpu>
    80003720:	01813083          	ld	ra,24(sp)
    80003724:	01013403          	ld	s0,16(sp)
    80003728:	40a48533          	sub	a0,s1,a0
    8000372c:	00153513          	seqz	a0,a0
    80003730:	00813483          	ld	s1,8(sp)
    80003734:	02010113          	addi	sp,sp,32
    80003738:	00008067          	ret

000000008000373c <push_off>:
    8000373c:	fe010113          	addi	sp,sp,-32
    80003740:	00813823          	sd	s0,16(sp)
    80003744:	00113c23          	sd	ra,24(sp)
    80003748:	00913423          	sd	s1,8(sp)
    8000374c:	02010413          	addi	s0,sp,32
    80003750:	100024f3          	csrr	s1,sstatus
    80003754:	100027f3          	csrr	a5,sstatus
    80003758:	ffd7f793          	andi	a5,a5,-3
    8000375c:	10079073          	csrw	sstatus,a5
    80003760:	ffffe097          	auipc	ra,0xffffe
    80003764:	710080e7          	jalr	1808(ra) # 80001e70 <mycpu>
    80003768:	07852783          	lw	a5,120(a0)
    8000376c:	02078663          	beqz	a5,80003798 <push_off+0x5c>
    80003770:	ffffe097          	auipc	ra,0xffffe
    80003774:	700080e7          	jalr	1792(ra) # 80001e70 <mycpu>
    80003778:	07852783          	lw	a5,120(a0)
    8000377c:	01813083          	ld	ra,24(sp)
    80003780:	01013403          	ld	s0,16(sp)
    80003784:	0017879b          	addiw	a5,a5,1
    80003788:	06f52c23          	sw	a5,120(a0)
    8000378c:	00813483          	ld	s1,8(sp)
    80003790:	02010113          	addi	sp,sp,32
    80003794:	00008067          	ret
    80003798:	0014d493          	srli	s1,s1,0x1
    8000379c:	ffffe097          	auipc	ra,0xffffe
    800037a0:	6d4080e7          	jalr	1748(ra) # 80001e70 <mycpu>
    800037a4:	0014f493          	andi	s1,s1,1
    800037a8:	06952e23          	sw	s1,124(a0)
    800037ac:	fc5ff06f          	j	80003770 <push_off+0x34>

00000000800037b0 <pop_off>:
    800037b0:	ff010113          	addi	sp,sp,-16
    800037b4:	00813023          	sd	s0,0(sp)
    800037b8:	00113423          	sd	ra,8(sp)
    800037bc:	01010413          	addi	s0,sp,16
    800037c0:	ffffe097          	auipc	ra,0xffffe
    800037c4:	6b0080e7          	jalr	1712(ra) # 80001e70 <mycpu>
    800037c8:	100027f3          	csrr	a5,sstatus
    800037cc:	0027f793          	andi	a5,a5,2
    800037d0:	04079663          	bnez	a5,8000381c <pop_off+0x6c>
    800037d4:	07852783          	lw	a5,120(a0)
    800037d8:	02f05a63          	blez	a5,8000380c <pop_off+0x5c>
    800037dc:	fff7871b          	addiw	a4,a5,-1
    800037e0:	06e52c23          	sw	a4,120(a0)
    800037e4:	00071c63          	bnez	a4,800037fc <pop_off+0x4c>
    800037e8:	07c52783          	lw	a5,124(a0)
    800037ec:	00078863          	beqz	a5,800037fc <pop_off+0x4c>
    800037f0:	100027f3          	csrr	a5,sstatus
    800037f4:	0027e793          	ori	a5,a5,2
    800037f8:	10079073          	csrw	sstatus,a5
    800037fc:	00813083          	ld	ra,8(sp)
    80003800:	00013403          	ld	s0,0(sp)
    80003804:	01010113          	addi	sp,sp,16
    80003808:	00008067          	ret
    8000380c:	00001517          	auipc	a0,0x1
    80003810:	b4c50513          	addi	a0,a0,-1204 # 80004358 <digits+0x48>
    80003814:	fffff097          	auipc	ra,0xfffff
    80003818:	018080e7          	jalr	24(ra) # 8000282c <panic>
    8000381c:	00001517          	auipc	a0,0x1
    80003820:	b2450513          	addi	a0,a0,-1244 # 80004340 <digits+0x30>
    80003824:	fffff097          	auipc	ra,0xfffff
    80003828:	008080e7          	jalr	8(ra) # 8000282c <panic>

000000008000382c <push_on>:
    8000382c:	fe010113          	addi	sp,sp,-32
    80003830:	00813823          	sd	s0,16(sp)
    80003834:	00113c23          	sd	ra,24(sp)
    80003838:	00913423          	sd	s1,8(sp)
    8000383c:	02010413          	addi	s0,sp,32
    80003840:	100024f3          	csrr	s1,sstatus
    80003844:	100027f3          	csrr	a5,sstatus
    80003848:	0027e793          	ori	a5,a5,2
    8000384c:	10079073          	csrw	sstatus,a5
    80003850:	ffffe097          	auipc	ra,0xffffe
    80003854:	620080e7          	jalr	1568(ra) # 80001e70 <mycpu>
    80003858:	07852783          	lw	a5,120(a0)
    8000385c:	02078663          	beqz	a5,80003888 <push_on+0x5c>
    80003860:	ffffe097          	auipc	ra,0xffffe
    80003864:	610080e7          	jalr	1552(ra) # 80001e70 <mycpu>
    80003868:	07852783          	lw	a5,120(a0)
    8000386c:	01813083          	ld	ra,24(sp)
    80003870:	01013403          	ld	s0,16(sp)
    80003874:	0017879b          	addiw	a5,a5,1
    80003878:	06f52c23          	sw	a5,120(a0)
    8000387c:	00813483          	ld	s1,8(sp)
    80003880:	02010113          	addi	sp,sp,32
    80003884:	00008067          	ret
    80003888:	0014d493          	srli	s1,s1,0x1
    8000388c:	ffffe097          	auipc	ra,0xffffe
    80003890:	5e4080e7          	jalr	1508(ra) # 80001e70 <mycpu>
    80003894:	0014f493          	andi	s1,s1,1
    80003898:	06952e23          	sw	s1,124(a0)
    8000389c:	fc5ff06f          	j	80003860 <push_on+0x34>

00000000800038a0 <pop_on>:
    800038a0:	ff010113          	addi	sp,sp,-16
    800038a4:	00813023          	sd	s0,0(sp)
    800038a8:	00113423          	sd	ra,8(sp)
    800038ac:	01010413          	addi	s0,sp,16
    800038b0:	ffffe097          	auipc	ra,0xffffe
    800038b4:	5c0080e7          	jalr	1472(ra) # 80001e70 <mycpu>
    800038b8:	100027f3          	csrr	a5,sstatus
    800038bc:	0027f793          	andi	a5,a5,2
    800038c0:	04078463          	beqz	a5,80003908 <pop_on+0x68>
    800038c4:	07852783          	lw	a5,120(a0)
    800038c8:	02f05863          	blez	a5,800038f8 <pop_on+0x58>
    800038cc:	fff7879b          	addiw	a5,a5,-1
    800038d0:	06f52c23          	sw	a5,120(a0)
    800038d4:	07853783          	ld	a5,120(a0)
    800038d8:	00079863          	bnez	a5,800038e8 <pop_on+0x48>
    800038dc:	100027f3          	csrr	a5,sstatus
    800038e0:	ffd7f793          	andi	a5,a5,-3
    800038e4:	10079073          	csrw	sstatus,a5
    800038e8:	00813083          	ld	ra,8(sp)
    800038ec:	00013403          	ld	s0,0(sp)
    800038f0:	01010113          	addi	sp,sp,16
    800038f4:	00008067          	ret
    800038f8:	00001517          	auipc	a0,0x1
    800038fc:	a8850513          	addi	a0,a0,-1400 # 80004380 <digits+0x70>
    80003900:	fffff097          	auipc	ra,0xfffff
    80003904:	f2c080e7          	jalr	-212(ra) # 8000282c <panic>
    80003908:	00001517          	auipc	a0,0x1
    8000390c:	a5850513          	addi	a0,a0,-1448 # 80004360 <digits+0x50>
    80003910:	fffff097          	auipc	ra,0xfffff
    80003914:	f1c080e7          	jalr	-228(ra) # 8000282c <panic>

0000000080003918 <__memset>:
    80003918:	ff010113          	addi	sp,sp,-16
    8000391c:	00813423          	sd	s0,8(sp)
    80003920:	01010413          	addi	s0,sp,16
    80003924:	1a060e63          	beqz	a2,80003ae0 <__memset+0x1c8>
    80003928:	40a007b3          	neg	a5,a0
    8000392c:	0077f793          	andi	a5,a5,7
    80003930:	00778693          	addi	a3,a5,7
    80003934:	00b00813          	li	a6,11
    80003938:	0ff5f593          	andi	a1,a1,255
    8000393c:	fff6071b          	addiw	a4,a2,-1
    80003940:	1b06e663          	bltu	a3,a6,80003aec <__memset+0x1d4>
    80003944:	1cd76463          	bltu	a4,a3,80003b0c <__memset+0x1f4>
    80003948:	1a078e63          	beqz	a5,80003b04 <__memset+0x1ec>
    8000394c:	00b50023          	sb	a1,0(a0)
    80003950:	00100713          	li	a4,1
    80003954:	1ae78463          	beq	a5,a4,80003afc <__memset+0x1e4>
    80003958:	00b500a3          	sb	a1,1(a0)
    8000395c:	00200713          	li	a4,2
    80003960:	1ae78a63          	beq	a5,a4,80003b14 <__memset+0x1fc>
    80003964:	00b50123          	sb	a1,2(a0)
    80003968:	00300713          	li	a4,3
    8000396c:	18e78463          	beq	a5,a4,80003af4 <__memset+0x1dc>
    80003970:	00b501a3          	sb	a1,3(a0)
    80003974:	00400713          	li	a4,4
    80003978:	1ae78263          	beq	a5,a4,80003b1c <__memset+0x204>
    8000397c:	00b50223          	sb	a1,4(a0)
    80003980:	00500713          	li	a4,5
    80003984:	1ae78063          	beq	a5,a4,80003b24 <__memset+0x20c>
    80003988:	00b502a3          	sb	a1,5(a0)
    8000398c:	00700713          	li	a4,7
    80003990:	18e79e63          	bne	a5,a4,80003b2c <__memset+0x214>
    80003994:	00b50323          	sb	a1,6(a0)
    80003998:	00700e93          	li	t4,7
    8000399c:	00859713          	slli	a4,a1,0x8
    800039a0:	00e5e733          	or	a4,a1,a4
    800039a4:	01059e13          	slli	t3,a1,0x10
    800039a8:	01c76e33          	or	t3,a4,t3
    800039ac:	01859313          	slli	t1,a1,0x18
    800039b0:	006e6333          	or	t1,t3,t1
    800039b4:	02059893          	slli	a7,a1,0x20
    800039b8:	40f60e3b          	subw	t3,a2,a5
    800039bc:	011368b3          	or	a7,t1,a7
    800039c0:	02859813          	slli	a6,a1,0x28
    800039c4:	0108e833          	or	a6,a7,a6
    800039c8:	03059693          	slli	a3,a1,0x30
    800039cc:	003e589b          	srliw	a7,t3,0x3
    800039d0:	00d866b3          	or	a3,a6,a3
    800039d4:	03859713          	slli	a4,a1,0x38
    800039d8:	00389813          	slli	a6,a7,0x3
    800039dc:	00f507b3          	add	a5,a0,a5
    800039e0:	00e6e733          	or	a4,a3,a4
    800039e4:	000e089b          	sext.w	a7,t3
    800039e8:	00f806b3          	add	a3,a6,a5
    800039ec:	00e7b023          	sd	a4,0(a5)
    800039f0:	00878793          	addi	a5,a5,8
    800039f4:	fed79ce3          	bne	a5,a3,800039ec <__memset+0xd4>
    800039f8:	ff8e7793          	andi	a5,t3,-8
    800039fc:	0007871b          	sext.w	a4,a5
    80003a00:	01d787bb          	addw	a5,a5,t4
    80003a04:	0ce88e63          	beq	a7,a4,80003ae0 <__memset+0x1c8>
    80003a08:	00f50733          	add	a4,a0,a5
    80003a0c:	00b70023          	sb	a1,0(a4)
    80003a10:	0017871b          	addiw	a4,a5,1
    80003a14:	0cc77663          	bgeu	a4,a2,80003ae0 <__memset+0x1c8>
    80003a18:	00e50733          	add	a4,a0,a4
    80003a1c:	00b70023          	sb	a1,0(a4)
    80003a20:	0027871b          	addiw	a4,a5,2
    80003a24:	0ac77e63          	bgeu	a4,a2,80003ae0 <__memset+0x1c8>
    80003a28:	00e50733          	add	a4,a0,a4
    80003a2c:	00b70023          	sb	a1,0(a4)
    80003a30:	0037871b          	addiw	a4,a5,3
    80003a34:	0ac77663          	bgeu	a4,a2,80003ae0 <__memset+0x1c8>
    80003a38:	00e50733          	add	a4,a0,a4
    80003a3c:	00b70023          	sb	a1,0(a4)
    80003a40:	0047871b          	addiw	a4,a5,4
    80003a44:	08c77e63          	bgeu	a4,a2,80003ae0 <__memset+0x1c8>
    80003a48:	00e50733          	add	a4,a0,a4
    80003a4c:	00b70023          	sb	a1,0(a4)
    80003a50:	0057871b          	addiw	a4,a5,5
    80003a54:	08c77663          	bgeu	a4,a2,80003ae0 <__memset+0x1c8>
    80003a58:	00e50733          	add	a4,a0,a4
    80003a5c:	00b70023          	sb	a1,0(a4)
    80003a60:	0067871b          	addiw	a4,a5,6
    80003a64:	06c77e63          	bgeu	a4,a2,80003ae0 <__memset+0x1c8>
    80003a68:	00e50733          	add	a4,a0,a4
    80003a6c:	00b70023          	sb	a1,0(a4)
    80003a70:	0077871b          	addiw	a4,a5,7
    80003a74:	06c77663          	bgeu	a4,a2,80003ae0 <__memset+0x1c8>
    80003a78:	00e50733          	add	a4,a0,a4
    80003a7c:	00b70023          	sb	a1,0(a4)
    80003a80:	0087871b          	addiw	a4,a5,8
    80003a84:	04c77e63          	bgeu	a4,a2,80003ae0 <__memset+0x1c8>
    80003a88:	00e50733          	add	a4,a0,a4
    80003a8c:	00b70023          	sb	a1,0(a4)
    80003a90:	0097871b          	addiw	a4,a5,9
    80003a94:	04c77663          	bgeu	a4,a2,80003ae0 <__memset+0x1c8>
    80003a98:	00e50733          	add	a4,a0,a4
    80003a9c:	00b70023          	sb	a1,0(a4)
    80003aa0:	00a7871b          	addiw	a4,a5,10
    80003aa4:	02c77e63          	bgeu	a4,a2,80003ae0 <__memset+0x1c8>
    80003aa8:	00e50733          	add	a4,a0,a4
    80003aac:	00b70023          	sb	a1,0(a4)
    80003ab0:	00b7871b          	addiw	a4,a5,11
    80003ab4:	02c77663          	bgeu	a4,a2,80003ae0 <__memset+0x1c8>
    80003ab8:	00e50733          	add	a4,a0,a4
    80003abc:	00b70023          	sb	a1,0(a4)
    80003ac0:	00c7871b          	addiw	a4,a5,12
    80003ac4:	00c77e63          	bgeu	a4,a2,80003ae0 <__memset+0x1c8>
    80003ac8:	00e50733          	add	a4,a0,a4
    80003acc:	00b70023          	sb	a1,0(a4)
    80003ad0:	00d7879b          	addiw	a5,a5,13
    80003ad4:	00c7f663          	bgeu	a5,a2,80003ae0 <__memset+0x1c8>
    80003ad8:	00f507b3          	add	a5,a0,a5
    80003adc:	00b78023          	sb	a1,0(a5)
    80003ae0:	00813403          	ld	s0,8(sp)
    80003ae4:	01010113          	addi	sp,sp,16
    80003ae8:	00008067          	ret
    80003aec:	00b00693          	li	a3,11
    80003af0:	e55ff06f          	j	80003944 <__memset+0x2c>
    80003af4:	00300e93          	li	t4,3
    80003af8:	ea5ff06f          	j	8000399c <__memset+0x84>
    80003afc:	00100e93          	li	t4,1
    80003b00:	e9dff06f          	j	8000399c <__memset+0x84>
    80003b04:	00000e93          	li	t4,0
    80003b08:	e95ff06f          	j	8000399c <__memset+0x84>
    80003b0c:	00000793          	li	a5,0
    80003b10:	ef9ff06f          	j	80003a08 <__memset+0xf0>
    80003b14:	00200e93          	li	t4,2
    80003b18:	e85ff06f          	j	8000399c <__memset+0x84>
    80003b1c:	00400e93          	li	t4,4
    80003b20:	e7dff06f          	j	8000399c <__memset+0x84>
    80003b24:	00500e93          	li	t4,5
    80003b28:	e75ff06f          	j	8000399c <__memset+0x84>
    80003b2c:	00600e93          	li	t4,6
    80003b30:	e6dff06f          	j	8000399c <__memset+0x84>

0000000080003b34 <__memmove>:
    80003b34:	ff010113          	addi	sp,sp,-16
    80003b38:	00813423          	sd	s0,8(sp)
    80003b3c:	01010413          	addi	s0,sp,16
    80003b40:	0e060863          	beqz	a2,80003c30 <__memmove+0xfc>
    80003b44:	fff6069b          	addiw	a3,a2,-1
    80003b48:	0006881b          	sext.w	a6,a3
    80003b4c:	0ea5e863          	bltu	a1,a0,80003c3c <__memmove+0x108>
    80003b50:	00758713          	addi	a4,a1,7
    80003b54:	00a5e7b3          	or	a5,a1,a0
    80003b58:	40a70733          	sub	a4,a4,a0
    80003b5c:	0077f793          	andi	a5,a5,7
    80003b60:	00f73713          	sltiu	a4,a4,15
    80003b64:	00174713          	xori	a4,a4,1
    80003b68:	0017b793          	seqz	a5,a5
    80003b6c:	00e7f7b3          	and	a5,a5,a4
    80003b70:	10078863          	beqz	a5,80003c80 <__memmove+0x14c>
    80003b74:	00900793          	li	a5,9
    80003b78:	1107f463          	bgeu	a5,a6,80003c80 <__memmove+0x14c>
    80003b7c:	0036581b          	srliw	a6,a2,0x3
    80003b80:	fff8081b          	addiw	a6,a6,-1
    80003b84:	02081813          	slli	a6,a6,0x20
    80003b88:	01d85893          	srli	a7,a6,0x1d
    80003b8c:	00858813          	addi	a6,a1,8
    80003b90:	00058793          	mv	a5,a1
    80003b94:	00050713          	mv	a4,a0
    80003b98:	01088833          	add	a6,a7,a6
    80003b9c:	0007b883          	ld	a7,0(a5)
    80003ba0:	00878793          	addi	a5,a5,8
    80003ba4:	00870713          	addi	a4,a4,8
    80003ba8:	ff173c23          	sd	a7,-8(a4)
    80003bac:	ff0798e3          	bne	a5,a6,80003b9c <__memmove+0x68>
    80003bb0:	ff867713          	andi	a4,a2,-8
    80003bb4:	02071793          	slli	a5,a4,0x20
    80003bb8:	0207d793          	srli	a5,a5,0x20
    80003bbc:	00f585b3          	add	a1,a1,a5
    80003bc0:	40e686bb          	subw	a3,a3,a4
    80003bc4:	00f507b3          	add	a5,a0,a5
    80003bc8:	06e60463          	beq	a2,a4,80003c30 <__memmove+0xfc>
    80003bcc:	0005c703          	lbu	a4,0(a1)
    80003bd0:	00e78023          	sb	a4,0(a5)
    80003bd4:	04068e63          	beqz	a3,80003c30 <__memmove+0xfc>
    80003bd8:	0015c603          	lbu	a2,1(a1)
    80003bdc:	00100713          	li	a4,1
    80003be0:	00c780a3          	sb	a2,1(a5)
    80003be4:	04e68663          	beq	a3,a4,80003c30 <__memmove+0xfc>
    80003be8:	0025c603          	lbu	a2,2(a1)
    80003bec:	00200713          	li	a4,2
    80003bf0:	00c78123          	sb	a2,2(a5)
    80003bf4:	02e68e63          	beq	a3,a4,80003c30 <__memmove+0xfc>
    80003bf8:	0035c603          	lbu	a2,3(a1)
    80003bfc:	00300713          	li	a4,3
    80003c00:	00c781a3          	sb	a2,3(a5)
    80003c04:	02e68663          	beq	a3,a4,80003c30 <__memmove+0xfc>
    80003c08:	0045c603          	lbu	a2,4(a1)
    80003c0c:	00400713          	li	a4,4
    80003c10:	00c78223          	sb	a2,4(a5)
    80003c14:	00e68e63          	beq	a3,a4,80003c30 <__memmove+0xfc>
    80003c18:	0055c603          	lbu	a2,5(a1)
    80003c1c:	00500713          	li	a4,5
    80003c20:	00c782a3          	sb	a2,5(a5)
    80003c24:	00e68663          	beq	a3,a4,80003c30 <__memmove+0xfc>
    80003c28:	0065c703          	lbu	a4,6(a1)
    80003c2c:	00e78323          	sb	a4,6(a5)
    80003c30:	00813403          	ld	s0,8(sp)
    80003c34:	01010113          	addi	sp,sp,16
    80003c38:	00008067          	ret
    80003c3c:	02061713          	slli	a4,a2,0x20
    80003c40:	02075713          	srli	a4,a4,0x20
    80003c44:	00e587b3          	add	a5,a1,a4
    80003c48:	f0f574e3          	bgeu	a0,a5,80003b50 <__memmove+0x1c>
    80003c4c:	02069613          	slli	a2,a3,0x20
    80003c50:	02065613          	srli	a2,a2,0x20
    80003c54:	fff64613          	not	a2,a2
    80003c58:	00e50733          	add	a4,a0,a4
    80003c5c:	00c78633          	add	a2,a5,a2
    80003c60:	fff7c683          	lbu	a3,-1(a5)
    80003c64:	fff78793          	addi	a5,a5,-1
    80003c68:	fff70713          	addi	a4,a4,-1
    80003c6c:	00d70023          	sb	a3,0(a4)
    80003c70:	fec798e3          	bne	a5,a2,80003c60 <__memmove+0x12c>
    80003c74:	00813403          	ld	s0,8(sp)
    80003c78:	01010113          	addi	sp,sp,16
    80003c7c:	00008067          	ret
    80003c80:	02069713          	slli	a4,a3,0x20
    80003c84:	02075713          	srli	a4,a4,0x20
    80003c88:	00170713          	addi	a4,a4,1
    80003c8c:	00e50733          	add	a4,a0,a4
    80003c90:	00050793          	mv	a5,a0
    80003c94:	0005c683          	lbu	a3,0(a1)
    80003c98:	00178793          	addi	a5,a5,1
    80003c9c:	00158593          	addi	a1,a1,1
    80003ca0:	fed78fa3          	sb	a3,-1(a5)
    80003ca4:	fee798e3          	bne	a5,a4,80003c94 <__memmove+0x160>
    80003ca8:	f89ff06f          	j	80003c30 <__memmove+0xfc>

0000000080003cac <__putc>:
    80003cac:	fe010113          	addi	sp,sp,-32
    80003cb0:	00813823          	sd	s0,16(sp)
    80003cb4:	00113c23          	sd	ra,24(sp)
    80003cb8:	02010413          	addi	s0,sp,32
    80003cbc:	00050793          	mv	a5,a0
    80003cc0:	fef40593          	addi	a1,s0,-17
    80003cc4:	00100613          	li	a2,1
    80003cc8:	00000513          	li	a0,0
    80003ccc:	fef407a3          	sb	a5,-17(s0)
    80003cd0:	fffff097          	auipc	ra,0xfffff
    80003cd4:	b3c080e7          	jalr	-1220(ra) # 8000280c <console_write>
    80003cd8:	01813083          	ld	ra,24(sp)
    80003cdc:	01013403          	ld	s0,16(sp)
    80003ce0:	02010113          	addi	sp,sp,32
    80003ce4:	00008067          	ret

0000000080003ce8 <__getc>:
    80003ce8:	fe010113          	addi	sp,sp,-32
    80003cec:	00813823          	sd	s0,16(sp)
    80003cf0:	00113c23          	sd	ra,24(sp)
    80003cf4:	02010413          	addi	s0,sp,32
    80003cf8:	fe840593          	addi	a1,s0,-24
    80003cfc:	00100613          	li	a2,1
    80003d00:	00000513          	li	a0,0
    80003d04:	fffff097          	auipc	ra,0xfffff
    80003d08:	ae8080e7          	jalr	-1304(ra) # 800027ec <console_read>
    80003d0c:	fe844503          	lbu	a0,-24(s0)
    80003d10:	01813083          	ld	ra,24(sp)
    80003d14:	01013403          	ld	s0,16(sp)
    80003d18:	02010113          	addi	sp,sp,32
    80003d1c:	00008067          	ret

0000000080003d20 <console_handler>:
    80003d20:	fe010113          	addi	sp,sp,-32
    80003d24:	00813823          	sd	s0,16(sp)
    80003d28:	00113c23          	sd	ra,24(sp)
    80003d2c:	00913423          	sd	s1,8(sp)
    80003d30:	02010413          	addi	s0,sp,32
    80003d34:	14202773          	csrr	a4,scause
    80003d38:	100027f3          	csrr	a5,sstatus
    80003d3c:	0027f793          	andi	a5,a5,2
    80003d40:	06079e63          	bnez	a5,80003dbc <console_handler+0x9c>
    80003d44:	00074c63          	bltz	a4,80003d5c <console_handler+0x3c>
    80003d48:	01813083          	ld	ra,24(sp)
    80003d4c:	01013403          	ld	s0,16(sp)
    80003d50:	00813483          	ld	s1,8(sp)
    80003d54:	02010113          	addi	sp,sp,32
    80003d58:	00008067          	ret
    80003d5c:	0ff77713          	andi	a4,a4,255
    80003d60:	00900793          	li	a5,9
    80003d64:	fef712e3          	bne	a4,a5,80003d48 <console_handler+0x28>
    80003d68:	ffffe097          	auipc	ra,0xffffe
    80003d6c:	6dc080e7          	jalr	1756(ra) # 80002444 <plic_claim>
    80003d70:	00a00793          	li	a5,10
    80003d74:	00050493          	mv	s1,a0
    80003d78:	02f50c63          	beq	a0,a5,80003db0 <console_handler+0x90>
    80003d7c:	fc0506e3          	beqz	a0,80003d48 <console_handler+0x28>
    80003d80:	00050593          	mv	a1,a0
    80003d84:	00000517          	auipc	a0,0x0
    80003d88:	50450513          	addi	a0,a0,1284 # 80004288 <CONSOLE_STATUS+0x278>
    80003d8c:	fffff097          	auipc	ra,0xfffff
    80003d90:	afc080e7          	jalr	-1284(ra) # 80002888 <__printf>
    80003d94:	01013403          	ld	s0,16(sp)
    80003d98:	01813083          	ld	ra,24(sp)
    80003d9c:	00048513          	mv	a0,s1
    80003da0:	00813483          	ld	s1,8(sp)
    80003da4:	02010113          	addi	sp,sp,32
    80003da8:	ffffe317          	auipc	t1,0xffffe
    80003dac:	6d430067          	jr	1748(t1) # 8000247c <plic_complete>
    80003db0:	fffff097          	auipc	ra,0xfffff
    80003db4:	3e0080e7          	jalr	992(ra) # 80003190 <uartintr>
    80003db8:	fddff06f          	j	80003d94 <console_handler+0x74>
    80003dbc:	00000517          	auipc	a0,0x0
    80003dc0:	5cc50513          	addi	a0,a0,1484 # 80004388 <digits+0x78>
    80003dc4:	fffff097          	auipc	ra,0xfffff
    80003dc8:	a68080e7          	jalr	-1432(ra) # 8000282c <panic>
	...
