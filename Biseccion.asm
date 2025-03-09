.data
promptA:    .asciiz "Ingrese el valor de a: "
promptB:    .asciiz "Ingrese el valor de b: "
errorMsg:   .asciiz "Intervalo ingresado no valido.\n"
resultMsg:  .asciiz "La raiz encontrada es: "
tol:        .double 0.00000000000001
five:       .double 5.0
two:        .double 2.0
zero:       .double 0.0

.text
.globl main

main:
loop_main:
    # Pedir y leer a
    li $v0, 4
    la $a0, promptA
    syscall
    li $v0, 7
    syscall
    mov.d $f8, $f0        # a en $f8

    # Pedir y leer b
    li $v0, 4
    la $a0, promptB
    syscall
    li $v0, 7
    syscall
    mov.d $f10, $f0       # b en $f10

    # Calcular f(a) = a^2 - 5
    mul.d $f16, $f8, $f8
    l.d $f2, five
    sub.d $f16, $f16, $f2

    # Calcular f(b) = b^2 - 5
    mul.d $f18, $f10, $f10
    l.d $f2, five
    sub.d $f18, $f18, $f2

    # Validar que f(a) y f(b) tengan signos opuestos
    mul.d $f20, $f16, $f18   # producto f(a)*f(b)
    l.d $f22, zero
    c.lt.d $f20, $f22        # true if producto < 0
    bc1t continue_bisection
    li $v0, 4
    la $a0, errorMsg
    syscall


continue_bisection:
    # Inicializar c = a
    mov.d $f12, $f8

bisect_loop:
    # Condición de paro: (b-a)/2 <= tol
    sub.d $f26, $f10, $f8       # f26 = b - a
    l.d $f28, two
    div.d $f26, $f26, $f28      # f26 = (b-a)/2
    l.d $f24, tol
    c.le.d $f26, $f24
    bc1t bisection_done

    # c = (a + b)/2
    add.d $f12, $f8, $f10
    div.d $f12, $f12, $f28

    # Calcular f(c) = c^2 - 5
    mul.d $f30, $f12, $f12
    l.d $f2, five
    sub.d $f30, $f30, $f2

    # Si f(c)==0; salir del bucle
    l.d $f22, zero
    c.eq.d $f30, $f22
    bc1t bisection_done

    # Recalcular f(a) = a^2 - 5
    mul.d $f16, $f8, $f8
    l.d $f2, five
    sub.d $f16, $f16, $f2

    # Si f(a)*f(c) < 0, entonces b = c; de lo contrario, a = c
    mul.d $f14, $f16, $f30    
    c.lt.d $f14, $f22        
    bc1t update_b
    mov.d $f8, $f12
    j bisect_loop

update_b:
    mov.d $f10, $f12
    j bisect_loop

bisection_done:
    # Imprimir el resultado
    li $v0, 4
    la $a0, resultMsg
    syscall
    li $v0, 3
    mov.d $f12, $f12
    syscall

    
    li $v0, 10
    syscall
