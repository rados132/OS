# void pop_spp_spie ();
#
# Helper function used to return from kernel to user mode and enable interrupts

.global pop_spp_spie
pop_spp_spie:
    csrw sepc, ra     # savedpc <- retaddr

    li   t0, 0x100    # SPP mask (bit 8)
    csrc sstatus, t0  # SPP = 0, return to user mode

    li   t0, 0x20     # SPIE mask (bit 5)
    csrs sstatus, t0  # SPIE = 1, interrupts enabled
        
    sret
