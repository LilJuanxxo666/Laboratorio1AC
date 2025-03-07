.data
prompt: .asciiz "Ingrese un numero para hallar raiz: "
output: .asciiz "Aproximacion de la raiz: "
newline: .asciiz "\n"

.text
.globl main

main:
    # Mostrar prompt
    li $v0, 4
    la $a0, prompt
    syscall

    # Leer double c
    li $v0, 7
    syscall
    mov.d $f12, $f0   # c en f12

    # x = c/2 para iniciar
    div.d $f2, $f12, $f0   # f0 contiene 2.0 => lo cargamos primero
    # Cargar 2.0 en f0
    li $t0, 2
    mtc1 $t0, $f0
    cvt.d.w $f0, $f0
    div.d $f2, $f12, $f0   # x0 = c / 2 => f2

    # Iterar 10 veces
    li $t1, 10

newton_loop:
    # f(x) = x^2 - c
    mul.d $f4, $f2, $f2  # x^2
    sub.d $f6, $f4, $f12 # f(x)

    # f'(x) = 2x
    # Cargar 2.0 en f8
    li $t2, 2
    mtc1 $t2, $f8
    cvt.d.w $f8, $f8
    mul.d $f8, $f8, $f2  # 2*x

    # x = x - f(x)/f'(x)
    div.d $f10, $f6, $f8
    sub.d $f2, $f2, $f10

    addi $t1, $t1, -1
    bgtz $t1, newton_loop

    # Mostrar resultado en f2
    li $v0, 4
    la $a0, output
    syscall

    li $v0, 3
    mov.d $f12, $f2
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 10
    syscall
