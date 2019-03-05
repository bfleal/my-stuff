#!/usr/bin/python

from socket import *
serverName = ’servername’
serverPort = 12000
clientSocket = socket(AF_INET, SOCK_STREAM)             #cria o socket do cliente, AF_NET indica que a rede é IPV4 e SOCK_STREAM indica que é cocket TCP;
clientSocket.connect((serverName,serverPort))           #estabele um conexão TCP entre cliente e servidor para poder enviar dados ao mesmo(vice-versa);
sentence = raw_input(‘Input lowercase sentence:’)       #mensagem(dados) de entrada;
clientSocket.send(sentence)                             #envia a cadeia sentence pelo socket do cliente para a conexão TCP;
modifiedSentence = clientSocket.recv(1024)              #recebe a cadeia que chega do servidor;
print ‘From Server:’, modifiedSentence                  #exibe a sentença vinda do servidor;
clientSocket.close()                                    #fecha o socket e, portanto, fecha a conexão TCP entre cliente e servidor;
