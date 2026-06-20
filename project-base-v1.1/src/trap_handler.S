.extern supervisor_trap_handler

.balign 4
.global trap_handler
trap_handler:
    addi sp, sp, -256
    csrw sscratch, sp

    # push all user regs
    .irp reg, 1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\reg, \reg * 8(sp)
    .endr

    call supervisor_trap_handler

    # pop all user regs
    .irp reg, 1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    ld x\reg, \reg * 8(sp)
    .endr

    addi sp, sp, 256
    sret
