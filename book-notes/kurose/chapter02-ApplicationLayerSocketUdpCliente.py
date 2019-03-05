#!/usr/bin/python

from socket import *                                            #o módulo socket forma a base para todas as comunicações de rede em Python;
serverName = ‘hostname’                                         #define o serverName, IP do servidor ou hostname("google.com");
serverPort = 12000                                              #porta do servidor;
clientSocket = socket(socket.AF_INET, socket.SOCK_DGRAM)        #cria o socket do cliente, o primeiro paramêtro indica a família do endereço, AF_INET indica que a rede subjacente está usando IPV4, o segundo parâmetro indico que o socket é do tipo SOCK_DGRAM, o que significa que é um socket UDP;
message = raw_input(’Input lowercase sentence:’)                #recebe a mensagem(dados);
clientSocket.sendto(message,(serverName, serverPort))           #o método sendto() acrescenta o endereço de destino(serverName, serverPort) à mensagem;
modifiedMessage, serverAddress = clientSocket.recvfrom(2048)    #os dados dos pacotes que chegam da Internet no socket do cliente e o endereço de origem;
print modifiedMessage                                           #imprime os dados recebidos(mensagem digitada em letra maiúscula);
clientSocket.close()                                            #fecha o socket(processo concluído);
