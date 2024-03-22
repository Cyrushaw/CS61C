.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error checks
    li t0, 1
    blt a1, t0, error_m0
    blt a2, t0, error_m0
    blt a4, t0, error_m1
    blt a5, t0, error_m1
    bne a2, a4, error_match
    # Prologue
    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a5

outer_loop_start:
    li t0, 0                    # index of rows
inner_loop_start:
    li t1, 0                    # index of columns
inner_loop_continue:
    mul t2, t0, s2
    slli t2, t2, 2
    add a0, s0, t2              # head address of row
    slli t2, t1, 2
    add a1, s3, t2              # head address of column
    mv a2, s2                   # length of row and column
    li a3, 1                    # stride of row
    mv a4, s4                   # stride of column
####do not forget to push temporary registers!!!
    #prologue
    addi sp, sp, -8
    sw t0, 0(sp)
    sw t1, 4(sp)
    jal ra, dot
    #epilogue
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 8

    mul t2, t0, s4
    add t2, t2, t1
    slli t2, t2, 2
    add t2, t2, a6              # offset of d address
    sw a0, 0(t2)

    addi t1, t1, 1
    bge t1, s4, inner_loop_end
    j inner_loop_continue
inner_loop_end:
    addi t0, t0, 1
    bge t0, s1, outer_loop_end
    j inner_loop_start
outer_loop_end:
    # Epilogue
    lw ra, 20(sp)
    lw s4, 16(sp)
    lw s3, 12(sp)
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 24
    j end
error_m0:
    li a1, 2
    j error
error_m1:
    li a1, 3
    j error
error_match:
    li a1, 4
error:
    li a0, 17
    ecall
end:
    ret