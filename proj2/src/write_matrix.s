.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -20
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw ra, 16(sp)
    
    mv a1, a0
    li a2, 1
    jal ra, fopen
    li t0, -1
    beq a0, t0, fopen_error

    mv a1, a0
    addi a2, sp, 8
    li a3, 1
    li a4, 4
    jal ra, fwrite
    bne a0, a3, fwrite_error

    addi a2, sp, 12
    jal ra, fwrite
    bne a0, a3, fwrite_error

    lw t0, 4(sp)
    lw t1, 8(sp)
    lw t2, 12(sp)
    mv a2, t0
    mul a3, t1, t2
    li a4, 4
    jal ra, fwrite
    bne a0, a3, fwrite_error

    jal ra, fclose
    bne a0, x0, fclose_error

    # Epilogue
    lw ra, 16(sp)
    addi sp, sp, 20
    j end

fopen_error:
    li a1, 53
    j error
fwrite_error:
    li a1, 54
    j error
fclose_error:
    li a1, 55
error:
    li a0, 17
    ecall
end:
    ret
