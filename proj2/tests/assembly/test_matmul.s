.import ../../src/matmul.s
.import ../../src/utils.s
.import ../../src/dot.s

# static values for testing
.data
m0: .word 1 2 3 4 5 6 7 8 9
# m1: .word 1 2 3 4 5 6 7 8 9
d: .word 0 0 0 0 0 0 0 0 0 # allocate static space for output
# m0: .word 1 2 3 4 5 6
m1: .word 1 1 1
# d: .word 0
.text
main:
    # Load addresses of input matrices (which are in static memory), and set their dimensions
    la a0, m0
    li a1, 3
    li a2, 3
    la a3, m1
    li a4, 3
    li a5, 1
    la a6, d
    # Call matrix multiply, m0 * m1
    jal ra, matmul
    la a0, d
    li a1, 3
    li a2, 1
    # Print the output (use print_int_array in utils.s)
    jal ra, print_int_array
    # Exit the program
    jal exit