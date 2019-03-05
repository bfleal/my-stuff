section .data

section .bss
	num1 resb 4
	num2 resb 4
	res1 resb 4
	res2 resb 4

section .text
	global _start

_start:

	;leitura do primeiro digito
	mov eax,3 
	mov ebx, 0
	mov ecx, num1
	mov edx,4
	int 80h


	;leitura do segundo digito
	mov eax,3
	mov ebx,0
	mov ecx,num2
	mov edx,4
	int 80h


	;adequando os valores
	mov eax,[num1]
	sub eax,'0'

	mov ebx,[num2]
	sub ebx,'0'


	;soma
	add eax,ebx


	;passos para a divisao
	mov ecx,10
	mov edx,0

	;divisão
	div ecx
	add eax,'0'	;eax recebe o quociente
	add edx,'0'	;edx recebe o resto

	
	;guardar os valores na memoria
	mov [res1],eax
	mov [res2],edx


	;imprimir o resultado de eax
	mov eax,4
	mov ebx,1
	mov ecx,res1
	mov edx,1
	int 80h

	;imprimir o resultado de edx
	mov eax,4
	mov ebx,1
	mov ecx,res2
	mov edx,1
	int 80h

	
	;finalizar o programa
	mov eax, 1 ;SYS_EXIT
	mov ebx, 0 ;sem erros
	int 80h ;SYS_CALL
