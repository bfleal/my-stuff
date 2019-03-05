section .data
	msg db "Digite um valor: "
	msg_L equ $-msg

	msg2 db 10, "Matriz - Coluna [0]:", 10
	msg_L2 equ $-msg2

section .bss
	num resw 1
	vetor resw 9

section .text
	global _start
		
imprime:
	mov eax, 4 			;SYS_WRITE
	mov ebx, 1 			;STDOUT (Terminal)
	mov ecx,msg 		;”Digite um número: “
	mov edx,msg_L		;18
	int 80h 			;SYS_CALL
	ret					;return

_start:
	;IMPRIME NA TELA
	call imprime		

	;LE ENTRADA
	mov eax, 3 			;SYS_READ
	mov ebx, 0 			;STDIN (Terminal)
	mov ecx, num 		;num = (entrada)
	mov edx, 2 			;tamanho = 2 bytes
	int 80h 			;SYS_CALL
	
	;ARMAZENA VALOR 1
	mov eax, [num]
	mov [vetor], eax

	;IMPRIME NA TELA
	call imprime		

	;LE ENTRADA
	mov eax, 3 			;SYS_READ
	mov ebx, 0 			;STDIN (Terminal)
	mov ecx, num 		;num = (entrada)
	mov edx, 2 			;tamanho = 2 bytes
	int 80h 			;SYS_CALL

	;ARMAZENA VALOR 2
	mov eax, [num]
	mov [vetor+2], eax

	;IMPRIME NA TELA
	call imprime		

	;LE ENTRADA
	mov eax, 3 			;SYS_READ
	mov ebx, 0 			;STDIN (Terminal)
	mov ecx, num 		;num = (entrada)
	mov edx, 2 			;tamanho = 2 bytes
	int 80h 			;SYS_CALL

	;ARMAZENA VALOR 3
	mov eax, [num]
	mov [vetor+4], eax

	;IMPRIME NA TELA
	call imprime		

	;LE ENTRADA
	mov eax, 3 			;SYS_READ
	mov ebx, 0 			;STDIN (Terminal)
	mov ecx, num 		;num = (entrada)
	mov edx, 2 			;tamanho = 2 bytes
	int 80h 			;SYS_CALL

	;ARMAZENA VALOR 4
	mov eax, [num]
	mov [vetor+6], eax

	;IMPRIME NA TELA
	call imprime		

	;LE ENTRADA
	mov eax, 3 			;SYS_READ
	mov ebx, 0 			;STDIN (Terminal)
	mov ecx, num 			;num = (entrada)
	mov edx, 2 			;tamanho = 2 bytes
	int 80h 			;SYS_CALL

	;ARMAZENA VALOR 5
	mov eax, [num]
	mov [vetor+8], eax

	;IMPRIME NA TELA
	call imprime		

	;LE ENTRADA
	mov eax, 3 			;SYS_READ
	mov ebx, 0 			;STDIN (Terminal)
	mov ecx, num 			;num = (entrada)
	mov edx, 2 			;tamanho = 2 bytes
	int 80h 			;SYS_CALL

	;ARMAZENA VALOR 6
	mov eax, [num]
	mov [vetor+10], eax

	;IMPRIME NA TELA
	call imprime		

	;LE ENTRADA
	mov eax, 3 			;SYS_READ
	mov ebx, 0 			;STDIN (Terminal)
	mov ecx, num 			;num = (entrada)
	mov edx, 2 			;tamanho = 2 bytes
	int 80h 			;SYS_CALL

	;ARMAZENA VALOR 7
	mov eax, [num]
	mov [vetor+12], eax

	;IMPRIME NA TELA
	call imprime		

	;LE ENTRADA
	mov eax, 3 			;SYS_READ
	mov ebx, 0 			;STDIN (Terminal)
	mov ecx, num 		;num = (entrada)
	mov edx, 2 			;tamanho = 2 bytes
	int 80h 			;SYS_CALL

	;ARMAZENA VALOR 8
	mov eax, [num]
	mov [vetor+14], eax

	;IMPRIME NA TELA
	call imprime		

	;LE ENTRADA
	mov eax, 3 			;SYS_READ
	mov ebx, 0 			;STDIN (Terminal)
	mov ecx, num 		;num = (entrada)
	mov edx, 2 			;tamanho = 2 bytes
	int 80h 			;SYS_CALL

	;ARMAZENA VALOR 9
	mov eax, [num]
	mov [vetor+16], eax

	;IMPRIME PRIMEIRA COLUNA
	mov eax, 4 			;SYS_WRITE
	mov ebx, 1 			;STDOUT (Terminal)
	mov ecx, msg2	 	;”Digite um número: “
	mov edx,msg_L2		;18
	int 80h 			;SYS_CALL

	mov eax, 4 			;SYS_WRITE
	mov ebx, 1 			;STDOUT (Terminal)
	mov ecx,vetor 		;”[0][1]“
	mov edx,2			;18
	int 80h 			;SYS_CALL

	mov eax, 4 			;SYS_WRITE
	mov ebx, 1 			;STDOUT (Terminal)
	mov ecx,vetor+6 	;”[0][2]“
	mov edx,2			;18
	int 80h 

	mov eax, 4 			;SYS_WRITE
	mov ebx, 1 			;STDOUT (Terminal)
	mov ecx,vetor+12	;”[0][3]“
	mov edx,2			;18
	int 80h 

	mov eax, 1 ;SYS_EXIT
	mov ebx, 0 ;sem erros
	int 80h ;SYS_CALL
