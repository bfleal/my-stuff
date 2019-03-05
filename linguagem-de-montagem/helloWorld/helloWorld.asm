section .data 					; declaração de constantes
	msg: db "Hello World", 10	; 10=enter
	msg_L: equ $-msg

section .bss					; variáveis

section .text					; código
	global _start: 				; ponto inicio do código

_start:							; posição inicial 0x1000
	mov eax, 4					; comando para escrever msg
	mov ebx, 1					; comando parar chamar terminal (stdout)
	mov ecx, msg				; "Hello world"
	mov edx, msg_L				; tamanho msg
	int 80h						; escrever (terminal, msg, tamanho)
	
	mov eax, 1					; sair
	mov ebx, 0					; sem erro
	int 80h						; sair (0)
	
