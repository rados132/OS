.align 4
.global trap_handler
trap_handler:
    addi sp, sp, -16
    sd   t0, 0(sp)
    csrr t0, sepc
    addi t0, t0, 4
    csrw sepc, t0
    ld   t0, 0(sp)
    addi sp, sp, 16
    sret
