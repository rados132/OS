.global push_regs, pop_regs

push_regs:
    # push all user regs
    addi sp, sp, -256
    .irp reg, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\reg, \reg * 8(sp)
    .endr

    ret

pop_regs:
    # pop all user regs
    .irp reg, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    ld x\reg, \reg * 8(sp)
    .endr
    addi sp, sp, 256

    ret
