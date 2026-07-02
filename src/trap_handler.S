.extern supervisor_trap_handler
.extern timer_interrupt_handler
.extern console_interrupt_handler

.balign 4
.global ivtp

ivtp:
    j trap_handler
    j timer_interrupt
    .skip 28
    j console_interrupt
    sret

trap_handler:   
    addi sp, sp, -256

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

timer_interrupt:
    addi sp, sp, -256

    # push all user regs
    .irp reg, 1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\reg, \reg * 8(sp)
    .endr

    call timer_interrupt_handler

    # pop all user regs
    .irp reg, 1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    ld x\reg, \reg * 8(sp)
    .endr

    addi sp, sp, 256
    sret

console_interrupt:
    addi sp, sp, -256

    # push all user regs
    .irp reg, 1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\reg, \reg * 8(sp)
    .endr

    call console_interrupt_handler

    # pop all user regs
    .irp reg, 1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    ld x\reg, \reg * 8(sp)
    .endr

    addi sp, sp, 256
    sret
