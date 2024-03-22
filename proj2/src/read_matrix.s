.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -24
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw s0, 12(sp)
    sw s1, 16(sp)
    sw ra, 20(sp)

    mv a1, a0

    #jal ra, print_str

    li a2, 0
    jal ra, fopen
    li t0, -1
    beq a0, t0, fopen_error
    mv s0, a0

    mv a1, s0
    lw a2, 4(sp)
    li a3, 4
    jal ra, fread
    bne a0, a3, fread_error

    mv a1, s0
    lw a2, 8(sp)
    li a3, 4
    jal ra, fread
    bne a0, a3, fread_error

    lw a1, 4(sp)
    lw a2, 8(sp)
    lw t1, 0(a1)
    lw t2, 0(a2)
    mul t3, t1, t2
    slli t3, t3, 2
    mv a0, t3
    jal ra, malloc
    mv s1, a0

    mv a1, s0
    mv a2, s1
    mv a3, t3
    jal ra, fread
    bne a0, a3, fread_error

    mv a1, s0
    jal ra, fclose
    bne a0, x0, fclose_error

    mv a0, s1
    # Epilogue
    lw ra, 20(sp)
    lw s1, 16(sp)
    lw s0, 12(sp)
    addi sp, sp, 24
    j end

fopen_error:
    li a1, 50
    j error
fread_error:
    li a1, 51
    j error
fclose_error:
    li a1, 52
error:
    li a0, 17
    ecall
end:
    ret