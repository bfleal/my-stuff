section .data
	MsgNome_arq db "Digite o nome do arquivo: ", 10	;nome do arquivo
	msgNome_len equ $-MsgNome_arq
	
	apendice db "(copia).txt", 10
	
	msg db "Hello, World", 10			;mensagem
	msg_len equ $-msg			;tamanho da mensagem

section .bss
      id_out resd 1 				;identificador do arquivo de saída
      id_in resd 1 				;identificador do arquivo de entrada
      nome_arq resb 30 				;nome do arquivo dado pelo usuário
      arq_out resb 41 				;nome do arquivo de saída
      tamanho_nome resd 1 			;tamanho do nome do arquivo de saída
      tamanho_info resd 1 			;tamanho do conteúdo do arquivo de entrada
      info resb 400 				;variável para armazenar o conteúdo
      
      
section .text
	global _start:
	
	
	;FUNCOES
	
	  coloca_fim:
	mov ebx,0			 ;inicializa o contador
	.for:
	    cmp [nome_arq+ebx], byte 10 ;compara com '\n'
	    je .retorna 		;se for igual é o fim da string recebida
	    inc ebx 			;incrementa o contador
	    jmp .for 			;volta para o laço
	.retorna:
	    mov [nome_arq+ebx], byte 0 	;insere 0 (fim da string)
	    ret 			;retorna
	
	
	;Modificar o nome do arquivo que sera criado
  coloca_apendice:
      mov ebx,0 			;inicializa o contador
      mov ecx,0 			;inicializa o contador
      .for:
	  cmp [nome_arq+ebx], byte '.' 	;compara com '.'
	  je .apendice 			;se for igual coloca o apendice
	  mov dl, [nome_arq+ebx] 	;copia o nome do arquivo
	  mov [arq_out+ebx], dl 	;copia o nome do arquivo
	  inc ebx 			;incrementa o contador
	  jmp .for 			;volta para o laço
	  
      .apendice: 			;coloca o apêndice (copia).txt
	  cmp ecx,11 			;compara com 11 (tamanho do apêndice)
	  je .retorna 			;se for igual retorna
	  mov dl, [apend+ecx] 		;copia o apendice
	  mov [arq_out+ebx], dl 	;copia o apendice
	  inc ecx 			;incrementa contador
	  inc ebx 			;incrementa contador
	  jmp .apêndice 		;volta para o laço
	  .retorna: 			;fim do procedimento
	  mov [tamanho_nome],ebx 	;guarda o tamanho do nome de saída
	  ret 	
	  
	  
	  
	  
	
_start:
	;Imprimir mensagem
	mov eax, 4 			;SYS_WRITE
	mov ebx, 1 			;STDOUT (Terminal)
	mov ecx, MsgNome_arq		;”Digite o nome do arquivo: “
	mov edx, msgNome_len		;18
	int 80h 			;SYS_CALL
	
	;Leitura do nome do arquivo fornecido pelo usuario
	mov eax, 3 			;SYS_READ
	mov ebx, 0 			;STDIN (Terminal)
	mov ecx, [nome_arq]		;num = (entrada)
	mov edx, 30 			;tamanho = 2 bytes
	int 80h 			;SYS_CALL	
	
	call coloca_fim
	call coloca_apendice

	  
	  ;Abrir o arquivo	  
	  mov eax, 5			;arquivo já existe no sistema; 8 - cria novo arquivo
	  mov ebx, [nome_arq]	;nome do arquivo
	  mov ecx, 0		;mode de acesso, 0(leitura), 1(escrita) ou 2(leitura + escrita)		
	  mov edx, 0777q		;perimssões
	  int 80h

	  mov [id_in], eax	;guarda o indentificador
	
	
	  ;Ler do arquivo
	  mov eax, 3		;ler do arquivo
	  mov ebx, [id_in]
	  mov ecx, info		;posição da memória a ser armazenado
	  mov edx, 400		;tamanho da variável
	  int 80h
	  push eax		;guarda qtd de bytes lidos
	  
	  ;Print na tela para verificar se esta lendo corretamente do arquivo
	  mov eax, 4		;escrever no arquivo
	  mov ebx, 1
	  mov ecx, info		;posição da memória 
	  mov edx, 10		;tamanho
	  int 80h

	  ;Fechar o arquivo passado pelo usuario
	  mov eax, 6
	  mov abx, [nome_arq]	
	  int 80h
	  
	  ;Criar o arquivo que será a cópia
	  mov eax, 8
	  mov ebx, [arq_out]
	  mov ecx, 0777q
	  int 80h

	  mov [id_out], eax	;guarda o indentificador
	  
	  
	  ;Abrir o arquivo criado
	  mov eax, 5		;arquivo já existe no sistema; 8 - cria novo arquivo
	  mov ebx, [arq_out]	;nome do arquivo
	  mov ecx, 1		;mode de acesso, 0(leitura), 1(escrita) ou 2(leitura + escrita)		
	  mov edx, 0777q		;perimssões
	  int 80h
	  
	  ;Escrever no arquivo
	  mov eax, 4		;escrever no arquivo
	  mov ebx, [id_out]
	  mov ecx, info		;posição da memória 
	  pop edx		;tamanho
	  int 80h
	  
	  ;Fechar arquivo
	  mov eax, 6
	  mov abx, [arq_out]	
	  int 80h
	  
	  mov eax,1
	  mov ebx,0
	  int 80h