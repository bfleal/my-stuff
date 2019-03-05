#!/usr/bin/python

from socket import *
serverPort = 12000
serverSocket = socket(AF_INET,SOCK_STREAM)              #cria um socket TCP;
serverSocket.bind((‘’,serverPort))                      #associa o socket ao número da porta do servidor, porém serverSocket é o socket de entrada;
serverSocket.listen(1)                                  #fica em espera(esperando que algum cliente "se apresente"), escuta as requisições TCP;
print ‘The server is ready to receive’
while 1:
	connectionSocket, addr = serverSocket.accept()  #cria o socket de conexão(dedicado) entre o cliente e o servidor e armazena o endereço de origem;
	sentence = connectionSocket.recv(1024)
	capitalizedSentence = sentence.upper()
	connectionSocket.send(capitalizedSentence)
	connectionSocket.close()                        #fecha a conexão entre o cliente e servidor. Mas como serverSocket continua aberto, outro cliente;

