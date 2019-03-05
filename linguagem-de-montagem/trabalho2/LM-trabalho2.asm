section .data
	msg db "Digite um valor: "
	msg_L equ $-msg
	msg2 db "Maior ou igual a 100"
	msg2_L equ $-msg2

section .bss
	num resb 5
	res resb 5
	aux resb 1
	cont resb 1

section .text
	global _start
		
imprime:
	mov eax, 4 			;SYS_WRITE
	mov ebx, 1 			;STDOUT (Terminal)
	mov ecx,msg 			;”Digite um número: “
	mov edx,msg_L			;18
	int 80h 			;SYS_CALL
	ret				;return
	
transforma_numerico:	
	mul ecx			 	;multiplica o registrador eax por 10, para somar com o próximo número
	mov edx,0 			;zerar o registrador edx que será usado para guardar o valor de uma posição de 'num'
	mov dl,[num+ebx] 		;atribuir uma posição da variável 'num' para o registrador dl (8 bits)
	sub dl,'0'			;transformar para valor numérico
	add eax,edx 			;adicionar valor da posição 'num+ebx' em eax
	inc ebx 			;incrementar o contador
	cmp [num+ebx], byte 10		;comparar a posição de 'num' com '\n'(10) que será a condição de parada
	jne transforma_numerico 	;se [num+ebx] não for igual a '\n'(10) então volta para label tranforma_numerico	
	ret

transforma_caractere:
	mov edx,0			;zerar resto
	div ecx				;dividir edx:eax por 10
	add dl,'0'			;transformar o resto em caractere
	mov [res+ebx],dl		;colocar o resto em resultado
	inc ebx				;incrementar contador
	cmp eax,0			;comparar quociente com 0
	jne transforma_caractere	;se não for igual continua dividindo
	ret
	
imprimir_res:
	dec ebx			;decrementar contador
	mov al,[res+ebx]		;transferir caractere do resultado
	mov [aux],al		;para uma variável auxiliar
	mov [cont],ebx		;guardar contador
	mov eax,4			;SYS_WRITE
	mov ebx,1			;STDOUT
	mov ecx,aux			;posição do resultado
	mov edx,1			;1 byte do resultado
	int 80h			;interrupção
	mov ebx,[cont]		;retornar contador
	cmp ebx,0			;comparar com 0 (primeiro caractere do resultado)
	jne imprimir_res		;se não for igual a 0 continuar imprimindo
	ret
	
	
multiplica:
	mul eax	
	ret			
	
_start:
	;IMPRIME NA TELA
	call imprime		

	;LE ENTRADA
	mov eax, 3 			;SYS_READ
	mov ebx, 0 			;STDIN (Terminal)
	mov ecx, num 			;num = (entrada)
	mov edx, 5 			;tamanho = 2 bytes
	int 80h 			;SYS_CALL	
	
	mov ebx,0 			;zerar registrado ebx que será usado como contador
	mov eax,0 			;zerar registrador eax que será usado para guardar o valor numérico de num
	mov ecx,10			;atribuir 10 para o registrador ecx que será usado para a multiplicação
	
	call transforma_numerico
	
	cmp eax,100
	jl mult
	
	;IMPRIME PRIMEIRA COLUNA
	mov eax, 4 			;SYS_WRITE
	mov ebx, 1 			;STDOUT (Terminal)
	mov ecx, msg2	 		;”Digite um número: “
	mov edx, msg2_L			;18
	int 80h 

	mov eax, 1 ;SYS_EXIT
	mov ebx, 0 ;sem erros
	int 80h ;SYS_CALL
	
	mult:
	call multiplica
	call transforma_caractere
	call imprimir_res
	mov eax, 1 ;SYS_EXIT
	mov ebx, 0 ;sem erros
	int 80h ;SYS_CALL
	
	
