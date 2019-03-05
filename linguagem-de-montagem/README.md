# Linguagem De Montagem

### Instalação NASM ###

Download da versão estável(http://www.nasm.us/pub/nasm/releasebuilds/):
> wget http://www.nasm.us/pub/nasm/releasebuilds/2.11.08/nasm-2.11.08.tar.gz

Comando para descompactar(ou descompactar pela tela gráfica): 
> tar -zxvf nasm-2.11.08.tar.gz

No diretório descompactado, rodar:
> ./configure
> make everything
> make install_everything

Editar o arquivo .bashrc do usuário pelo vim, gedit, nano etc
> vim ~/.bashrc
> Adicionar no fim do arquivo:
> export PATH=$PATH:/export/home/comput/nome-do-user/pasta-onde-foi-instalado/bin

Salvar o arquivo.

### Executando o arquivo ###

Compilar o arquivo:
> nasm -f elf programa.asm

Criar o executável(usar elf_i386 para x64):
> ld -m elf -s -o programaExecutavel programa.o

Executar arquivo:
> ./programaExecutavel
