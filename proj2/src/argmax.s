.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:

    # Prologue
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)

    li t0, 1
    blt a1, t0, error

loop_start:
    li t0, 0
    li s0, 0            # s0 is the largest element
    mv s1, a0           # s1 is the address of array
loop_continue:
    slli t1, t0, 2
    add t2, t1, s1
    lw t3, 0(t2)
    bge s0, t3, end
then:
    mv s0, t3
    mv a0, t0
end:
    addi t0, t0, 1
    bge t0, a1, loop_end
    j loop_continue
loop_end:
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 8
    # Epilogue
    ret
error:
    li a0, 17
    li a1, 7
    ecall
    ret