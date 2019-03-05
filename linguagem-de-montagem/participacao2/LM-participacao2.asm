section .data
	msg db "Digite uma String de ate 4 caracteres: "	;mensagem requisitando a entrada por parte do usuário
	msg_L equ $-msg			;tamanho de msg
	msgIguais db "STRINGS IGUAIS"
	msgIguais_L equ $-msgIguais
	msgErroTamanho db "Erro no tamanho"
	msgErroTamanho_L equ $-msgErroTamanho
	msgCaractereDiferente db "Caracteres diferentes"
	msgCaractereDiferente_L equ $-msgCaractereDiferente


section .bss
	str1 resb 5			;armazena o valor recebido na entrada
	str2 resb 5			;armazena num*num
	cont1 resb 1		;contador da string 1
	cont2 resb 1		;contador da string 2

section .text
	global _start
	
_start:
	;LEITURA DA PRIMEIRA STRING 

	mov eax, 4 			;SYS_WRITE
	mov ebx, 1 			;STDOUT (Terminal)
	mov ecx,msg 			;”Digite um número: “
	mov edx,msg_L			;18
	int 80h 			;SYS_CALL


	;LE ENTRADA
	mov eax, 3 			;SYS_READ
	mov ebx, 0 			;STDIN (Terminal)
	mov ecx, str1 			;num = (entrada)
	mov edx, 5 			;tamanho = 2 bytes
	int 80h 			;SYS_CALL	


	;LEITURA DA SEGUNDA STRING
		;IMPRIME NA TELA A REQUISIÇÃO DE ENTRADA 

	mov eax, 4 			;SYS_WRITE
	mov ebx, 1 			;STDOUT (Terminal)
	mov ecx,msg 			;”Digite um número: “
	mov edx,msg_L			;18
	int 80h 			;SYS_CALL


	;LE ENTRADA
	mov eax, 3 			;SYS_READ
	mov ebx, 0 			;STDIN (Terminal)
	mov ecx, str2 			;num = (entrada)
	mov edx, 5 			;tamanho = 2 bytes
	int 80h 			;SYS_CALL	



	mov ebx,0
	conta_caractere_str1:
	cmp [str1+ebx],byte 10
	je mov_cont1
	inc ebx
	jmp conta_caractere_str1


	mov_cont1:

	mov [cont1], ebx


	
	mov ebx,0
	conta_caractere_str2:
	cmp [str2+ebx],byte 10
	je mov_cont2
	inc ebx
	jmp conta_caractere_str2


	mov_cont2:

	mov [cont2], ebx

	

	;COMPARACAO DOS TAMANHOS
	mov al,[cont1]
	mov bl,[cont2]
	cmp al,bl
	jne imprime_erro_tamanho

	;LOOP PARA COMPARAR OS CARACTERES
	mov ebx,0
	compara:
	mov al,[str1+ebx]
	cmp al,[str2+ebx]
	jne imprime_caracteres_diferentes
	cmp al, 10
	je imprime_iguais	
	inc ebx
	jmp compara
	
	imprime_iguais:
	mov eax,4
	mov ebx,1
	mov ecx, msgIguais
	mov edx, msgIguais_L
	int 80h
	jmp sair

	imprime_erro_tamanho:
	mov eax,4
	mov ebx,1
	mov ecx, msgErroTamanho
	mov edx,msgErroTamanho_L
	int 80h
	jmp sair

	

	imprime_caracteres_diferentes:
	mov eax,4
	mov ebx,1
	mov ecx,msgCaractereDiferente
	mov edx, msgCaractereDiferente_L
	int 80h
	
	

	sair:
	mov eax, 1 ;SYS_EXIT
	mov ebx, 0 ;sem erros
	int 80h ;SYS_CALL
	







