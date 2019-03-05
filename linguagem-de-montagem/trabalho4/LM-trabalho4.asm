section .data				;constantes
	msgA db "Matriz A: "		;mensagem para escrever A
	msgLenA equ $-msg		;tamanho da mensagem A
	msgB db "Matriz B: "		;mensagem para escrever B
	msgLenB equ $-msg1		;tamanho da mensagem B
	msgC db "Matriz C: "		;mensagem para escrever C
	msgLenC equ $-msg2		;tamanho da mensagem C
	msgN db "Digite um numero: "	;mensagem para escrever digite um numero
	msgLenN equ $-msg1		;tamanho da mensagem digite numero

section .bss				;variáveis
	matrizA	resb 9*4		
	matrizB resb 9*4
	matrizC	resb 9*4
	
	num resb 5			;receber numero
	aux resb 4			;auxiliar para conversão
	res resb 10			;resultado
	vet resb 8 			;vetor 


section .text
	global _start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MACROS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;MACRO ESCREVER
%macro escrever 2			;inicia macro com dois parâmetros (mensagem, tamanho da msg)
	mov eax,4 			;SYS_WRITE
	mov ebx,1			;STDOUT
	mov ecx,%1			;primeiro parâmetro
	mov edx,%2 			;segundo parâmetro
	int 80h				;interrupção
%endmacro				;finaliza macro

;MACRO LER
%macro ler 2				;macro para ler com dois parâmetros (variável a ser impressa, tamanho da msg)
	mov eax, 3			;SYS_READ
	mov ebx,0			;STDIN
	mov ecx,%1			;primeiro parâmetro - variável
	mov edx,%2			;segundo parâmetro - tamanho
	int 80h				;interrupção
%endmacro				;finaliza macro

;MACRO SOMA
%macro soma 3				;macro com 3 parâmetros (número 1, número 2, resultado)
	push eax			;guardar valor de eax para usá-lo na operação
	mov eax, [%1]			;primeiro parâmetro vai para eax
	add eax, [%2]			;segundo parâmetro é somado e colocado em eax
	mov [%3], eax 			;eax é guardado em uma variável
	pop eax				;retorna valor de eax
%endmacro				;fim do macro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MACROS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PROCEDIMENTOS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

converte_int:
	mov edx,0 			;recebe cada caractere no processo
	mov ebx,0 			;contador
	mov eax,0 			;acumulador
	mov ecx,10 			;multiplicador

	.toINT:
		mul ecx 		;multiplica o valor atual de eax por 10
		mov dl,[num+ebx] 	;coloca o proximo caractere em dl
		sub dl,'0' 		;transforma em numero
		add eax,edx 		;adiciona em eax
		inc ebx			;cont++
		cmp [num+ebx],byte 10 	;verifica se ja chegou ao final da string
		jne .toINT 		;se nao chegou ainda, converte
		ret

converte_char:	
	mov ebx,0 			;zerar ebx
	mov ecx,10 			;usar ecx como divisor

	.toCHAR:
		mov edx,0 		;zera edx
		div ecx 		;divide eax por ecx e o resto fica em edx
		add dl,'0' 		;transforma em caractere
		mov [res+ebx],dl 	;salva em resul na posicao correspondente ebx
		inc ebx 		;cont++
		cmp eax,0 		;verifica se o quociente ja chegou a zero
		jne .toCHAR 		;se nao continua o processo
		ret 			;o valor esta em resul na ordem inversa

print:
	dec ebx 			;ajusta posicao da string que vai ser imprimir
	mov al,[res+ebx] 		;eax recebe o caractere a ser imprimido
	mov [num],al 			;e coloca em num 
	push ebx 			;eax recebe o valor de ebx
	escrever num,1 			;chamar macro para escrita
	pop ebx 			;retorna o valor do contador em ebx
	cmp ebx,0 			;verifica se ja chegou a 0
	jne print 			;se nao chegou, continua imprimindo (ordem inversa)
	escrever pular,1 		;chamar macro para escrita
	ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PROCEDIMENTOS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_start:
;LER MATRIZ A
	mov ecx,0 			;contador
	escrever msgA, msgLenA
	
ler_vetorA: 				;label para ler os dois números e coloca-los em um vetor
	push ecx 			;guarda ecx
	escrever msgN, msgLenN		;escrever mensagem
	ler num,5 			;ler numero	
	call converte_int 		;converter o número para inteiro e guarda em eax
	pop ecx 			;retorna valor de ecx
	mov [matrizA+ecx], eax 		;coloca número no vetor
	add ecx,4 			;adiciona 4 posições no vetor
	cmp ecx,36 			;ver se o vetor já preencheu duas posições
	jne ler_vetorA 			;se não continua lendo numeros
	
	
;LER MATRIZ B
	mov ecx,0 			;contador
	escrever msgB, msgLenB
	
ler_vetorB: 				;label para ler os dois números e coloca-los em um vetor
	push ecx 			;guarda ecx
	escrever msgN, msgLenN		;escrever mensagem
	ler num,5 			;ler numero	
	call converte_int 		;converter o número para inteiro e guarda em eax
	pop ecx 			;retorna valor de ecx
	mov [matrizB+ecx], eax 		;coloca número no vetor
	add ecx,4 			;adiciona 4 posições no vetor
	cmp ecx,36 			;ver se o vetor já preencheu duas posições
	jne ler_vetorB 			;se não continua lendo numeros
	

mov ecx, 0
push ecx
somar_numeros: 				;label para somar
	pop ecx
	soma [matrizA+ecx],[matrizB+ecx],res 		;macro para somar
	mov eax,[res]			;colocar o resultado em eax
	;mov [matrizC+ecx] , eax
	push ecx
	call converte_char 		;converter para string
	mov eax,[res]
	pop ecx
	mov [matrizC+ecx] , eax
	add ecx,4
	push ecx
	call print 			;imprimir numero
	cmp ecx,40
	jne somar_numeros

	exit: 				;label para sair
	mov eax,1 			;eax = 1
	mov ebx,0 			;ebx = 0
	int 80h 			;chama interrupção



