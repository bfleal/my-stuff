;Bruno Ferreira Leal RA:151042161
;Paulo Henrique Paim dos Santos RA: 151040745

section .data
	msg db "Digite uma String de ate 4 caracteres: "	;mensagem requisitando a entrada por parte do usuário
	msg_L equ $-msg			;tamanho de msg


section .bss
	str1 resb 5			;armazena o valor recebido na entrada
	str2 resb 5			;armazena num*num
	cont1 resb 1		;contador da string 1
	cont2 resb 1		;contador da string 2

section .text
	global _start
	
_start:
	;LEITURA DA PRIMEIRA STRING 
	imprime:
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
	imprime:
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
	cmp str1,byte 10
	je mov_cont1
	inc ebx
	jmp conta_caractere_str1




	mov_cont1:
	mov cont1, ebx

	;IMPRIME CONT1
	mov eax,4
	mov ebx,1
	mov ecx,cont1
	mov edx, 1
	int 80h

	mov eax, 1 ;SYS_EXIT
	mov ebx, 0 ;sem erros
	int 80h ;SYS_CALL
	







