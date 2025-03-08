#Rectilineo uniforme
.data
	#CAPA DE MRU
	menuMRU:	.asciiz "\nQue variable quieres hallar\n1.Distancia\n2.Velocidad\n3.Tiempo\nIngrese: "
	ingreseDistancia:	.asciiz "Ingrese valor de distancia(m): "
	ingreseVelocidad:	.asciiz "Ingrese valor de velocidad(m/s): "
	ingreseTiempo:	.asciiz "Ingrese valor de tiempo(s): "
			
	IngresaValor:	.asciiz "Ingrese un valor: "
	msgRespuesta: .asciiz "El resultado es: "
.text
MRU:
	li $v0, 4
	la $a0, menuMRU
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0
	
	bge $t0, 1, distanciaMRU
	bge $t0, 2, velocidadMRU
	bge $t0, 3, tiempoMRU
	
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
	
	
	j imprimirResultado
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
	
	j imprimirResultado 
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
	
	div.s $f12,$f0,$f2
	
	j imprimirResultado

imprimirResultado:
	li $v0, 4
	la $a0, msgRespuesta
	syscall
	li $v0, 3
	syscall
	
	
	
