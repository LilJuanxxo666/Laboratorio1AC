.data
    prompt: .asciiz "Ingrese un numero en radianes: "
    result: .asciiz "El seno es: "
    newline: .asciiz "\n"
    pi: .double 3.141592653589793
    two_pi: .double 6.283185307179586
    terms: .word 10  
.text
.globl main

main:
    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 7  
    syscall
    mov.d $f12, $f0  

    # Reducir x al rango [0, 2pi]
    jal reduce_range

    # Calcular seno con la serie de Taylor
    jal sin_taylor

    # Mostrar resultado
    li $v0, 4
    la $a0, result
    syscall

    li $v0, 3
    mov.d $f12, $f0
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 10
    syscall

reduce_range:
    la $t0, two_pi
    l.d $f2, 0($t0)

reduce_loop_neg:
    c.lt.d $f12, $f0
    bc1f reduce_loop_pos
    add.d $f12, $f12, $f2
    j reduce_loop_neg

reduce_loop_pos:
    c.lt.d $f12, $f2
    bc1t end_reduce
    sub.d $f12, $f12, $f2
    j reduce_loop_pos

end_reduce:
    jr $ra

sin_taylor:
    # sum = x
    mov.d $f0, $f12

    # term = x
    mov.d $f2, $f12

    # Configurar número de términos
    la $t2, terms
    lw $t2, 0($t2)   # t2 = número de iteraciones
    li $t3, 1        # k = 1 (siguiente término)

loop_series:
    neg.d $f4, $f12       
    mul.d $f4, $f4, $f12

    sll $t5, $t3, 1    
    addi $t6, $t5, 1   
    mtc1 $t5, $f6        
    cvt.d.w $f6, $f6  
    mtc1 $t6, $f8
    cvt.d.w $f8, $f8   


    mul.d $f2, $f2, $f4

    mul.d $f6, $f6, $f8  
    div.d $f2, $f2, $f6

    add.d $f0, $f0, $f2

    addi $t3, $t3, 1

    addi $t2, $t2, -1
    bgtz $t2, loop_series

    jr $ra
