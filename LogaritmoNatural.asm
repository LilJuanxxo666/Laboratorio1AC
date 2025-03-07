.data
prompt: .asciiz "Ingrese un numero (se hara positivo si es negativo): "
output: .asciiz "El ln(x) aproximado es: "
newline: .asciiz "\n"

.text
.globl main

main:
    # Solicitar el valor de x
    li $v0, 4
    la $a0, prompt
    syscall

    # Leer double
    li $v0, 7
    syscall
    mov.d $f12, $f0   # Guardar x en $f12

    # Si x < 0 => x = -x
    li $t0, 0
    mtc1 $t0, $f2
    cvt.d.w $f2, $f2
    c.lt.d $f12, $f2
    bc1f make_positive_done
    neg.d $f12, $f12
make_positive_done:
    jal ln_main

    # Imprimir resultado
    li $v0, 4
    la $a0, output
    syscall

    li $v0, 3
    mov.d $f12, $f0
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    # Salir
    li $v0, 10
    syscall

ln_main:

    li $t0, 2
    mtc1 $t0, $f4
    cvt.d.w $f4, $f4
    # ln(2) en f8 
    li $t0, 693147    # *1e-6 => ~0.693147
    mtc1 $t0, $f8
    cvt.d.w $f8, $f8
    li $t2, 1000000
    mtc1 $t2, $f10
    cvt.d.w $f10, $f10
    div.d $f8, $f8, $f10  # f8 = ~0.693147

    li $t1, 0        # contador

normalize_up:
    c.lt.d $f4, $f12    # if (2 < x)
    bc1f normalize_down
    div.d $f12, $f12, $f4
    addi $t1, $t1, 1
    j normalize_up

normalize_down:
    # si x < 1 => multiplicar x*2 y restar del contador
    li $t3, 1
    mtc1 $t3, $f6
    cvt.d.w $f6, $f6

check_x_lt_1:
    c.lt.d $f12, $f6  # if (x < 1.0)
    bc1f do_ln
    mul.d $f12, $f12, $f4
    addi $t1, $t1, -1
    j check_x_lt_1

do_ln:
    # y = x - 1
    li $t9, 1
    mtc1 $t9, $f2
    cvt.d.w $f2, $f2
    sub.d $f2, $f12, $f2  # f2 = (x-1)

     li $t4, 50
   mtc1 $zero, $f0
    cvt.d.w $f0, $f0
    # term = y
    mov.d $f6, $f2

    li $t4, 30
    li $t5, 1   # k
    li $t6, 1   # sign

ln_loop:
    # current = term / k
    mtc1 $t5, $f10
    cvt.d.w $f10, $f10
    div.d $f12, $f6, $f10  # f12 = actual

    beq $t6, $zero, do_sub
    add.d $f0, $f0, $f12   # sum += actual
    li $t6, 0
    b next_l
do_sub:
    sub.d $f0, $f0, $f12   # sum -= actual
    li $t6, 1

next_l:
    # term *= y
    mul.d $f6, $f6, $f2
    addi $t5, $t5, 1
    addi $t4, $t4, -1
    bgtz $t4, ln_loop

    mtc1 $t1, $f12
    cvt.d.w $f12, $f12
    mul.d $f12, $f12, $f8
    add.d $f0, $f0, $f12

    jr $ra
