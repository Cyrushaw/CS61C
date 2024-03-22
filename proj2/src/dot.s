.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)
    # Prologue
    li t0, 1
    blt a2, t0, length_error
    blt a3, t0, stride_error
    blt a4, t0, stride_error
    mv s0, a0
    mv s1, a1
loop_start:
    li a0, 0
    li t0, 0                    # times of loop
loop_continue:
    mul t1, t0, a3              # index of v0
    mul t2, t0, a4              # index of v1
    slli t1, t1, 2              # offset of v0 address
    slli t2, t2, 2              # offset of v1 address
    add t1, t1, s0              # address of element in v0
    add t2, t2, s1              # address of element in v1
    lw t1, 0(t1)
    lw t2, 0(t2)
    mul t3, t1, t2
    add a0, a0, t3
    addi t0, t0, 1
    bge t0, a2, loop_end
    j loop_continue
loop_end:
    # Epilogue
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 8
    j end
length_error:
    li a1, 5
    j error
stride_error:
    li a1, 6
error:
    li a0, 17
    ecall
end:
    ret
