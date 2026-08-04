# Context switch
#
# void context_switch ( Context* ctx_old, Context* ctx_new );
#
# Save the current context in ctx_old and load the new context from ctx_new.

.global context_switch
context_switch:
    # store old context
    sd ra,   0*8(a0)
    sd sp,   1*8(a0)
    sd s0,   2*8(a0)
    sd s1,   3*8(a0)
    sd s2,   4*8(a0)
    sd s3,   5*8(a0)
    sd s4,   6*8(a0)
    sd s5,   7*8(a0)
    sd s6,   8*8(a0)
    sd s7,   9*8(a0)
    sd s8,  10*8(a0)
    sd s9,  11*8(a0)
    sd s10, 12*8(a0)
    sd s11, 13*8(a0)

    # load new context
    ld ra,   0*8(a1)
    ld sp,   1*8(a1)
    ld s0,   2*8(a1)
    ld s1,   3*8(a1)
    ld s2,   4*8(a1)
    ld s3,   5*8(a1)
    ld s4,   6*8(a1)
    ld s5,   7*8(a1)
    ld s6,   8*8(a1)
    ld s7,   9*8(a1)
    ld s8,  10*8(a1)
    ld s9,  11*8(a1)
    ld s10, 12*8(a1)
    ld s11, 13*8(a1)

    ret
