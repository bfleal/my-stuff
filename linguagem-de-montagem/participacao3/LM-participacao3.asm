section .data
	msg db "Digite um termo para a obter o valor da sequencia de Fibonacci (1-9) : "	;mensagem requisitando a entrada por parte do usuário
	msg_L equ $-msg

section .bss
	termo resb 1			;recebe o termo a ser encontrado na sequência
  	res resb 2			;armazena o respectivo valor de caracter em res
	aux resb 1			;variável auxiliar que recebe cada caractere do resultado (res) a ser imprimido
	cont resb 1			;controla a quantidade de caractere a ser imprimido no processo de impressão de res

section .text
	global _start
		
imprime:
	mov eax, 4 			;SYS_WRITE
	mov ebx, 1 			;STDOUT (Terminal)
	mov ecx,msg 			;”Digite um número: “
	mov edx,msg_L			;18
	int 80h 			;SYS_CALL
	ret				;return

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
	dec ebx				;decrementar contador
	mov al,[res+ebx]		;transferir caractere do resultado
	mov [aux],al			;para uma variável auxiliar
	mov [cont],ebx			;guardar contador
	mov eax,4			;SYS_WRITE
	mov ebx,1			;STDOUT
	mov ecx,aux			;posição do resultado
	mov edx,1			;1 byte do resultado
	int 80h				;interrupção
	mov ebx,[cont]			;retornar contador
	cmp ebx,0			;comparar com 0 (primeiro caractere do resultado)
	jne imprimir_res		;se não for igual a 0 continuar imprimindo
	ret

sair:
	mov ebx,0 			;zerar registrado ebx que será usado como contador de caractere em transforma_caractere
	mov ecx,10			;atribuir 10 para o registrador ecx que será usado para a divisão no processo de transformação para caracter

	call transforma_caractere	;transforma o valor numérico contido em eax em seu respectivo representante em caractere
	call imprimir_res		;imprime res, valor corresponde o termo informado de Fibonacci

	mov eax,1			;encerra a execução do programa
	int 80h
	
fibonacci:
	cmp ecx, 1			;verifica se o termo requisitado é o primeiro da sequência
	je sairFibonacci		;se sim, vai para a função de encerramento do programa
	  
	dec ecx				;se não, decrementa ecx - termo da sequência
	push eax			;empilha eax, valor do termo corrente da sequência
	add eax, ebx			;eax = eax + ebx, soma do termo atual mais o anterior, gerando o próximo termo da sequência
	pop ebx				;desempilha ebx, termo anterior da sequência
	call fibonacci			;chama fibonacci recursivamente
	
	sairFibonacci:			;retorna e fluxo de execução inicial do programa
	ret			
	
_start:
	;IMPRIME NA TELA
	call imprime		

	;LE ENTRADA
	mov eax, 3 			;SYS_READ
	mov ebx, 0 			;STDIN (Terminal)
	mov ecx, termo 			;termo = (entrada)
	mov edx, 1 			;tamanho = 2 bytes
	int 80h 			;SYS_CALL	

	mov ecx, [termo]		;move o termo informado pelo usuário para ecx
	sub ecx, '0'			;transforma o termo, agora em ecx, em seu respectivo valor númerico
	
	mov ebx, 0			;ebx = 0, quarda o primeiro termo da sequência/valor do termo anterior ao atual
	mov eax, 1			;eax = 0, quardo o segundo termo da sequência/valor do termo atual
	call fibonacci
	
	mov ebx,0 			;zerar registrado ebx que será usado como contador do termo
	mov ecx,10			;atribuir 10 para o registrador ecx que será usado para a multiplicação
	call transforma_caractere	;chama a função transforma_caractere
	
	call imprimir_res		;chama a função imprimir_res
	
	mov eax, 1 			;SYS_EXIT
	mov ebx, 0 			;sem erros
	int 80h 			;SYS_CALL
	
	
	
