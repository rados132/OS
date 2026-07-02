.global pop_spp_spie
pop_spp_spie:
    csrw sepc, ra   

    li   t0, 0x100           # SPP maska (bit 8)
    csrc sstatus, t0         # SPP = 0 → sret ide u U-mode

    li   t0, 0x20            # SPIE maska (bit 5)
    csrs sstatus, t0         # SPIE = 1 
        
    sret
