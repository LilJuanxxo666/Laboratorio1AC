.data
	#Menu inicial
	menu: .asciiz "\nSelecciona una opción: \n 1. Movimiento Rectilineo Uniforme \n 2. Logaritmo Natural \n 3. Seno \n 4. Biseccion \n 5. Metodo Newton \n 6. Salir \n\n Ingresa el valor: "
	msgSalir: .asciiz "Se ha terminado el aplicativo."	
	IngresaValor:	.asciiz "Ingrese un valor: "
	newline: .asciiz "\n"
	#Menu y todo lo de MRU
	menuMRU:	.asciiz "\nQue variable quieres hallar\n1.Distancia\n2.Velocidad\n3.Tiempo\nIngrese: "
	ingreseDistancia:	.asciiz "Ingrese valor de distancia(m): "
	ingreseVelocidad:	.asciiz "Ingrese valor de velocidad(m/s): "
	ingreseTiempo:	.asciiz "Ingrese valor de tiempo(s): "
	msgRespuestaTiempo:	.asciiz "El resultado de tiempo(s) es: "
	msgRespuestaVelocidad:	.asciiz "El resultado de velocidad(m/s) es: "
	msgRespuestaDistancia:	.asciiz "El resultado de distancia(m) es: "
	msgErrorMRU: .asciiz "El valor ingresado es incorrecto. \n"
	#Menu Logaritmo
	ingreseLogaritmo: .asciiz "Ingrese un numero (se hara positivo si es negativo): "
	respuestaLogaritmo: .asciiz "El ln(x) aproximado es: "
	#Menu Seno y valores seno
	ingreseSeno: .asciiz "Ingrese un numero en radianes: "
    	respuestaSeno: .asciiz "El seno es: "
    	pi: .double 3.141592653589793
    	dos_pi: .double 6.283185307179586
    	term: .word 10  
    	#Menu biseccion y valores
    	ingreseA:    .asciiz "Ingrese el valor de a: "
	ingreseB:    .asciiz "Ingrese el valor de b: "
	msgErrorBise:   .asciiz "Intervalo ingresado no valido.\n"
	respuestaBise:  .asciiz "La raiz encontrada es: "
	tol:        .double 0.00000000000001
	cinco:       .double 5.0
	dos:        .double 2.0
	zero:       .double 0.0
	#Menu Metodo Newton
	ingreseNewton: .asciiz "Ingrese un numero para hallar raiz: "
	respuestaNewton: .asciiz "Aproximacion de la raiz: "
	
.text
.globl main

#Capa de Main--------------------------------------------------------------------------------------------------------

main:
	li $v0, 4
	la $a0, menu
	syscall
	
	li $v0, 5
	syscall
	move $t3, $v0
	
	beq $t3, 1, MRU
	beq $t3, 2, logaritmo
	beq $t3, 3, seno
	beq $t3, 4, biseccion
	beq $t3, 5, newton
	beq $t3, 6, salir

#Capa De MOVIMIENTO RECTILINEO UNIFORME-----------------------------------------------------------------------------
MRU:
	li $v0, 4
	la $a0, menuMRU
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0
	
	li $t1, 3
    	bgt $t0, $t1, error  # Si $t0 > 3, salta a error
	beq $t0, 1, distanciaMRU
	beq $t0, 2, velocidadMRU
	beq $t0, 3, tiempoMRU
	
	
error:
    	# Mostrar mensaje de error
    	li $v0, 4
    	la $a0, msgErrorMRU
    	syscall
    	
    	j MRU
#d=v*t	
distanciaMRU:
	#Ingresar Variable velocidad 
	li $v0, 4
	la $a0, ingreseVelocidad
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0
	
	mtc1 $t0, $f0
	cvt.d.w $f0, $f0
	
	#Ingresar Variable Tiempo 
	li $v0, 4
	la $a0, ingreseTiempo
	syscall
	
	li $v0, 5
	syscall
	move $t1, $v0	
	
	mtc1 $t1, $f2
	cvt.d.w $f2, $f2
	
	mul.d $f12, $f2, $f0	
	
	li $v0, 4
	la $a0, msgRespuestaDistancia
	syscall
	li $v0, 3
	syscall
	li $v0, 4
    	la $a0, newline
    	syscall
	
	j valoresZero
#v=d/t
velocidadMRU:
	#Ingresar Variable distancia 
	li $v0, 4
	la $a0, ingreseDistancia
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0
	
	mtc1 $t0, $f0
	cvt.d.w $f0, $f0
	
	#Ingresar Variable Tiempo 
	li $v0, 4
	la $a0, ingreseTiempo
	syscall
	
	li $v0, 5
	syscall
	move $t1, $v0	
	
	mtc1 $t1, $f2
	cvt.d.w $f2, $f2
	
	div.d $f12,$f0,$f2
	
	li $v0, 4
	la $a0, msgRespuestaVelocidad
	syscall
	li $v0, 3
	syscall
	li $v0, 4
    	la $a0, newline
    	syscall
	
	j valoresZero
#t=d/v
tiempoMRU:
	#Ingresar Variable distancia 
	li $v0, 4
	la $a0, ingreseDistancia
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0
	
	mtc1 $t0, $f0
	cvt.d.w $f0, $f0
	
	#Ingresar Variable velocidad 
	li $v0, 4
	la $a0, ingreseVelocidad
	syscall
	
	li $v0, 5
	syscall
	move $t1, $v0	
	
	mtc1 $t1, $f2
	cvt.d.w $f2, $f2
	
	div.d $f12,$f0,$f2
	
	li $v0, 4
	la $a0, msgRespuestaTiempo
	syscall
	li $v0, 3
	syscall
	li $v0, 4
    	la $a0, newline
    	syscall
	
	j valoresZero
	
#Capa de Logaritmo---------------------------------------------------------------------------------------------
logaritmo:
	 # Solicitar el valor de x
    	li $v0, 4
    	la $a0, ingreseLogaritmo
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
    	la $a0, respuestaLogaritmo
    	syscall

    	li $v0, 3
    	mov.d $f12, $f0
    	syscall

    	li $v0, 4
    	la $a0, newline
    	syscall
    	
    	j valoresZero

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

    	li $t4, 100000 # numero ciclos
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


#Capa de Seno--------------------------------------------------------------------------------------------------
seno:
	li $v0, 4
	la $a0, ingreseSeno
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
    	la $a0, respuestaSeno
    	syscall

    	li $v0, 3
    	mov.d $f12, $f0
    	syscall

    	li $v0, 4
    	la $a0, newline
    	syscall

	j valoresZero

reduce_range:
    	la $t0, dos_pi
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
    	la $t2, term
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


#Capa de Biseccion---------------------------------------------------------------------------------------------
biseccion:
	loop_main:
    	# Pedir y leer a
    	li $v0, 4
    	la $a0, ingreseA
    	syscall
    	li $v0, 7
    	syscall
    	mov.d $f8, $f0        # a en $f8

    	# Pedir y leer b
    	li $v0, 4
    	la $a0, ingreseB
    	syscall
    	li $v0, 7
    	syscall
    	mov.d $f10, $f0       # b en $f10

    	# Calcular f(a) = a^2 - 5
    	mul.d $f16, $f8, $f8
    	l.d $f2, cinco
    	sub.d $f16, $f16, $f2

    	# Calcular f(b) = b^2 - 5
    	mul.d $f18, $f10, $f10
    	l.d $f2, cinco
    	sub.d $f18, $f18, $f2

    	# Validar que f(a) y f(b) tengan signos opuestos
    	mul.d $f20, $f16, $f18   # producto f(a)*f(b)
    	l.d $f22, zero
    	c.lt.d $f20, $f22        # true if producto < 0
    	bc1t continue_bisection
    	li $v0, 4
    	la $a0, msgErrorBise
    	syscall


continue_bisection:
    	# Inicializar c = a
    	mov.d $f12, $f8

bisect_loop:
    	# Condición de paro: (b-a)/2 <= tol
    	sub.d $f26, $f10, $f8       # f26 = b - a
    	l.d $f28, dos
    	div.d $f26, $f26, $f28      # f26 = (b-a)/2
    	l.d $f24, tol
    	c.le.d $f26, $f24
    	bc1t bisection_done

    	# c = (a + b)/2
    	add.d $f12, $f8, $f10
    	div.d $f12, $f12, $f28

    	# Calcular f(c) = c^2 - 5
    	mul.d $f30, $f12, $f12
    	l.d $f2, cinco
    	sub.d $f30, $f30, $f2

    	# Si f(c)==0; salir del bucle
    	l.d $f22, zero
    	c.eq.d $f30, $f22
    	bc1t bisection_done

    	# Recalcular f(a) = a^2 - 5
    	mul.d $f16, $f8, $f8
    	l.d $f2, cinco
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
    	la $a0, respuestaBise
    	syscall
    	li $v0, 3
    	mov.d $f12, $f12
    	syscall
    	li $v0, 4
    	la $a0, newline
    	syscall

    
    	j valoresZero


#Capa de newton---------------------------------------------------------------------------------------------
newton:
    	# Mostrar ingrese
    	li $v0, 4
    	la $a0, ingreseNewton
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
    	la $a0, respuestaNewton
    	syscall

    	li $v0, 3
    	mov.d $f12, $f2
    	syscall

    	li $v0, 4
    	la $a0, newline
    	syscall

    	j valoresZero


valoresZero:
	
	# Limpiar registros usados
    	move $zero, $t1
    	move $zero, $t2
    	move $zero, $t3
    	move $zero, $t4
    	move $zero, $t5
    	move $zero, $t6
    	move $zero, $t9
    	mtc1 $zero, $f0
    	mtc1 $zero, $f2
    	mtc1 $zero, $f4
    	mtc1 $zero, $f6
    	mtc1 $zero, $f8
    	mtc1 $zero, $f10
    	mtc1 $zero, $f12
    	
    	j main
	
salir:
	li $v0, 4 #Msg
	la $a0, msgSalir
	syscall
	
	li $v0, 10
	syscall
