.data
m: .space 4
n: .space 4
res: .space 4
str: .asciiz "Programa Ackermann \nDigite os parametros m e n para calcular A(m, n) ou -1 para abortar a execucao\n"
output: .asciiz "A(\0,\0)="

.text
.globl main

main:
	la 	$a0, str 		# $a0 = mensagem
	li	$v0, 4		
	syscall			# imprime $a0
	li 	$v0, 5		
	syscall			# le m
	move 	$a0, $v0 		# a0 = m
	li 	$v0, 5		 
	syscall			# le n
	move 	$a1, $v0 		# a1 = n
	blt 	$a0, $zero, fim 	# se m for negativo, encerra o programa
	addi 	$sp, $sp, -12	# abre 3 posicoes na pilha
	sw	$a0, 8($sp)		# salva m inicial na pilha
	sw	$a1, 4($sp)		# salva n inicial na pilha
	sw 	$ra, 0($sp) 	# salvando endereco de retorno (ra_main)
	jal 	ack 			# chamando a funcao para calcular
	lw	$s0, 8($sp)		# recupera m inicial da pilha
	lw	$s1, 4($sp)		# recupera n inicial da pilha
	lw	$ra, 0($sp)		# recupera $ra da pilha
	sw 	$v0, res 		# res = ack(m, n)
	addi 	$sp, $sp, 12	# fecha 3 posicoes na pilha
	move 	$s2, $v0 		# a0 = res
	j       imprime
	
	
	j	fim			# encerra o programa
	
ack:
	bne     $a0, $0, rec	# se m != 0 salta para rec
	addi    $v0, $a1, 1	# senao retorna n + 1
	jr	$ra			# retorna
	
rec:
	beq	$a1, $0, rec2	# se m==0 vai para rec2
					# senao
	addi	$a1, $a1, -1	# a1 = n-1
	
	addi	$sp, $sp, -12	# abre 3 posicoeses na pilha
	sw	$a0, 8($sp)		# salva m na pilha
	sw	$a1, 4($sp)		# salva n na pilha
	sw	$ra, 0($sp)		# salva $ra na pilha
	
	jal	ack			# ack(m, n-1)
	move 	$a1, $v0		# n = ack(m, n-1)
	lw	$a0, 8($sp)		# recupera m da pilha
	addi	$a0, $a0, -1	# m = m-1
	
	sw	$a0, 8($sp)		# salva m na pilha
	sw	$a1, 4($sp)		# salva n na pilha
	
	jal	ack			# ack(m-1, ack(m, n-1))
	
	lw 	$ra, 0($sp)		# recupera $ra
	addi	$sp, $sp, 12	# fecha 3 posicoes na pilha

	jr	$ra			# retorna
	
	
	
rec2:
	addi	$sp, $sp, -12	# abre 3 posicoes na pilha
	sw	$a0, 8($sp)		# salva m na pilha
	sw	$a1, 4($sp)		# salva n na pilha
	sw	$ra, 0($sp)		# salva $ra na pilha
	
	addi	$a0, $a0, -1	# m = m-1
	li	$a1, 1		# n = 1
	jal 	ack			# ack(m-1, 1)
	
	lw	$a0, 8($sp)		# recupera m da pilha
	lw	$a1, 4($sp)		# recupera n da pilha
	lw	$ra, 0($sp)		# recupera $ra da pilha
	addi	$sp, $sp, 12	# fecha 3 posicoes na pilha
	jr	$ra			# retorna
	
imprime:
	li	$v0, 4		
	la	$a0, output	
	syscall			# imprime "A("
	li	$v0, 1		
	move	$a0, $s0	
	syscall 			# imprime m
	li	$v0, 4		
	la	$a0, output+3	
	syscall			# imprime ","
	li	$v0, 1		
	move	$a0, $s1	
	syscall 			# imprime n
	li	$v0, 4		
	la	$a0, output+5	
	syscall			# imprime ")="
	li	$v0, 1		
	move	$a0, $s2	
	syscall			# imprime o resultado
	
fim:
	li	$v0, 10		
	syscall			# exit
