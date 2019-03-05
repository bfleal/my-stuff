section .data
	salvar db "/slvr"							;comando para salvar
	contador_palavras db "/cpal"				;comando para contar palavra no arquivo
	sair db "/sair"								;comando para sair do programa
	pergunta db "Deseja salvar o conteudo [s/n] ?"	;pergunta ao sair do programa
	tamanho_pergunta equ $-pergunta 			;tamanho da pergunta
	pergunta_sim db "s"							;resposta positiva para a pergunta

section .bss
	nome_arquivo resb 40						;variável que recebe o nome do arquivo
	id_arquivo resd 1 							;variável que recebe o id do arquivo
	informacao resb 10000000					;variável que recebe a informação contida no arquivo, máx 10MB
	bytes_lidos_arquivo resw 1					;variável que recebe a quantidade de caracteres lido do arquivo
	informacao_nova resb 5000000 				;variável que recebe a informação digitada pelo usuário
	bytes_digitados resw 1 						;variável que recebe a qtd de bytes digitados pelo usuário						
	buffer_tamanho resb 1						;variável que recebe o tamanho do buffer
	palavras resb 4 							;variável auxiliar que recebe a qtd de palavras no arquivo, em char
	sair_resposta resb 3 						;variável auxiliar que verifica a resposta dada ao sair do programa
	buffer resb 10 								;variável auxiliar para salvar o conteúdo automaticamente no arquivo
	info resb 1 								;variável auxiliar para imprimir qtd de palavras no arquivo
	posicao resb 4 								;variável auxiliar para executar comando /slvr
	total resb 4 								;variável auxiliar que recebe a qtd total de bytes no arquivo
	pular resb 2 								;variável auxiliar que recebe '\n'

section .text
	global  _start


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MACROS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;printa na tela
%macro escreve 2
	mov eax,4
	mov ebx,1
	mov ecx,%1
	mov edx,%2
	int 80h
%endmacro

;lê nova entrada	
%macro le 2
	mov eax,3 									;SYS_READ
	mov ebx,0 									;STDIN (Terminal)
	mov ecx,%1						;num = (entrada)
	mov edx,%2 							;tamanho = 30 bytes
	int 80h 									;SYS_CALL
%endmacro

;cria arquivo
%macro criaArquivo 2
	mov eax,8
	mov ebx,%1
	mov ecx,0777q
	int 80h

	mov [%2],eax		 						;guardo o identificador do arquivo
	jmp continua 								;continua recebendo entrada do usuário
%endmacro

;abre o arquivo
%macro abreArquivo 2
	mov eax,5									;sys_open
	mov ebx,%1									;ebx recebe o nome do arquivo
	mov ecx,%2									;modo, 0-leitura, 1-escrita, 2-leitura e escrita
	mov edx,0777q								;todas as permissoes
	int 80h										;sys_call
%endmacro

;escreve no arquivo
%macro escreveArquivo 3
	mov eax,4 				
	mov ebx,[%1]
	mov ecx,%2
	mov edx,%3
	int 80h
%endmacro

;lê do arquivo
%macro leArquivo 2
	mov eax, 3									;ler do arquivo
	mov ebx, [%1]								;identificador do arquivo que o usuario passou
	mov ecx, %2									;posição da memória a ser armazenado
	mov edx, 10000000									;tamanho da variável
	int 80h										;sys_call
%endmacro

;fecha o arquivo
%macro fechaArquivo 1
	mov eax, 6
	mov ebx, [%1]	
	int 80h
%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END MACROS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PROCEDURES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;busca o comando "/cpal" na informação digitada pelo usuário
busca_comando_conta_palavras:
	mov edx,0 									;zera o contador
	mov ecx,0 									;zera o contador

	.procura_cpal:								;procura pela sequência "/cpal" no conteúdo digitado pelo usuário
		cmp ecx, 5 								;comando encontrado
		je conta_palavras 						;vai para a procedure que conta palavras no arquivo

		cmp edx,[bytes_digitados] 				;se não, testa cada byte digitado pelo usuário
		je retorna 								;se todos foram testados, sai da procedure

		mov al,[informacao_nova+edx]			;itera sobre toda a informação digitada pelo usuário	
		cmp al,[contador_palavras+ecx]			;procurando por "/cpal"
		je .aumentar 							;se encontrar algum caracter presente no comando, incrementa ecx e edx
		inc edx 								;caso contrário, incrementa apenas edx
		mov ecx,0 								;e zera o contador referente ao comando 
		jmp .procura_cpal 						;continua o loop a procura do comando

	.aumentar: 									;incrementa o contador de bytes lidos e do comando
		inc ecx 								;incrementa contador
		inc edx 								;incrementa contador
		jmp .procura_cpal 						;continua o loop a procura do comando

;busca o comando "/slvr" na informação digitada pelo usuário
busca_comando_salvar:
	mov ecx,0 									;zera o contador
	mov edx,0 									;zera o contador
	
	procura_slvr: 
		cmp ecx, 5 								;comando encontrado
		je grava_no_arquivo 					;vai para a procedure que salva o conteúdo informado no arquivo

		cmp edx,[bytes_digitados] 				;se não, testa cada byte digitado pelo usuário
		je retorna 								;se todos foram testados, sai da procedure

		mov al,[buffer+edx]						;itera sobre o conteúdo de buffer	
		cmp al,[salvar+ecx]						;procurando por "/slvr"
		je .aumentar 							;se encontrar algum caracter presente no comando, incrementa ecx e edx
		inc edx 								;caso contrário, incrementa apenas edx
		mov ecx,0 								;e zera o contador referente ao comando 
		jmp procura_slvr 						;continua o loop a procura do comando

	.aumentar: 									;incrementa o contador de bytes lidos e do comando
		inc ecx 								;incrementa contador
		inc edx 								;incrementa contador
		jmp procura_slvr 						;continua o loop a procura do comando

;busca o comando "/sair" na informação digitada pelo usuário
busca_comando_sair:
	mov ecx,0 									;zera o contador
	mov edx,0 									;zera o contador
	.procura_sair: 
		cmp ecx, 5 								;comando encontrado
		je sai_e_pergunta 						;vai para a procedure que salva o conteúdo informado no arquivo

		cmp edx,[bytes_digitados] 				;se não, testa cada byte digitado pelo usuário
		je retorna 								;se todos foram testados, sai da procedure

		mov al,[buffer+edx]						;itera sobre o conteúdo de buffer	
		cmp al,[sair+ecx]						;procurando por "/sair"
		je .aumentar 							;se encontrar algum caracter presente no comando, incrementa ecx e edx
		inc edx 								;caso contrário, incrementa apenas edx
		mov ecx,0 								;e zera o contador referente ao comando 
		jmp .procura_sair						;continua o loop a procura do comando

	.aumentar: 									;incrementa o contador de bytes lidos e do comando
		inc ecx 								;incrementa contador
		inc edx 								;incrementa contador
		jmp .procura_sair						;continua o loop a procura do comando



;executa o comando '/cpal'
conta_palavras:
		
	;tentar abrir o arquivo
	abreArquivo nome_arquivo, 2

	mov ecx, 0									;zera contador de palavras
	cmp eax,byte 0 								;verifica se o arquivo pôde ser aberto
	jl transforma_caractere						;se não, imprime zero
	mov [id_arquivo],eax						;atribui o identificador do arquivo que esta em eax para id_arquivo
	
	;leitura do arquivo
	leArquivo id_arquivo, informacao
	mov [bytes_lidos_arquivo],eax				;guarda qtd de bytes lidos

	mov ecx,0									;zera o contador de palavras
	mov edx,0									;contador que percorre os caracteres lidos do arquivo

	cmp eax,byte 0								;testa se houve bytes lidos do arquivo
	jl transforma_caractere						;se não houve, imprime direto o valor 0

	.for:
		cmp edx,[bytes_lidos_arquivo]			;testa todos os bytes lidos do arquivo
		je transforma_caractere					;se todos foram testados, sai da procedure
		mov al,[informacao+edx] 				;itera sobre todos conteúdo presente no arquivo
		inc edx 								;incrementa contador de bytes testados
		cmp al, byte 32 						;procura por ' '
		je .proximo 							;encontrado ' ', testa se o próximo caracter também não é ' '	
		cmp al, byte 10
		je .proximo
		jmp .for 								;continua o loop até iterar sobre todos os caracteres lidos do arquivo
	
	.proximo:							
		mov al,[informacao+edx] 				
		cmp al, byte 32  						;teste se não há dois ' ' seguidos	
		je .for 								;se houver, continua o loop
		cmp al, byte 10
		je .for
		inc ecx 								;se não, incrementa o contador de palavras
		jmp .for 								;e continua o loop

;executa o comando '/slvr'
grava_no_arquivo:
	push edx 									;empilha a posição onde a leitura de toda a entrada digitada parou
	mov eax,edx  								;copia esta posição para eax
	sub eax,5 									;ignora a string '/slvr' 
	mov [posicao],eax 							;guarda a posição onde o comando começa em uma variável auxiliar

	;escreve o conteúdo de buffer no arquivo
	escreveArquivo id_arquivo, buffer, [posicao]

	mov ecx,0 									;zera o contador
	pop edx 									;retoma a posição onde e leitura de toda a entrada digitada parou
	jmp procura_slvr 							;continua o processo de leitura da entrada e gravação no arquivo

;executa o comando '/sair'
sai_e_pergunta:
	push edx 									;empilha o valor de edx
	
	;imprime a pergunta se deseja salvar
	escreve pergunta, tamanho_pergunta
	
	;le a resposta (s ou n)
	le sair_resposta, 1

	mov al,[sair_resposta]						;move a resposta para al
	cmp al, [pergunta_sim]						;verifica a resposta 
	je .ok										;se for 's', salva o conteúdo que está e m buffer
	jmp fim_programa 							;caso contrário, encerra o programa

	;salva no documento o que esta no buffer
	.ok:
		pop eax
		sub eax,5
		mov [posicao],eax
		escreveArquivo id_arquivo, buffer, [posicao]
		jmp fim_programa



;seleciona comando
seleciona_comando:
	;chamada da funcao que busca o comando de contar palavras
	call busca_comando_conta_palavras

	;chamada da funcao que busca o comando de salvar
	call busca_comando_salvar	

	;chamada da funcao que busca o comando de sair
	call busca_comando_sair

	ret 

;pega argumentos da linha de comando
busca_argumentos:
	pop ebx
	pop eax										;número de argumentos passados na linha de comando		
	pop ecx										;nome do programa(./nome)
	pop ecx 									;nome do arquivo passado pela linha de comando
	cmp ecx,0 									;compara para ver se existe
	jz sair_fim									;se não existe, sai
	mov edx,0 									;contador

	;tamanho do nome do arquivo passado
	strlen:
		mov al,[ecx+edx]						;guarda em uma variável
		mov [nome_arquivo+edx],al 				;guarda em uma variável
		cmp [ecx+edx],byte 0 					;se 0(/0) então terminou a string
		jz ret 	 								;sai
		inc edx 								;incrementa o contador
		jmp strlen 							;continua o laço
	ret:
		push ebx
		ret
	
;conta qtd de caracteres digitados pelo usuário
conta_caracteres:
	mov edx,0 									;zera contador
	.contador:		
		cmp [informacao_nova+edx],byte 10 		;teste se o usuário digitou enter(\n), final da entrada
		je retorna 								;se sim, retorna
		inc edx 								;se não, incrementa o contador
		jmp .contador 							;continua o loop

;converte a quantidade de palavras(ecx) para caracter e imprime
transforma_caractere:
	;inc ecx 									
	mov eax,ecx     							;eax = qtd de palavras lidas(ecx)
	mov ecx,10									;divisor
	mov ebx,0									;zera o contador
		
	.toChar:
	    mov edx,0   							;zera resto    
        div ecx                        			;dividi edx:eax por 10
        add dl,"0"      						;transforma o resto em caractere
        mov [palavras+ebx],dl      				;coloca o resto em palavras
        inc ebx         						;incrementa o contador
        cmp eax,0      							;compara quociente com 0
        jne .toChar   							;se não for igual, continua dividindo

    .imprime_palavras:
		;a quantidade de caracteres a ser imprimido está em ebx
		dec ebx									;decrementa contador

		mov eax, [palavras+ebx] 				;transfere cada caracter de palavras
		mov [info], eax 						;para uma variável auxiliar 

		push ebx 								;guardo o valor do contador na pilha

		;printa cada caractere de palavras
		escreve info, 1

		pop ebx 								;retoma o contador
		cmp ebx, 0 								;compara com 0(primeiro caractere de palavras)
		jne .imprime_palavras 					;se não for igual a 0 continua imprimindo

		;imprime '\n' para continuar o recebimento de entrada por parte do usuário
		mov [info], byte 10	;coloca '\n' em info
		escreve info, 1
		
		;pop ebx
		jmp continua 	;volta a receber entrada do usuário

;encontrado '/' na informação nova, move os próximos 5 bytes, incluindo '/' para o buffer
prossegue: 
	mov [buffer+edx],bl 				
	inc eax
	inc edx
	mov bl,[informacao_nova+eax]
	mov [buffer+edx],bl
	inc eax
	inc edx
	mov bl,[informacao_nova+eax]
	mov [buffer+edx],bl
	inc eax
	inc edx
	mov bl,[informacao_nova+eax]
	mov [buffer+edx],bl
	inc eax
	inc edx
	mov bl,[informacao_nova+eax]
	mov [buffer+edx],bl
	inc edx
	inc eax
	mov [bytes_digitados],edx
	
	push eax
	call seleciona_comando
	pop eax
	
	mov edx,0
	jmp busca_repeticao

;retorna para o fluxo de execução
retorna:
 	ret 										;retorna


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END PROCEDURES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


_start:
	mov [pular], byte 10

	;busca do argumento passado
	call busca_argumentos

	;abre o arquivo
	abreArquivo nome_arquivo, 2

	;realizar comparação para decidir se precisa criar
	cmp eax,byte 0
	jl cria_arquivo

	mov [id_arquivo],eax		;atribuicao do identificador do arquivo

	;leitura do arquivo
	leArquivo id_arquivo, informacao
	mov [bytes_lidos_arquivo],eax				;guarda qtd de bytes lidos


	;imprime na tela o conteúdo do arquivo
	escreve informacao, [bytes_lidos_arquivo]

	;leitura do novo conteúdo digitado pelo usuário	
	continua:
		le informacao_nova, 5000000

	;zera os contadores
	mov eax,0
	mov ebx,0
	mov ecx,0
	mov edx,0

	;verifica se tem informação para ser gravada automaticamente
 	busca_repeticao:
		cmp edx,10 								;verifica se atingiu o limite do buffer
		je salvar_automaticamente 				;se sim, salva o conteúdo de buffer automaticamente
		
		mov bl,[informacao_nova+eax] 			
		cmp bl, byte 47 						;se não, verifica se há '/' na informação digitada
		je prossegue 							;encontrado '/', pode ser um comando, progresse para a execução do mesmo
		cmp bl, byte 10 						;teste se o usuário digitou enter
		je 	salvar_automaticamente_enter		;se sim, salva automaticamente e continua lendo		
		mov [buffer+edx],bl 					;continua movendo a informação nova para o buffer
		inc eax 								;incrementa o contador da informação nova
		inc edx 								;incrementa o contador do buffer
		jmp busca_repeticao 					;continua o loop 
	
	;salva automaticamente a informação que estiver no buffer, quando ele estiver cheio	
 	salvar_automaticamente: 				
		push eax 								;empilha a posição atual na leitura de toda informação nova
		mov [buffer_tamanho], edx 				;granda a qtd de bytes que esta no buffer

		;salva no arquivo o conteúdo do buffer
		escreveArquivo id_arquivo, buffer, [buffer_tamanho]
		
		mov edx,0 								;zera o contador do buffer
		pop eax 								;retoma a posição atual na leitura da informação nova
		jmp busca_repeticao 					;continua o loop


	;chamada da funcao que conta quantos digitos o usuario digitou
	call conta_caracteres
	mov [bytes_digitados],edx

	;seleciona o comando a ser executado
	call seleciona_comando
	

	;realiza a contagem total de bytes do arquivo
	mov eax,[bytes_lidos_arquivo]
	add [total],eax
	add [total],ecx

	;printar na tela o conteudo do arquivo
	escreve informacao, [total]

	;salva automaticamente a informação que estiver no buffer, quando o usuário digitar enter	
 	salvar_automaticamente_enter: 				
		mov [buffer_tamanho], edx 				
		escreveArquivo id_arquivo, buffer, [buffer_tamanho]
		escreveArquivo id_arquivo, pular, 1
		jmp continua

	;cria arquivo caso não exista
	cria_arquivo:
		criaArquivo nome_arquivo, id_arquivo

	;fecha o arquivo passado pelo usuario
	fim_programa:
		fechaArquivo nome_arquivo

	sair_fim:
		mov eax,1
		mov ebx,0
		int 80h