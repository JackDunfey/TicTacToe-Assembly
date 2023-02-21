.data 0x10000000
    board: .ascii "_________" # _*9
    prompt: .asciiz "Enter a squares index (1-9): "
    O: .byte 0x4f # "O"
    X: .byte 0x58 # "X"
    _: .byte 0x5f # "_"

# s0 = board
# s1 = turn
# s2 = last move
# s3 = O
# s4 = X
# s5 = _

# a0, a1, a2 check board

.text
    main:
        la $s0, board
        li $s1, 0
        
        la $s3, O
        lb $s3, ($s3)
        la $s4, X
        lb $s4, ($s4)
        la $s5, _
        lb $s5, ($s5)

        loop:
            jal get_input
            move $s2, $v0

            add $t0, $s0, $s2
            beq $s1, $zero, _O
            _X:
                sb $s4, ($t0)
                bne $s1, $zero, DONE
            _O:
                sb $s3, ($t0)
            DONE:

            jal print_board

            move $a0, $s3
            jal check_win
            bne $v0, $zero, O_WON

            move $a0, $s4
            jal check_win
            bne $v0, $zero, X_WON
            
            xori $s1, $s1, 1
            j loop

        O_WON:
            li $v0, 11
            move $a0, $s3
            j PRINT
        X_WON:
            li $v0, 11
            move $a0, $s4
        PRINT:
            syscall

        li $v0, 10
        syscall

    print_board:
        move $t0, $zero
        outer:
            move $t1, $zero
            inner:
                li $v0, 11

                # Get board @ index
                    add $a0, $t0, $t0
                    add $a0, $a0, $t0
                    add $a0, $a0, $t1
                    add $a0, $s0, $a0 # a0 = s0 + 3 * t0 + t1
                    lb $a0, ($a0)
                
                syscall
                li $a0, 32
                syscall

                addi $t1, $t1, 1
                slti $t2, $t1, 3
                bne $t2, $zero, inner
            
            li $a0, 10
            syscall

            addi $t0, $t0, 1
            slti $t1, $t0, 3
            bne $t1, $zero, outer
        
        jr $ra
        nop

    check_single_win:
        add $a0, $a0, $s0
        lb $a0, ($a0)
        bne $a0, $a3, FALSE
        
        add $a1, $a1, $s0
        lb $a1, ($a1)
        bne $a1, $a3, FALSE
        
        add $a2, $a2, $s0
        lb $a2, ($a2)
        bne $a2, $a3, FALSE
        
        li $v0, 1
        jr $ra
        nop
        
        FALSE:
            move $v0, $zero
            jr $ra
            nop

    check_win:
        move $t9, $ra
        move $v0, $zero
        move $a3, $a0

        li $a0, 0
        li $a1, 1
        li $a2, 2
        jal check_single_win
        bne $v0, $zero, TRUE

        li $a0, 3
        li $a1, 4
        li $a2, 5
        jal check_single_win
        bne $v0, $zero, TRUE

        li $a0, 6
        li $a1, 7
        li $a2, 8
        jal check_single_win
        bne $v0, $zero, TRUE
    
        li $a0, 0
        li $a1, 3
        li $a2, 6
        jal check_single_win
        bne $v0, $zero, TRUE

        li $a0, 1
        li $a1, 4
        li $a2, 7
        jal check_single_win
        bne $v0, $zero, TRUE

        li $a0, 2
        li $a1, 5
        li $a2, 8
        jal check_single_win
        bne $v0, $zero, TRUE
    
        li $a0, 0
        li $a1, 4
        li $a2, 8
        jal check_single_win
        bne $v0, $zero, TRUE

        li $a0, 2
        li $a1, 4
        li $a2, 6
        jal check_single_win
        bne $v0, $zero, TRUE

        move $v0, $zero
        jr $t9
        nop

        TRUE:
            li $v0, 1
            jr $t9
            nop
    

    get_input:
        li $v0, 4
        la $a0, prompt
        syscall
        li $v0, 5
        syscall

        # t2 = input
            addi $t2, $v0, -1
        
        # t3 = board at index 
            add $t3, $s0, $t2
            lb $t3, ($t3)

        # Validate input
            bne $t3, $s5, get_input
            slt $t4, $t2, $zero
            bne $t4, $zero, get_input
            slti $t4, $t2, 9
            beq $t4, $zero, get_input

        move $v0, $t2
        jr $ra
        nop