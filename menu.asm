.data
	menu: .asciiz "\nSelecciona una opción: \n 1. Movimiento Rectilineo Uniforme \n 2. Logaritmo Natural \n 3. Seno \n 4. Biseccion \n 5. Metodo Newton \n 6.Salir \n\n Ingresa el valor: "
	msgSalir: .asciiz "Se ha terminado el aplicativo."	
	msgRespuesta: .asciiz "El resultado es: "
	
.text
	
j main

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
	
MRU:


logaritmo:


seno:


biseccion:


newton:
	
	
imprimirResultado:
	li $v0, 4
	la $a0, msgRespuesta
	syscall
	li $v0, 3
	syscall
	
	jr $ra
	
salir:
	li $v0, 4 #Msg
	la $a0, msgSalir
	syscall