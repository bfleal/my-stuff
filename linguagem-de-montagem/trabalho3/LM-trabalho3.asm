section .data
	msg db "Digite uma String : "	;mensagem requisitando a entrada por parte do usuário
	msg_L equ $-msg					;tamanho de msg



section .bss
	str1 resb 100					;armazena o valor recebido na entrada
	contaEspaco resb 4				;contador de espaços
	res resb 5						;armazena o valor em caracter de contaEspaco
	aux resb 1						;variável auxiliar que recebe cada caractere do resultado (res) a ser imprimido
	cont resb 4						;controla a quantidade de caractere a ser imprimido no processo de impressão de res

section .text
	global _start
	
_start:
	;LEITURA DA PRIMEIRA STRING 
	mov eax, 4 						;SYS_WRITE
	mov ebx, 1 						;STDOUT (Terminal)
	mov ecx,msg 					;"Digite uma String : 
	mov edx,msg_L					;msg_L 
	int 80h 						;SYS_CALL


	;LE ENTRADA
	mov eax, 3 						;SYS_READ
	mov ebx, 0 						;STDIN (Terminal)
	mov ecx, str1 					;str1 = (entrada)
	mov edx, 100 					;tamanho máximo = 100 bytes
	int 80h 						;SYS_CALL	

	mov eax, 0						;eax = 0
	mov ebx, 0						;ebx = 0

	
	;VERIFICA ESPAÇOS EM BRANCO EM str1	
	verificaEspaco:
		cmp [str1+ebx], byte 10		;verifica se o caracter currente de str1+ebx é igual a '\n'
		je sair		

		cmp [str1+ebx], byte ' '	;verifica se o caracter currente de str1+ebx é igual a ' '
		je incrementaEspaco

		inc ebx						;incrementa o controlador de posição de str1
		jmp verificaEspaco

	jmp sair	
	

;CONTA ESPAÇOS EM BRANCO
incrementaEspaco:
	inc eax							;incrementa eax, quantidade de espaços
	inc ebx							;incrementa ebx, posição na string
	jmp verificaEspaco


;ENCERRA E EXECUÇÃO DO PROGRAMA
sair:
	inc eax							;adiciona 1 a quantidade de espaços
	mov ebx,0 						;zerar registrado ebx que será usado como contador
	mov ecx,10						;atribuir 10 para o registrador ecx que será usado para a multiplicação

	call transforma_caractere		;transforma a quantidade de espaços em branco contados em seu respectivo caracter
	call imprimir_res				;imprime res, quantidade de caracteres em branco

	mov eax,1
	int 80h

;;FUNÇÕES
transforma_caractere:
	mov edx,0						;zerar resto
	div ecx							;dividir edx:eax por 10
	add dl,'0'						;transformar o resto em caractere
	mov [res+ebx],dl				;colocar o resto em resultado
	inc ebx							;incrementar contador
	cmp eax,0						;comparar quociente com 0
	jne transforma_caractere		;se não for igual continua dividindo
	ret
	
imprimir_res:
	dec ebx							;decrementar contador
	mov al,[res+ebx]				;transferir caractere do resultado
	mov [aux],al					;para uma variável auxiliar
	mov [cont],ebx					;guardar contador
	mov eax,4						;SYS_WRITE
	mov ebx,1						;STDOUT
	mov ecx,aux						;posição do resultado
	mov edx,1						;1 byte do resultado
	int 80h							;interrupção
	mov ebx,[cont]					;retornar contador
	cmp ebx,0						;comparar com 0 (primeiro caractere do resultado)
	jne imprimir_res				;se não for igual a 0 continuar imprimindo
	ret

