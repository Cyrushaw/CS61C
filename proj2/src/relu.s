.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue
    addi t0, x0, 1
    blt a1, t0, error
loop_start:
    addi t0, x0, 0              # t0 is times of loop_continue
loop_continue:
    slli t1, t0, 2              # t1 is the offset
    add t2, a0, t1              # t2 is the offset address of the array
    lw t3, 0(t2)                # t3 is the element
    blt t3, x0, else
then:
    sw t3, 0(t2)
    j end
else:
    sw x0, 0(t2) 
end:
    addi t0, t0, 1
    bge t0, a1, loop_end
    j loop_continue
loop_end:
    # Epilogue
	ret
error:                          # error
    li a0, 17
    li a1, 8
    ecall
    ret