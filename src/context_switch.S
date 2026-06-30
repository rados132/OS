.global context_switch
context_switch:
    # push all user regs
    addi sp, sp, -256
    .irp reg, 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\reg, \reg * 8(sp)
    .endr

    # store old context
    sd ra, 0(a0)
    sd sp, 8(a0)

    # load new context
    ld ra, 0(a1)
    ld sp, 8(a1)

    # pop all user regs
    .irp reg, 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    ld x\reg, \reg * 8(sp)
    .endr
    addi sp, sp, 256

    ret
