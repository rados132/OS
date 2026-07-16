.extern supervisor_trap_handler
.extern timer_interrupt_handler
.extern console_interrupt_handler

.balign 4
.global trap_handler

.macro save_regs
    # push all user regs
    addi sp, sp, -256
    .irp reg, 1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\reg, \reg * 8(sp)
    .endr
.endm

.macro restore_regs
    # pop all user regs
    .irp reg, 1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    ld x\reg, \reg * 8(sp)
    .endr
    addi sp, sp, 256
.endm

trap_handler:
    j internal_trap
    j timer_interrupt
.skip 28
    j console_interrupt

internal_trap:   
    save_regs
    call supervisor_trap_handler
    restore_regs
    sret

timer_interrupt:
    save_regs
    call timer_interrupt_handler
    restore_regs
    sret

console_interrupt:
    save_regs
    call console_interrupt_handler
    restore_regs
    sret
