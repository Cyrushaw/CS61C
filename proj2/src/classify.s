.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

	# =====================================
    # LOAD MATRICES
    # =====================================
    addi sp, sp, -36
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw s0, 12(sp)
    sw s1, 16(sp)
    sw s2, 20(sp)
    sw s3, 24(sp)
    sw s4, 28(sp)
    sw ra, 32(sp)

    mv s4, a1
    li a0, 24
    jal ra, malloc
    mv s3, a0                   # array of rows and columns' number
    # Load pretrained m0
    lw a0, 4(s4)
    addi a1, s3, 0
    addi a2, s3, 4
    jal ra, read_matrix
    mv s0, a0                   # s0 is pointer to m0

    # Load pretrained m1
    lw a0, 8(s4)
    addi a1, s3, 8
    addi a2, s3, 12       
    jal ra, read_matrix
    mv s1, a0                   # s1 is pointer to m1

    # Load input matrix
    lw a0, 12(s4)
    addi a1, s3, 16
    addi a2, s3, 20
    jal ra, read_matrix
    mv s2, a0                   # s2 is pointer to input

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    lw t0, 0(s3)
    lw t1, 20(s3)
    mul t0, t0, t1
    slli t0, t0, 2
    mv a0, t0                   # t0 is length of m0 * input
    jal ra, malloc
    mv t1, a0                   # t1 is pointer to m0 * input

    mv a0, s0
    lw a1, 0(s3)
    lw a2, 4(s3)
    mv a3, s2
    lw a4, 16(s3)
    lw a5, 20(s3)
    mv a6, t1
    addi sp, sp, -8
    sw t0, 0(sp)
    sw t1, 4(sp)
    jal ra, matmul
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 8

    srli t0, t0, 2
    mv a0, t1
    mv a1, t0
    addi sp, sp, -4
    sw t1, 0(sp)
    jal ra, relu                # t1 points to relu(m0 * input)
    lw t1, 0(sp)
    addi sp, sp, 4

    lw t2, 8(s3)
    lw t3, 20(s3)
    mul t2, t2, t3              # t2 is length of m1 * relu(m0 * input)
    slli t2, t2, 2
    mv a0, t2
    jal ra, malloc
    mv t3, a0                   # t3 points to m1 * relu(m0 * input)

    mv a0, s1
    lw a1, 8(s3)
    lw a2, 12(s3)
    mv a3, t1
    lw a4, 0(s3)
    lw a5, 20(s3)
    mv a6, t3
    addi sp, sp, -12
    sw t1, 0(sp)
    sw t2, 4(sp)
    sw t3, 8(sp)
    jal ra, matmul
    lw t3, 8(sp)
    lw t2, 4(sp)
    lw t1, 0(sp)
    addi sp, sp, 12

    mv a0, t1
    jal ra, free                # free t1 (pointer to relu(m0 * input))

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    lw a0, 16(s4)
    mv a1, t3
    lw a2, 8(s3)
    lw a3, 20(s3)
    addi sp, sp, -8
    sw t2, 0(sp)
    sw t3, 4(sp)
    jal ra, write_matrix
    lw t3, 4(sp)
    lw t2, 0(sp)
    addi sp, sp, 8

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax

    srli t2, t2, 2
    mv a0, t3
    mv a1, t2
    addi sp, sp, -4
    sw t3, 0(sp)
    jal ra, argmax
    lw t3, 0(sp)
    addi sp, sp, 4
    mv t0, a0

    # free
    mv a0, t3
    jal ra, free
    mv a0, s0
    jal ra, free
    mv a0, s1
    jal ra, free
    mv a0, s2
    jal ra, free
    mv a0, s3
    jal ra, free

    
    lw a2, 8(sp)
    bne a2, x0, end

    # Print classification
    mv a1, t0
    jal ra, print_int
    
    # Print newline afterwards for clarity
    li a1, '\n'
    jal ra, print_char
end:
    # epilogue
    lw ra, 32(sp)
    lw s4, 28(sp)
    lw s3, 24(sp)
    lw s2, 20(sp)
    lw s1, 16(sp)
    lw s0, 12(sp)
    addi sp, sp, 36
    ret