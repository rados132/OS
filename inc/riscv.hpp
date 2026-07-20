#ifndef RISCV_HPP
#define RISCV_HPP

#include "../lib/hw.h"

class CSR {
public:
    static uint64 r_scause ();
    static void   w_scause ( uint64 scause );

    static uint64 r_sepc ();
    static void   w_sepc ( uint64 sepc );

    static uint64 r_stvec ();
    static void   w_stvec ( uint64 stvec );

    static uint64 r_stval ();
    static void   w_stval ( uint64 stval );

    enum BitMaskSip {
        SIP_SSIP = (1 << 1), // software pending
        SIP_STIP = (1 << 5), // timer pending
        SIP_SEIP = (1 << 9), // external pending
    };

    static void   ms_sip ( uint64 mask );
    static void   mc_sip ( uint64 mask );
    static uint64 r_sip  ();
    static void   w_sip  ( uint64 sip );

    enum BitMaskSstatus {
        SSTATUS_SIE  = (1 << 1),
        SSTATUS_SPIE = (1 << 5),
        SSTATUS_SPP  = (1 << 8),
    };

    static void   ms_sstatus ( uint64 mask );
    static void   mc_sstatus ( uint64 mask );
    static uint64 r_sstatus  ();
    static void   w_sstatus  ( uint64 sstatus );

    static uint64 r_sscratch ();
    static void   w_sscratch ( uint64 sscratch );
};

inline uint64 CSR::r_scause () {
    uint64 volatile scause;

    __asm__ volatile ("csrr %[scause], scause" : [scause] "=r"(scause));

    return scause;
}

inline void CSR::w_scause (uint64 scause) {
    __asm__ volatile ("csrw scause, %[scause]" : : [scause] "r"(scause));
}

inline uint64 CSR::r_sepc () {
    uint64 volatile sepc;

    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));

    return sepc;
}

inline void CSR::w_sepc (uint64 sepc) {
    __asm__ volatile ("csrw sepc, %[sepc]" : : [sepc] "r"(sepc));
}

inline uint64 CSR::r_stvec () {
    uint64 volatile stvec;

    __asm__ volatile ("csrr %[stvec], stvec" : [stvec] "=r"(stvec));

    return stvec;
}

inline void CSR::w_stvec (uint64 stvec) {
    __asm__ volatile ("csrw stvec, %[stvec]" : : [stvec] "r"(stvec));
}

inline uint64 CSR::r_stval () {
    uint64 volatile stval;

    __asm__ volatile ("csrr %[stval], stval" : [stval] "=r"(stval));

    return stval;
}

inline void CSR::w_stval (uint64 stval) {
    __asm__ volatile ("csrw stval, %[stval]" : : [stval] "r"(stval));
}

inline void CSR::ms_sip (uint64 mask) {
    __asm__ volatile ("csrs sip, %[mask]" : : [mask] "r"(mask));
}

inline void CSR::mc_sip (uint64 mask) {
    __asm__ volatile ("csrc sip, %[mask]" : : [mask] "r"(mask));
}

inline uint64 CSR::r_sip () {
    uint64 volatile sip;

    __asm__ volatile ("csrr %[sip], sip" : [sip] "=r"(sip));

    return sip;
}

inline void CSR::w_sip (uint64 sip) {
    __asm__ volatile ("csrw sip, %[sip]" : : [sip] "r"(sip));
}

inline void CSR::ms_sstatus (uint64 mask) {
    __asm__ volatile ("csrs sstatus, %[mask]" : : [mask] "r"(mask));
}

inline void CSR::mc_sstatus (uint64 mask) {
    __asm__ volatile ("csrc sstatus, %[mask]" : : [mask] "r"(mask));
}

inline uint64 CSR::r_sstatus () {
    uint64 volatile sstatus;

    __asm__ volatile ("csrr %[sstatus], sstatus" : [sstatus] "=r"(sstatus));

    return sstatus;
}

inline void CSR::w_sstatus (uint64 sstatus) {
    __asm__ volatile ("csrw sstatus, %[sstatus]" : : [sstatus] "r"(sstatus));
}

inline uint64 CSR::r_sscratch () {
    uint64 volatile sscratch;

    __asm__ volatile ("csrr %[sscratch], sscratch" : [sscratch] "=r"(sscratch));

    return sscratch;
}

inline void CSR::w_sscratch (uint64 sscratch) {
    __asm__ volatile ("csrw sscratch, %[sscratch]" : : [sscratch] "r"(sscratch));
}

inline void mask_interrupts () {
    CSR::mc_sstatus ( CSR::SSTATUS_SIE );
}

inline void unmask_interrupts () {
    CSR::ms_sstatus ( CSR::SSTATUS_SIE );
}

enum UserRegs {
    ZERO = 0,
    RA = 1,
    SP = 2,
    GP = 3,
    TP = 4,
    T0 = 5,
    T1 = 6,
    T2 = 7,
    S0 = 8,
    S1 = 9,
    A0 = 10,
    A1 = 11,
    A2 = 12,
    A3 = 13, 
    A4 = 14, 
    A5 = 15, 
    A6 = 16, 
    A7 = 17,
    S2 = 18, 
    S3 = 19, 
    S4 = 20, 
    S5 = 21, 
    S6 = 22,
    S7 = 23, 
    S8 = 24, 
    S9 = 25, 
    S10 = 26, 
    S11 = 27,
    T3 = 28, 
    T4 = 29, 
    T5 = 30, 
    T6 = 31,
};

class TrapFrame {
public:
    static uint64 r_user_reg ( uint64 reg );
    static void   w_user_reg ( uint64 reg, uint64 value );

private:
    static uint64* get_trap_frame ();
};

inline uint64* TrapFrame::get_trap_frame () {
    uint64* fp;

    __asm__ volatile ("mv %0, fp" : "=r"(fp));

    return fp;
}

inline uint64 TrapFrame::r_user_reg (uint64 reg) {
    uint64* trap_frame = get_trap_frame ();
    return trap_frame[reg];
}

inline void TrapFrame::w_user_reg (uint64 reg, uint64 value) {
    uint64* trap_frame = get_trap_frame ();
    trap_frame[reg] = value;
}

#endif
